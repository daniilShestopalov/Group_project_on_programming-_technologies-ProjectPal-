FROM gradle:8.7-jdk17 AS builder
COPY . .
RUN gradle build --no-daemon
FROM amazoncorretto:17-alpine-jdk
WORKDIR /app
COPY --from=builder /home/gradle/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]