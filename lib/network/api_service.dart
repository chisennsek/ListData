abstract class ApiService {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(String url, {dynamic rpBody});
}
