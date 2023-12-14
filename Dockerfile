FROM dart:stable AS build


WORKDIR /app
COPY pubspec.* ./
RUN dart pub get


COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/main.dart -o bin/main


FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/

CMD ["/app/bin/main"]
