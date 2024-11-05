import 'package:flutter/material.dart';

import '../../../data/models/product_model.dart';

@immutable
abstract class HomeProductsStatus {}

class HomeProductsStatusInit extends HomeProductsStatus {}

class HomeProductsStatusLoading extends HomeProductsStatus {}

class HomeProductsStatusError extends HomeProductsStatus {
  final String errorMsg;
  HomeProductsStatusError(this.errorMsg);
}

class HomeProductsStatusCompleted extends HomeProductsStatus {
  final ProductsModel products;
  HomeProductsStatusCompleted(this.products);
}