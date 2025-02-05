# First stage: Build the Java WAR file
FROM maven:3.8.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Second stage: Run the Java application
FROM openjdk:17
WORKDIR /app
# Copy the generated WAR file from the build stage
COPY --from=build /app/target/*.war app.war
# Run the WAR file
CMD ["java", "-jar", "app.war"]
