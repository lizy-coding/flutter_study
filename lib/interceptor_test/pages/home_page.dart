import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/article.dart';
import '../network/api/api_service.dart';
import '../network/interceptor/auth_interceptor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _baseRoute = '/interceptor-test';

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  List<Article> _articles = [];
  int _currentPage = 1;
  int _totalPages = 1;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadArticles();
  }
  
  /// 加载文章列表
  Future<void> _loadArticles() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final result = await _apiService.getArticles(page: _currentPage);
      
      if (result['success'] == true && result['data'] != null) {
        final articlesData = result['data']['articles'] as List;
        final articles = articlesData.map((json) => Article.fromJson(json)).toList();
        
        setState(() {
          _articles = articles;
          _totalPages = result['data']['totalPages'] as int;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? '加载文章失败';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败: $e';
        _isLoading = false;
      });
    }
  }
  
  /// 刷新文章列表
  Future<void> _refreshArticles() async {
    _currentPage = 1;
    await _loadArticles();
  }
  
  /// 加载下一页
  Future<void> _loadNextPage() async {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      await _loadArticles();
    }
  }
  
  /// 加载上一页
  Future<void> _loadPreviousPage() async {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      await _loadArticles();
    }
  }
  
  /// 打开登录页面
  void _openLoginPage() async {
    final result = await context.push<bool>('$_baseRoute/login');
    
    if (result == true) {
      // 登录成功，刷新文章列表
      await _refreshArticles();
    }
  }
  
  /// 退出登录
  void _logout() {
    AuthInterceptor.clearToken();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已退出登录')),
    );
    _refreshArticles();
  }
  
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthInterceptor.getToken() != null;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('文章列表'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: '退出登录',
            )
          else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: _openLoginPage,
              tooltip: '登录',
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: _showAddArticleDialog,
              tooltip: '添加文章',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
  
  /// 构建页面主体
  Widget _buildBody() {
    if (_isLoading && _articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null && _articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '错误: $_errorMessage',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshArticles,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }
    
    if (_articles.isEmpty) {
      return const Center(child: Text('没有文章'));
    }
    
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshArticles,
            child: ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(article.content),
                        const SizedBox(height: 4),
                        Text(
                          '作者: ${article.author} · ${_formatDate(article.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ),
        _buildPagination(),
      ],
    );
  }
  
  /// 构建分页控件
  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _currentPage > 1 ? _loadPreviousPage : null,
            tooltip: '上一页',
          ),
          Text('$_currentPage / $_totalPages'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _currentPage < _totalPages ? _loadNextPage : null,
            tooltip: '下一页',
          ),
        ],
      ),
    );
  }
  
  /// 显示添加文章对话框
  void _showAddArticleDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    // Store the scaffold messenger context
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('添加文章'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '请输入文章标题',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: '内容',
                hintText: '请输入文章内容',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              
              if (title.isEmpty || content.isEmpty) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('标题和内容不能为空')),
                );
                return;
              }
              
              Navigator.pop(dialogContext);
              
              // 显示加载指示器
              setState(() {
                _isLoading = true;
              });
              
              try {
                final result = await _apiService.createArticle(title, content);
                
                // Check if the widget is still mounted before updating UI
                if (!mounted) return;
                
                if (result['success'] == true) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text('文章创建成功')),
                  );
                  await _refreshArticles();
                } else {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(result['message'] ?? '文章创建失败')),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                }
              } catch (e) {
                // Check if the widget is still mounted before updating UI
                if (!mounted) return;
                
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('创建失败: $e')),
                );
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }
  
  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
} 
