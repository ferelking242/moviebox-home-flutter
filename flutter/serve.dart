import 'dart:io';

// Minimal static file server for the Flutter web build, used because the
// container has no python3/node available for a quick static server.
void main() async {
  final webDir = Directory('${Directory.current.path}/build/web');
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 5000);
  print('Serving ${webDir.path} on 0.0.0.0:5000');
  await for (final request in server) {
    var relPath = Uri.decodeFull(request.uri.path);
    if (relPath == '/' || relPath.isEmpty) relPath = '/index.html';
    var file = File('${webDir.path}$relPath');
    if (!await file.exists()) {
      file = File('${webDir.path}/index.html');
    }
    try {
      final bytes = await file.readAsBytes();
      final contentType = _contentType(file.path);
      request.response
        ..headers.contentType = contentType
        ..headers.set('Cache-Control', 'no-store')
        ..statusCode = HttpStatus.ok
        ..add(bytes);
    } catch (_) {
      request.response.statusCode = HttpStatus.notFound;
    }
    await request.response.close();
  }
}

ContentType _contentType(String path) {
  if (path.endsWith('.html')) return ContentType.html;
  if (path.endsWith('.js')) return ContentType('application', 'javascript');
  if (path.endsWith('.json')) return ContentType.json;
  if (path.endsWith('.css')) return ContentType('text', 'css');
  if (path.endsWith('.wasm')) return ContentType('application', 'wasm');
  if (path.endsWith('.png')) return ContentType('image', 'png');
  if (path.endsWith('.svg')) return ContentType('image', 'svg+xml');
  return ContentType.binary;
}
