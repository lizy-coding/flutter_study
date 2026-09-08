import 'package:dio/dio.dart';

import 'web_mock_http_adapter.dart';

void configurePlatformAdapter(Dio dio) {
  dio.httpClientAdapter = WebMockHttpClientAdapter();
}
