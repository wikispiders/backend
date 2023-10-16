import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

Router myRouter() {
  final router = Router();

  router.get('/', _rootHandler);
  router.get('/echo/<message>', _echoHandler);

  return router;
}

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}