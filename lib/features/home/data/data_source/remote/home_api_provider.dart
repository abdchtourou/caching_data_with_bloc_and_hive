import 'package:caching_data_with_bloc_and_hive/config/constant/api_constant.dart';
import 'package:dio/dio.dart';

import '../../../../../core/helper/log_helper.dart';

class HomeApiProvider {
  final Dio dio;

  HomeApiProvider(this.dio);

  dynamic callHomeProductEndPoint() async {
    final requestUrl = EnvironmentVariables.getProducts;
    final response = await dio
        .request(requestUrl, options: Options(method: "GET"))
        .onError((DioException error, stackTrace) {
      logger.e(error.toString());
      throw error;
    });
    return response;
  }
}
