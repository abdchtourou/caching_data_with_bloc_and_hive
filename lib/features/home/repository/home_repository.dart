import 'package:caching_data_with_bloc_and_hive/features/home/data/data_source/local/home_db_provider.dart';
import 'package:caching_data_with_bloc_and_hive/features/home/data/data_source/remote/home_api_provider.dart';
import 'package:dio/dio.dart';

import '../../../core/helper/log_helper.dart';
import '../../../core/resources/data_state.dart';
import '../data/models/product_model.dart';

class HomeRepository {
  final HomeDbProvider homeDbProvider;
  final HomeApiProvider homeApiProvider;

  HomeRepository(this.homeDbProvider, this.homeApiProvider);

  Future<DataState<dynamic>> fetchProduct() async {
    final bool isConnected = true;
    final bool isDataBaseIsEmpty =
        await homeDbProvider.isProductDataAvailable();
    if (isConnected) {
      try {
        final Response response =
            await homeApiProvider.callHomeProductEndPoint();
        print('abd');
        logger.d(
            "fetch products from the server and catch it in the local DataBase");
        if (response.statusCode == 200 &&
            response.data['success'] == true &&
            (response.data['products'] as List).isNotEmpty) {
          logger.t('in if repoof');

          ProductsModel productsModel = ProductsModel.fromJson(response.data);
          homeDbProvider.insertProduct(object: productsModel);
          final ProductsModel? cachedProduct =
              await homeDbProvider.getProducts();
          logger.d("cached product $cachedProduct");
          return DataSuccess(cachedProduct);
        } else {
          if (!isDataBaseIsEmpty) {
            logger.d("load product from local DataBase");
            final ProductsModel? localSourceResponse =
                await homeDbProvider.getProducts();
            return DataSuccess(localSourceResponse);
          }
          return const DataFailed("Unknown Error Happened !");
        }
      } catch (e) {
        if (!isDataBaseIsEmpty) {
          logger.d("load product from local DataBase");
          final ProductsModel? localSourceResponse =
              await homeDbProvider.getProducts();
          return DataSuccess(localSourceResponse);
        } else {
          return const DataFailed("Unknown Error Happened !");
        }
      }
    } else {
      if (!isDataBaseIsEmpty) {
        logger.d("load product from local DataBase");
        final ProductsModel? localSourceResponse =
            await homeDbProvider.getProducts();
        return DataSuccess(localSourceResponse);
      } else {
        return const DataFailed("No Network Connection !");
      }
    }
  }
}
