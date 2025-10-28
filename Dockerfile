# syntax=docker/dockerfile:1

# Multi-stage build using golden base images
# Build Stage - Includes development tools and dependencies
################################################################################

# Create a stage for resolving and downloading dependencies.
#FROM eclipse-temurin:21-jdk-jammy AS deps

# Update to DHI golden base images for immediate security improvement:
FROM demonstrationorg/dhi-temurin:21-jdk-alpine3.21-dev@sha256:d32f08b3aa18668323a82e3ffb297cb1030dc1ed0d85b9786204538ab6e1a32a AS deps

WORKDIR /build

# Copy the mvnw wrapper with executable permissions and maven wrapper config
COPY --chmod=0755 mvnw mvnw
COPY .mvn/ .mvn/
#COPY pom.xml .

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.m2 so that subsequent builds don't have to
# re-download packages.
#RUN --mount=type=cache,target=/root/.m2 ./mvnw dependency:go-offline -DskipTests
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 ./mvnw dependency:go-offline -DskipTests
################################################################################

# Create a stage for building the application based on the stage with downloaded dependencies.
# This Dockerfile is optimized for Java applications that output an uber jar, which includes
# all the dependencies needed to run your app inside a JVM. If your app doesn't output an uber
# jar and instead relies on an application server like Apache Tomcat, you'll need to update this
# stage with the correct filename of your package and update the base image of the "final" stage
# use the relevant app server, e.g., using tomcat (https://hub.docker.com/_/tomcat/) as a base image.
FROM deps AS package

WORKDIR /build

COPY ./src src/
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw package -DskipTests && \
    mv target/$(./mvnw help:evaluate -Dexpression=project.artifactId -q -DforceStdout)-$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout).jar target/app.jar

################################################################################

# Create a stage for extracting the application into separate layers.
# Take advantage of Spring Boot's layer tools and Docker's caching by extracting
# the packaged application into separate layers that can be copied into the final stage.
# See Spring's docs for reference:
# https://docs.spring.io/spring-boot/docs/current/reference/html/container-images.html
FROM package AS extract

WORKDIR /build

RUN java -Djarmode=layertools -jar target/app.jar extract --destination target/extracted

################################################################################

# Create a new stage for running the application that contains the minimal
# runtime dependencies for the application. This often uses a different base
# image from the install or build stage where the necessary files are copied
# from the install stage.
#
# The example below uses eclipse-turmin's JRE image as the foundation for running the app.
# By specifying the "21-jre-jammy" tag, it will also use whatever happens to be the
# most recent version of that tag when you build your Dockerfile.
# If reproducibility is important, consider using a specific digest SHA, like
# eclipse-temurin@sha256:99cede493dfd88720b610eb8077c8688d3cca50003d76d1d539b0efc8cca72b4.
#FROM eclipse-temurin:21-jre-jammy AS final

# Update to DHI golden base images for immediate security improvement:
# Note: Replace with actual digest after running: docker inspect demonstrationorg/dhi-temurin:21_whale --format='{{index .RepoDigests 0}}'
#FROM demonstrationorg/dhi-temurin:21_whale AS final
FROM demonstrationorg/dhi-temurin:21_whale@sha256:51ca318ee7dc42fefc6f1f3c82fa2a624ae98bbd44a5ba5923460ad1d0383ff0 AS final
# Our Runtime Image has a  non-privileged user that the app will run under UID=10001.


# Add VEX metadata as labels
LABEL vex.openvex.dev/schema-version="v0.2.0"
LABEL vex.openvex.dev/document="/app/vex.json"
LABEL vex.openvex.dev/embedded="true"
LABEL org.opencontainers.image.description="Spring Boot application with embedded VEX statements"

# Copy the executable from the "package" stage.
COPY --from=extract build/target/extracted/dependencies/ ./
COPY --from=extract build/target/extracted/spring-boot-loader/ ./
COPY --from=extract build/target/extracted/snapshot-dependencies/ ./
COPY --from=extract build/target/extracted/application/ ./

EXPOSE 8080
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:InitialRAMPercentage=50 -XX:MaxRAMPercentage=80 -XX:+UseG1GC -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:InitialRAMPercentage=50", "-XX:MaxRAMPercentage=80", "-XX:+UseG1GC", "-XX:+ExitOnOutOfMemoryError", "-Djava.security.egd=file:/dev/./urandom", "org.springframework.boot.loader.launch.JarLauncher"]