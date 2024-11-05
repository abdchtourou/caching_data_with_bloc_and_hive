import 'package:caching_data_with_bloc_and_hive/core/dependency_injection/di_ex.dart';
import 'package:caching_data_with_bloc_and_hive/core/pages/error_page.dart';
import 'package:caching_data_with_bloc_and_hive/core/utils/custom_alert.dart';
import 'package:caching_data_with_bloc_and_hive/features/home/data/models/product_model.dart';
import 'package:caching_data_with_bloc_and_hive/features/home/presentation/bloc/home_status/products_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../../core/dependency_injection/di.dart';
import '../../../../core/utils/custom_loading_widget.dart';
import '../widget/home_single_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size;
    double height, width;
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Column(
          children: [
            Text("Caching Data with Bolc & Hive"),
          ],
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: BlocConsumer<HomeBloc, HomeState>(
          buildWhen: (pre, curr) {
            return pre.homeProductsStatus != curr.homeProductsStatus;
          },
          listenWhen: (pre, curr) {
            return pre.homeProductsStatus != curr.homeProductsStatus;
          },
          builder: (context, state) {
            if (state.homeProductsStatus is HomeProductsStatusInit) {
              return Container();
            }
            if (state.homeProductsStatus is HomeProductsStatusLoading) {
              return CustomLoading.showWithStyle(context);
            }
            if (state.homeProductsStatus is HomeProductsStatusError) {
              final HomeProductsStatusError homeProductsStatusError =
                  state.homeProductsStatus as HomeProductsStatusError;
              final String error = homeProductsStatusError.errorMsg;
              // return CustomAlert.show(context, error);
              return CommonErrorPage(
                isForNetwork: true,
                description: error,
                onRetry: () {
                  context.read<HomeBloc>().add(HomeCallProductsEvent());

                },
              );
            }
            if (state.homeProductsStatus is HomeProductsStatusCompleted) {
              final HomeProductsStatusCompleted homeProductsStatusCompleted =
                  state.homeProductsStatus as HomeProductsStatusCompleted;
              final ProductsModel productsModel =
                  homeProductsStatusCompleted.products;
              return LiquidPullToRefresh(
                backgroundColor: theme.scaffoldBackgroundColor,
                color: theme.primaryColor,
                showChildOpacityTransition: true,
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context)
                      .add(HomeCallProductsEvent());
                },
                child: ListView.builder(
                    itemCount: productsModel.products.length,
                    itemBuilder: (context, index) {
                      final Product current = productsModel.products[index];

                      return HomeSingeListItem(
                        current: current,
                      );
                    }),
              );
            }
            return Container();
          },
          listener: (context, state) async {
            if (state.homeProductsStatus is HomeProductsStatusCompleted) {
              final HomeProductsStatusCompleted homeProductsStatusCompleted =
                  state.homeProductsStatus as HomeProductsStatusCompleted;
              final ProductsModel productsModel =
                  homeProductsStatusCompleted.products;
              final bool isConnected = await di<InternetConnectionHelper>()
                  .checkInternetConnection();
              final String msg =
                  isConnected ? "From Server " : "From Local Storage";
              CustomAlert.show(context, productsModel.message + msg);
            }
          },
        ),
      ),
    );
  }
}
