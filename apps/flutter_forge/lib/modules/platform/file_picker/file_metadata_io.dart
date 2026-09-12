import 'dart:io';

String fileNameFromPath(String path) => File(path).uri.pathSegments.last;

String fileSizeLabel(String path) {
  try {
    return '${File(path).statSync().size} 字节';
  } on FileSystemException {
    return '无法读取';
  }
}
