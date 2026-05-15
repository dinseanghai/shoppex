class RegisterReq {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirmation;

  RegisterReq(
      {this.name,
        this.email,
        this.phone,
        this.password,
        this.passwordConfirmation});

  RegisterReq.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    return data;
  }
}
