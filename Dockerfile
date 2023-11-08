FROM dart:stable AS build


WORKDIR /app
COPY pubspec.* ./
RUN dart pub get


COPY . .
RUN dart compile exe bin/main.dart -o bin/main


FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/main /app/bin/


EXPOSE 8080
EXPOSE 8081

CMD ["/app/bin/main"]
