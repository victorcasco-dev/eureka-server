# syntax=docker/dockerfile:1.7
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build/app
COPY pom.xml ./
COPY src ./src
RUN --mount=type=cache,target=/root/.m2,sharing=locked mvn -B -q package -DskipTests \
    && find target -maxdepth 1 -name '*.jar' ! -name '*-plain.jar' -exec cp {} /build/app.jar \;

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /build/app.jar app.jar
ENV JAVA_OPTS="-XX:MaxRAMPercentage=60"
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]
