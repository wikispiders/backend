import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../src/lobby/lobby.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart' as sws;

class Service {
  Handler httpHandler(Lobby lobby) {
    final router = Router();

    router.get('/', (Request request) async {
      await Future<void>.delayed(Duration(milliseconds: 100));
      return Response.ok('Hello, World!\n');
    });

    router.get('/echo/<message>', (Request request, String message) {
      return Response.ok(message);
    });

    router.get('/ws', (Request request) {
      return sws.webSocketHandler(lobby.hi)(request);
    });


    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }


  Handler webSocketHandler(Lobby lobby) {
    var webSocketHandler = sws.webSocketHandler(lobby.hi);
    return webSocketHandler;
  }
}
