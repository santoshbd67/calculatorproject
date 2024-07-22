# Stage 1: Build the application
FROM maven:3.8.4-openjdk-11 AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .

# Download the project dependencies
RUN mvn dependency:go-offline

# Copy the rest of the project files
COPY src /app/src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image with Tomcat
FROM tomcat:9.0-jre11-slim

# Set the working directory to Tomcat's webapps directory
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file from the builder stage
COPY --from=builder /app/target/calculator.war /usr/local/tomcat/webapps/

# Expose the port on which Tomcat will run
EXPOSE 8080

# Tomcat is already configured to run as the entry point

