// import 'package:shelf_router/shelf_router.dart';
// import 'package:shelf/shelf.dart';
// import '../src/lobby/lobby.dart';
// import 'package:shelf_web_socket/shelf_web_socket.dart' as sws;

// class Service {
//   Handler httpHandler(Lobby lobby) {
//     final router = Router();

//     router.get('/', (Request request) async {
//       await Future<void>.delayed(Duration(milliseconds: 100));
//       print("Lllega un mensaje al server");
//       return Response.ok('Hello, World!\n');
//     });

//     router.get('/echo/<message>', (Request request, String message) {
//       return Response.ok(message);
//     });

//     router.get('/ws', (Request request) {
//       return sws.webSocketHandler(lobby.hi)(request);
//     });

//     router.get('/create', (Request request) {
//       return sws.webSocketHandler(lobby.create)(request);
//     });


//     router.post('/join/<gameid>', (Request request, String gameid) {
//       return sws.webSocketHandler((webSocket) {
//         lobby.join(webSocket, gameid);
//       });
//     });


//     router.all('/<ignored|.*>', (Request request) {
//       return Response.notFound('Page not found');
//     });

//     return router;
//   }
// }
