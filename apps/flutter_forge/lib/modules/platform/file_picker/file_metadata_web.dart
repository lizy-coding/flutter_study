String fileNameFromPath(String path) {
  final uri = Uri.tryParse(path);
  return uri?.pathSegments.lastOrNull ?? path;
}

String fileSizeLabel(String path) => '由浏览器管理';
