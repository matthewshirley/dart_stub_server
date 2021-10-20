import 'dart:io';

const ENDPOINTS = {
  '/status': {
    'response': {'status': 'ok'}
  }
};

class StubServer {
  final int port;
  late HttpServer _httpServer;

  StubServer({
    this.port = 8000,
  });

  Future<void> create() async {
    final address = InternetAddress.anyIPv4;

    _httpServer = await HttpServer.bind(address, port);
    _httpServer.listen(_onRequest);

    print('Stub listening on $port');
  }

  void _onRequest(HttpRequest request) {
    final path = request.uri.path;
    final matchRequest = ENDPOINTS[path];

    final response = request.response;
    if (matchRequest != null) {
      response.statusCode = 200;

      response.headers.contentType = ContentType("application", "json");
      response.write(matchRequest['response']);
    } else {
      response.statusCode = 404;
    }

    response.close();
  }
}
