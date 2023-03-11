class RealtimeDatebaseModel {
  late bool hasCameraRequest;
  late bool isAntiThief;
  late bool isOpen;
  late bool isWarning;
  late String password;

  RealtimeDatebaseModel(
      {required this.hasCameraRequest,
      required this.isAntiThief,
      required this.isOpen,
      required this.isWarning,
      required this.password});

  RealtimeDatebaseModel.fromJson(Map<dynamic, dynamic> json) {
    hasCameraRequest = json['hasCameraRequest'];
    isAntiThief = json['isAntiThief'];
    isOpen = json['isOpen'];
    isWarning = json['isWarning'];
    password = json['password'];
  }
}
