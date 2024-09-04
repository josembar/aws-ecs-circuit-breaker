# Using official image of latest version of gradle with jdk 21
FROM gradle:8.10.0-jdk21-alpine as build

# # Copy all files from the current directory to the working directory and setting gradle user as owner
COPY --chown=gradle:gradle . /home/gradle/javaapp

# Set the working directory in the container
WORKDIR /home/gradle/javaapp

# Build app
RUN gradle build --no-daemon 

# Using official image of amazon corretto jdk 21
FROM amazoncorretto:21.0.4-alpine3.18

# Set port as argument
ARG PORT=3000

# Expose the port the app runs on
EXPOSE $PORT

# Create directory to copy jar file
RUN mkdir /app

# Copy jar file from gradle image
COPY --from=build /home/gradle/javaapp/build/libs/*.jar /app/spring-boot-application.jar

# Entrypoint for the application
ENTRYPOINT ["java", "-jar","/app/spring-boot-application.jar"]