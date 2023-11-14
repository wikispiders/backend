# backend

## TODO
1. Mejorar logs: agregar cuando mandamos errores.
2. Enviar estadisticas finales. Falta crear una clase Stats que dependa de Questions que mantenga las estadisticas.
3. Agregar test: terminar el test de integracion.
4. Resolver problemas de linter y chequeos estaticos.
5. Cambiar el dockerfile y dockercompose para que ande.
6. Agregar variables de entorno de logging en .env.
7. Integracion con ChatGPT para obtener las preguntas.
8. Cambiar variables publicas a privadas.
9. Chequear Race Conditions.
10. Resolver TODOs en el codigo.

## Run
```bash
docker-compose up --build
```

## Stop
```bash
docker-compose down
```


A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /echo/I_love_Dart
```