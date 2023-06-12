# Start from a Flutter stable image
FROM cirrusci/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Copy the entire project to the container
COPY . .

# Build the Flutter app
RUN flutter build apk --release

# Set the Dart entry point
ENTRYPOINT ["flutter", "run", "--release", "--dart-entrypoint-args", "main.dart"]

#
## Use the base Flutter image
#FROM cirrusci/flutter:stable
#
## Set the working directory
#WORKDIR /authentication-service
#
## Copy the rest of the microservice files to the Docker image
#COPY . .
#
## Install dependencies using flutter pub
#RUN flutter pub get
#
## Expose the necessary ports
#EXPOSE 8080
#
## Specify the entry point command to start the authentication microservice
#CMD ["dart", "src/main.dart"]
