class OtpModel {
  final String otp;

  OtpModel(this.otp);

  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(json['otp']);
  }
}