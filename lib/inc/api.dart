import 'package:appwrite/appwrite.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Client client;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    client = Client()
      ..setEndpoint('https://backend.srv2.catpawz.net/v1')
      ..setProject('670bf524002adc879216')
      ..setSelfSigned(status: false);
  }
}
