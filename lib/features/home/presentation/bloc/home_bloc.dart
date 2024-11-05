import 'package:bloc/bloc.dart';
import 'package:caching_data_with_bloc_and_hive/core/helper/log_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/resources/data_state.dart';
import '../../data/models/product_model.dart';
import '../../repository/home_repository.dart';
import 'home_status/products_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  late final String privacyPolicy;
  late final String aboutUs;
  late final String termsCondition;
  late final String helpSupport;

  HomeBloc(this._homeRepository)
      : super(HomeState(
    homeProductsStatus: HomeProductsStatusInit(),
  )) {
    on<HomeCallProductsEvent>(_onHomeCallAppSettingsDataEvent);
  }

  /// on call Call Featured Product Data Event
  Future<void> _onHomeCallAppSettingsDataEvent(HomeCallProductsEvent event,
      Emitter<HomeState> emit,) async {
    emit(
      state.copyWith(
        newHomeProductsStatus: HomeProductsStatusLoading(),
      ),
    );

    final DataState dataState = await _homeRepository.fetchProduct();
    print('//////////////////////////////////////////////////////');
    logger.d(dataState.data);

    /// Success
    if (dataState is DataSuccess) {
      print(dataState.data);
      emit(
        state.copyWith(
          newHomeProductsStatus:
          HomeProductsStatusCompleted(dataState.data as ProductsModel),
        ),
      );
    }

    /// Failed
    if (dataState is DataFailed) {
      emit(state.copyWith(
        newHomeProductsStatus:
        HomeProductsStatusError(dataState.error as String),
      ));
    }
  }
}
