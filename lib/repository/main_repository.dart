import 'package:homework_mobile_app_week5/model/product.dart';
import 'package:homework_mobile_app_week5/network/api_end_point.dart';
import 'package:homework_mobile_app_week5/network/network_service.dart';

class MainRepository {
  final NetworkService _api = NetworkService();

  Future<ProductResponse> getProduct() async {
    final response =
        await _api.getApi(ApiEndPoint.baseUrl + ApiEndPoint.getProduct);

    return ProductResponse.fromJson(response);
  }
}
