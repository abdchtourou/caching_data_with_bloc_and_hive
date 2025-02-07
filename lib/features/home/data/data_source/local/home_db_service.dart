import 'package:hive/hive.dart';

import '../../../../../config/constant/db_keys.dart';
import '../../../../../core/helper/log_helper.dart';
import '../../../../../core/repos/interface_repository.dart';
import '../../models/product_model.dart';

class HomeDataBaseService implements InterfaceRepository<ProductsModel> {
  /// Box Key
  static const String _key = DbKeys.dbProducts;

  /// Products Box
  late final Box<ProductsModel> _productsBox;

  HomeDataBaseService();

  /// init DB
  Future<void> initDataBase() async {
    try {
      Hive.registerAdapter(ProductsModelAdapter());
      Hive.registerAdapter(ProductAdapter());
      _productsBox = await Hive.openBox(_key);
      logger.d('Success on initializing database For *ProductsModel*');
    } catch (e) {
      // Handle initialization errors
      logger.e('Error initializing database For *ProductModel*');
    }
  }

  @override
  Future<ProductsModel?> getAll() async {
    try {
      logger.e("asdfasd ${_productsBox.isOpen}  ${_productsBox.isNotEmpty}");
      if (_productsBox.isOpen && _productsBox.isNotEmpty) {
        return _productsBox.get(_key);
      } else {
        return null;
      }
    } catch (e) {
      // Handle read errors
      logger.e('Error reading from database: $e');
    }

    return null;
  }

  @override
  Future<void> insertItem({required ProductsModel object}) async {
    try {
      await _productsBox.put(_key, object);
    } catch (e) {
      // Handle insertion errors
      logger.e('Error inserting into database: $e');
    }
  }

  @override
  Future<bool> isDataAvailable() async {
    try {
      return _productsBox.isEmpty;
    } catch (e) {
      // Handle error checking box emptiness
      logger.e('Error checking if box is empty: $e');
      return true; // Return true assuming it's empty on error
    }
  }
}