# AI 模块分析: interceptor_test

> Dio 拦截器链路演示，包含本地 Mock Server。

## 功能

展示 HTTP 请求的完整拦截器链路：认证、错误处理、重试、日志记录，配合内置 Mock Server 进行测试。

## 文件结构

```
interceptor_test/
├── module_entry.dart              # 入口: FutureBuilder 启动 Mock Server
├── pages/
│   ├── home_page.dart             # 文章列表 + 分页 + 登录/登出
│   └── login_page.dart            # 登录页面
├── network/
│   ├── http_client.dart           # Dio 单例，配置 4 个拦截器
│   ├── interceptor/
│   │   ├── auth_interceptor.dart  # 认证拦截器: 附加 Token
│   │   ├── error_interceptor.dart # 错误拦截器: 统一错误处理
│   │   ├── retry_interceptor.dart # 重试拦截器: 自动重试
│   │   └── log_interceptor.dart   # 日志拦截器: 调试日志
│   └── api/
│       └── api_service.dart       # API 服务层
├── mock_server/
│   └── mock_server.dart           # 本地 Mock HTTP 服务器
└── models/
    └── article.dart               # 文章模型
```

## 拦截器执行顺序

```
Request → AuthInterceptor → RetryInterceptor → LogInterceptor → Server
Response ← ErrorInterceptor ← LogInterceptor ← RetryInterceptor ← Server
```

## Mock Server API

| 端点 | 方法 | 说明 |
|------|------|------|
| /login | POST | 登录，返回 token |
| /articles | GET | 获取文章列表（分页） |
| /articles | POST | 添加文章（需认证） |

## 修改建议

- 新增拦截器: 在 network/interceptor/ 中创建，按顺序添加到 Dio
- 扩展 Mock Server: 添加新的端点响应
- Token 刷新: 在 AuthInterceptor 中实现 401 时自动刷新 token
