# Freelancing Service Platform

A mobile application designed to connect local service providers with customers seeking household services like plumbing, electrical work, cleaning, and more. This platform offers a seamless experience for both service providers and customers through features like real-time availability, booking options, chatting, bidding system, and secure payments.

## Features

- **Service Provider Profiles**: Showcases expertise, ratings, and portfolio of past work to help customers make informed decisions.
- **Service Categories**: Wide range of household services like plumbing, electrical, gardening, cleaning, etc.
- **Search and Filters**: Users can search for services and filter by location, service type, price range, and availability.
- **Bidding System**: Customers can post tasks, and service providers can bid, allowing for competitive pricing and flexibility.
- **Real-time Communication**: Chat or video call between service providers and customers to discuss service requirements.
- **Booking and Scheduling**: Customers can book appointments based on service provider availability.
- **Payment Integration**: Secure payment gateway for transactions, with support for invoices and payment tracking.
- **Review System**: Customers and service providers can leave feedback and ratings to ensure transparency and trust.
- **Geolocation Services**: Helps customers find nearby service providers.
- **Notifications**: Alerts for service updates, bookings, and bidding activity.

## Tech Stack

### Frontend:
- **Flutter (Dart)**: For building cross-platform mobile applications (Android & iOS).
- **Firebase**: For push notifications and chat feature integration.

### Backend:
- **Spring Boot (Java)**: Handles user authentication, profile management, booking logic, and communication with the database.
- **MySQL/PostgreSQL**: Relational database to store user data, service listings, and transaction history.
- **REST APIs**: Ensures scalability and reliable communication between the client and server.

### Deployment:
- **Cloud Infrastructure**: AWS/Google Cloud/Azure for backend services, ensuring scalability and fault tolerance.
- **CI/CD**: GitLab CI/CD for automated testing and deployment.

## Getting Started

### Prerequisites
- Install [Flutter](https://flutter.dev/docs/get-started/install) for mobile app development.
- Install [Java JDK](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) for the backend.
- Install [MySQL/PostgreSQL](https://www.mysql.com/downloads/), depending on your preferred database.
- Ensure your mobile device/emulator is set up for development.

### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/Deepak9011/workup
    ```
   
2. **Frontend**:
    - Navigate to the `client` folder:
      ```bash
      cd client
      ```
    - Install dependencies:
      ```bash
      flutter pub get
      ```
    - Run the app:
      ```bash
      flutter run
      ```

3. **Backend**:
    - Navigate to the `server` folder:
      ```bash
      cd server
      ```
    - Install dependencies and start the Spring Boot application:
      ```bash
      ./mvnw spring-boot:run
      ```

### API Documentation
- API endpoints are documented using Swagger and can be accessed at `/swagger-ui.html` after running the server.

## Contributing

We welcome contributions! If you're interested in improving this project, please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature-name`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.




# workup

Work Up - A freelance app for household jobs

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
