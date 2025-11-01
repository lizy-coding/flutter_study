import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 日志拦截器
/// 用于打印网络请求和响应信息，方便调试
class LoggingInterceptor extends Interceptor {
  // 记录请求开始时间
  final Map<String, int> _requestStartTime = {};
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 记录请求开始时间
    _requestStartTime[options.uri.toString()] = DateTime.now().millisecondsSinceEpoch;
    
    if (kDebugMode) {
      print('┌────────────────────────────────────────────────────────────────────────────────────────────────────');
      print('│ 请求 [${options.method}] → ${options.uri}');
      
      if (options.headers.isNotEmpty) {
        print('│ Headers:');
        options.headers.forEach((key, value) {
          print('│   $key: $value');
        });
      }
      
      if (options.data != null) {
        print('│ Body: ${options.data}');
      }
      
      if (options.queryParameters.isNotEmpty) {
        print('│ QueryParameters:');
        options.queryParameters.forEach((key, value) {
          print('│   $key: $value');
        });
      }
      
      print('└────────────────────────────────────────────────────────────────────────────────────────────────────');
    }
    
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 计算请求耗时
    final requestUrl = response.requestOptions.uri.toString();
    final startTime = _requestStartTime[requestUrl];
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final duration = startTime != null ? endTime - startTime : null;
    
    // 请求完成后清除记录
    _requestStartTime.remove(requestUrl);
    
    if (kDebugMode) {
      print('┌────────────────────────────────────────────────────────────────────────────────────────────────────');
      print('│ 响应 [${response.statusCode}] ← ${response.requestOptions.uri}');
      
      if (duration != null) {
        print('│ 耗时: ${duration}ms');
      }
      
      if (response.headers.isEmpty == false) {
        print('│ Headers:');
        response.headers.forEach((key, values) {
          print('│   $key: ${values.join(', ')}');
        });
      }
      
      print('│ 响应数据:');
      printWrapped(response.data.toString());
      
      print('└────────────────────────────────────────────────────────────────────────────────────────────────────');
    }
    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 计算请求耗时
    final requestUrl = err.requestOptions.uri.toString();
    final startTime = _requestStartTime[requestUrl];
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final duration = startTime != null ? endTime - startTime : null;
    
    // 请求完成后清除记录
    _requestStartTime.remove(requestUrl);
    
    if (kDebugMode) {
      print('┌────────────────────────────────────────────────────────────────────────────────────────────────────');
      print('│ 错误 [${err.response?.statusCode ?? "未知状态码"}] ← ${err.requestOptions.uri}');
      print('│ 类型: ${err.type}');
      
      if (duration != null) {
        print('│ 耗时: ${duration}ms');
      }
      
      print('│ 消息: ${err.message}');
      
      if (err.response != null) {
        print('│ 响应数据:');
        printWrapped(err.response.toString());
      }
      
      print('└────────────────────────────────────────────────────────────────────────────────────────────────────');
    }
    
    handler.next(err);
  }
  
  /// 格式化打印较长的内容
  void printWrapped(String text) {
    const int maxLength = 100;
    final pattern = RegExp('.{1,$maxLength}');
    
    pattern.allMatches(text).forEach((match) {
      if (kDebugMode) {
        print('│   ${match.group(0)}');
      }
    });
  }
} 