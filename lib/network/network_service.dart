import 'dart:convert';
import 'dart:io';

import 'package:homework_mobile_app_week5/exception/app_exception.dart';
import 'package:homework_mobile_app_week5/network/api_service.dart';
import 'package:http/http.dart' as http;

class NetworkService implements ApiService {
  @override
  Future getApi(String url) async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 120));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return InternalServerException();
      }
    } on SocketException {
      return NoInternetConnection();
    } on RequestTimeOutException {
      return RequestTimeOutException();
    }
  }

  @override
  Future postApi(String url, {rpBody}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(rpBody),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data');
      }
    } on SocketException {
      return NoInternetConnection();
    } on RequestTimeOutException {
      return RequestTimeOutException();
    }
  }
}
