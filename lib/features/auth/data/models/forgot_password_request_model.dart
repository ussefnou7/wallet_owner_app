class ForgotPasswordRequestModel {
  const ForgotPasswordRequestModel({required this.username});

  final String username;

  Map<String, dynamic> toJson() {
    return {'username': username};
  }
}
