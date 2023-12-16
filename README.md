# Trivia Goat Backend

El presente repositorio contiene el código backend del juego Trivia Goat, cuya aplicación cliente de interfaz de usuario está derrollado en [este enlace](https://github.com/wikispiders/trivia-goat).

Este es un servidor WebSocket hecho en el lenguaje Dart que escucha solicitudes en el puerto `PORT`, indicado por variable de entorno.

## Configuración
Si no se quiere trabajar con los valores definidos por defecto, se debe agregar un archivo `.env` en la raíz del proyecto con el siguiente contenido.

```bash
LOG_LEVEL=DEBUG
PORT=4040
```

El valor de LOG_LEVEL puede ser uno entre DEBUG, INFO y SEVERE. Si no se agrega, por defecto es INFO.
El valor de PORT debe ser un número. Si no se agrega, por defecto es DEBUG.


## Cómo ejecutarlo?

### Usando la [SDK de Dart](https://dart.dev/get-dart)
El servidor puede ser levantado usando la máquina virtual de Dart. Recomendamos este comando para ambientes de desarrollo, dado que el código es interpretado y la eficiencia no es la óptima.

```bash
$ dart run bin/main.dart
```
El servicio se puede frenar simplemente enviando la señal SIGINT (presionando CTRL+C).


## Usando Docker
Dart ofrece también una imagen estable de Docker en la que se puede ejecutar el programa. Creamos el archivo `Dockerfile` en el que se compila el programa para poder ser corrido más eficientemente en entornos de producción.

Para correrlo, ejecutar.
```bash
docker-compose up --build
```

Para frenarlo, ejecutar.

```bash
docker-compose down
```
