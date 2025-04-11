class Customer {
  final String email;
  final String password;

  Customer({required this.email, required this.password});

  Map<String, String> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}