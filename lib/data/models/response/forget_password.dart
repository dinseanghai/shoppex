class ForgetPasswordResponse {
  final String? message;
  final String? challengeId;
  final String? expiresAt;

  ForgetPasswordResponse({this.message, this.challengeId, this.expiresAt});

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      message: json['message'],
      // Maps exactly to the "challenge_id" key in your Laravel json snippet
      challengeId: json['challenge_id'],
      expiresAt: json['expires_at'],
    );
  }
}