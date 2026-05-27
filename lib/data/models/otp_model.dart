class OtpReg {
  String? challengeId;
  String? otp;

  OtpReg({this.challengeId, this.otp});

  OtpReg.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['otp'] = this.otp;
    return data;
  }
}
