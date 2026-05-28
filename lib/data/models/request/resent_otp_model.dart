class ResendOtpReg {
  String? challengeId;

  ResendOtpReg({this.challengeId});

  ResendOtpReg.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    return data;
  }
}
