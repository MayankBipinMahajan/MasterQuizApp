# ----------------------------------
# Stage 1: Build the Spring Boot app
# ----------------------------------
FROM eclipse-temurin:21-jdk AS build

WORKDIR /app

# Copy Maven files first for caching
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Make mvnw executable
RUN chmod +x mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Package the application without tests
RUN ./mvnw clean package -DskipTests

# ----------------------------------
# Stage 2: Runtime image
# ----------------------------------
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy built jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Environment variable for Render's PORT
ENV SERVER_PORT=${PORT}

# Run Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
