FROM gradle:7.4.2-jdk17 AS builder
COPY . .
RUN gradle build --no-daemon
FROM amazoncorretto:17-alpine-jdk
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]