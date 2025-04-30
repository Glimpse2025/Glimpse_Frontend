import 'package:glimpse/ApiService.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.0.102:5000';
  static final ApiService apiService = ApiService(baseUrl: baseUrl);
}