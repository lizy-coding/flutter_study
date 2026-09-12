import 'package:dio/dio.dart';
import 'package:flutter_forge_app/modules/platform/dio_interceptor/network/web_mock_http_adapter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Dio dio;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080'))
      ..httpClientAdapter = WebMockHttpClientAdapter();
  });

  test('Web adapter preserves login, auth and article workflow', () async {
    final login = await dio.post<Map<String, dynamic>>(
      '/api/login',
      data: {'username': 'admin', 'password': 'password123'},
    );
    final loginData = login.data!['data'] as Map<String, dynamic>;
    final token = loginData['token'] as String;

    final articles = await dio.get<Map<String, dynamic>>(
      '/api/articles',
      queryParameters: {'page': 1, 'pageSize': 10},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final articleData = articles.data!['data'] as Map<String, dynamic>;
    expect(articleData['articles'], isA<List<dynamic>>());
    expect(articleData['totalPages'], 2);

    final created = await dio.post<Map<String, dynamic>>(
      '/api/articles/create',
      data: {'title': 'Web article', 'content': 'Browser-safe mock'},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    expect(created.statusCode, 201);
    expect((created.data!['data'] as Map<String, dynamic>)['author'], 'admin');
  });

  test('Web adapter rejects article requests without a token', () async {
    await expectLater(
      dio.get<Map<String, dynamic>>('/api/articles'),
      throwsA(
        isA<DioException>().having(
          (error) => error.response?.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
  });
}
