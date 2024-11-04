import 'package:homework_mobile_app_week5/model/category.dart';
import 'package:homework_mobile_app_week5/model/product.dart';
import 'package:homework_mobile_app_week5/network/api_end_point.dart';
import 'package:homework_mobile_app_week5/network/network_service.dart';

class MainRepository {
  final NetworkService _api = NetworkService();

  Future<ProductResponse> getProduct(int page, int limit) async {
    final response = await _api.getApi(
        '${ApiEndPoint.baseUrl}${ApiEndPoint.getProduct}?skip=${(page - 1) * limit}&limit=$limit');

    print(response);
    return ProductResponse.fromJson(response);
  }

  Future<List<CategoriesResponse>> getAllCategories() async {
    final response =
        await _api.getApi(ApiEndPoint.baseUrl + ApiEndPoint.getAllCatogories);

    if (response is List<dynamic>) {
      return response.map((json) => CategoriesResponse.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<List<Product>> getProductByCategory(
      String categorySlug, int page, int limit) async {
    final response = await _api.getApi(
        '${ApiEndPoint.baseUrl}${ApiEndPoint.getAllCategoriesSlug}$categorySlug?skip=${(page - 1) * limit}&limit=$limit');

    print("Response$response");
    if (response is Map<String, dynamic>) {
      if (response['status'] == 'error') {
        throw Exception('Error: ${response['message']}');
      }

      List<dynamic> productsJson = response['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }
}
