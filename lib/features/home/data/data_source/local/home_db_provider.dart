import 'package:caching_data_with_bloc_and_hive/features/home/data/data_source/local/home_db_service.dart';
import 'package:caching_data_with_bloc_and_hive/features/home/data/models/product_model.dart';

import '../../../../../core/helper/log_helper.dart';

class HomeDbProvider {
  final HomeDataBaseService _baseService;

  HomeDbProvider({required HomeDataBaseService baseService})
      : _baseService = baseService;

  Future<ProductsModel?> getProducts() async {
    try {
      return await _baseService.getAll();
    } catch (e) {
      logger.e("error retrieving Product $e");
      return null;
    }
  }

  Future<void> insertProduct({required ProductsModel object}) async {
    try {
      await _baseService.insertItem(object: object);
    } catch (e) {
      logger.e("Error inserting product :$e");
    }
  }


  Future<bool> isProductDataAvailable() async {
    try {
      return _baseService.isDataAvailable();
    } catch (e) {
      logger.e("Error checking if box is empty $e");
      return true;
    }
  }

}
