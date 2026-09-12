import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Browser-safe transport for the module's existing login and article APIs.
class WebMockHttpClientAdapter implements HttpClientAdapter {
  WebMockHttpClientAdapter() {
    _articles.addAll(
      List.generate(
        20,
        (index) => {
          'id': index + 1,
          'title': '文章标题 ${index + 1}',
          'content': '这是文章 ${index + 1} 的内容，用于测试拦截器功能。',
          'author': index.isOdd ? 'admin' : 'user',
          'createdAt': DateTime.now()
              .subtract(Duration(days: 19 - index))
              .toIso8601String(),
        },
      ),
    );
  }

  final List<Map<String, Object?>> _articles = [];
  final Map<String, String> _tokens = {};
  int _tokenSequence = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final result = switch ((options.method, options.uri.path)) {
      ('POST', '/api/login') => _login(options),
      ('POST', '/api/refresh-token') => _refresh(options),
      ('GET', '/api/articles') => _listArticles(options),
      ('POST', '/api/articles/create') => _createArticle(options),
      _ => (
        404,
        <String, Object?>{
          'success': false,
          'message': '404 Not Found: ${options.uri.path}',
        },
      ),
    };
    return ResponseBody.fromString(
      jsonEncode(result.$2),
      result.$1,
      headers: const {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }

  (int, Map<String, Object?>) _login(RequestOptions options) {
    final data = _mapData(options.data);
    final username = data['username'];
    final password = data['password'];
    final valid =
        (username == 'admin' && password == 'password123') ||
        (username == 'user' && password == 'user123');
    if (!valid) {
      return (401, {'success': false, 'message': '用户名或密码错误'});
    }
    final token = 'web-token-${++_tokenSequence}';
    final refreshToken = 'web-refresh-$_tokenSequence';
    _tokens[token] = username! as String;
    return (
      200,
      {
        'success': true,
        'data': {
          'token': token,
          'refreshToken': refreshToken,
          'expiresIn': 3600,
          'username': username,
        },
      },
    );
  }

  (int, Map<String, Object?>) _refresh(RequestOptions options) {
    final refreshToken = _mapData(options.data)['refreshToken'];
    if (refreshToken is! String || !refreshToken.startsWith('web-refresh-')) {
      return (401, {'success': false, 'message': '无效的刷新令牌'});
    }
    final token = 'web-token-${++_tokenSequence}';
    _tokens[token] = 'admin';
    return (
      200,
      {
        'success': true,
        'data': {
          'token': token,
          'refreshToken': 'web-refresh-$_tokenSequence',
          'expiresIn': 3600,
          'username': 'admin',
        },
      },
    );
  }

  (int, Map<String, Object?>) _listArticles(RequestOptions options) {
    final username = _authorizedUser(options);
    if (username == null) return _unauthorized();
    final page = int.tryParse('${options.queryParameters['page'] ?? 1}') ?? 1;
    final pageSize =
        int.tryParse('${options.queryParameters['pageSize'] ?? 10}') ?? 10;
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, _articles.length);
    final articles = start < _articles.length
        ? _articles.sublist(start, end)
        : <Map<String, Object?>>[];
    return (
      200,
      {
        'success': true,
        'data': {
          'articles': articles,
          'total': _articles.length,
          'page': page,
          'pageSize': pageSize,
          'totalPages': (_articles.length / pageSize).ceil(),
        },
      },
    );
  }

  (int, Map<String, Object?>) _createArticle(RequestOptions options) {
    final username = _authorizedUser(options);
    if (username == null) return _unauthorized();
    final data = _mapData(options.data);
    final title = data['title'];
    final content = data['content'];
    if (title is! String || content is! String) {
      return (400, {'success': false, 'message': '缺少标题或内容'});
    }
    final article = <String, Object?>{
      'id': _articles.length + 1,
      'title': title,
      'content': content,
      'author': username,
      'createdAt': DateTime.now().toIso8601String(),
    };
    _articles.add(article);
    return (201, {'success': true, 'data': article});
  }

  String? _authorizedUser(RequestOptions options) {
    final authorization = options.headers['Authorization'];
    if (authorization is! String || !authorization.startsWith('Bearer ')) {
      return null;
    }
    return _tokens[authorization.substring(7)];
  }

  (int, Map<String, Object?>) _unauthorized() =>
      (401, {'success': false, 'message': '未授权，缺少有效的认证信息'});

  Map<String, Object?> _mapData(Object? data) {
    if (data is Map<String, Object?>) return data;
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, Object?>) return decoded;
    }
    return const {};
  }

  @override
  void close({bool force = false}) {}
}
