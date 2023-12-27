class OtpModel {
  final String numTel;
  final String otp;

  OtpModel(this.numTel ,this.otp);


  factory OtpModel.fromJson(Map<String, dynamic> json) {
    return OtpModel(
        json['numTel'],
        json['otp']);
  }
}