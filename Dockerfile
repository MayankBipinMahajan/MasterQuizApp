# ----------------------------------
# Stage 1: Build the Spring Boot app
# ----------------------------------
FROM eclipse-temurin:21-jdk AS build

# Set working directory inside container
WORKDIR /app

# Copy Maven wrapper & pom.xml first for dependency caching
COPY pom.xml .
COPY mvnw .
COPY .mvn .mvn

# Download Maven dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Package the application without running tests
RUN ./mvnw clean package -DskipTests

# ----------------------------------
# Stage 2: Create a smaller runtime image
# ----------------------------------
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy only the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the default Spring Boot port (can be overridden by env var)
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
