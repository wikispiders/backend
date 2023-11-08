import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../src/lobby/lobby.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart' as sWs;

class Service {
  Handler httpHandler() {
    final router = Router();

    router.get('/say-hi/<name>', (Request request, String name) {
      return Response.ok('hi $name');
    });

    router.get('/wave', (Request request) async {
      await Future<void>.delayed(Duration(milliseconds: 100));
      return Response.ok('_o/');
    });

    router.all('/<ignored|.*>', (Request request) {
      return Response.notFound('Page not found');
    });

    return router;
  }


  Handler webSocketHandler(Lobby lobby) {
    var webSocketHandler = sWs.webSocketHandler(lobby.hi);
    return webSocketHandler;
  }
}
