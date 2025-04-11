//service_provider_model.dart

class ServiceProvider {
  final String email;
  final String password;

  ServiceProvider({required this.email, required this.password});

  Map<String, String> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}