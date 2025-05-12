import 'package:glimpse/features/authentication/data/authentication_service.dart';
import 'package:glimpse/features/common/data/api_service.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.0.102:5000';
  static final AuthenticationService authenticationService = AuthenticationService(baseUrl: baseUrl);
}