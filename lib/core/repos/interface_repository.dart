import '../../features/home/data/models/product_model.dart';

abstract class InterfaceRepository<T> {
  Future<T?> getAll();

  Future<void> insertItem({required ProductsModel object});

  Future<bool> isDataAvailable();
}
