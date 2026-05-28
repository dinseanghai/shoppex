class ResetPasswordReg {
  String? challengeId;
  String? password;
  String? passwordConfirmation;

  ResetPasswordReg(
      {this.challengeId, this.password, this.passwordConfirmation});

  ResetPasswordReg.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}
