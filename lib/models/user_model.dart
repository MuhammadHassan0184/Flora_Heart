class UserModel {
  String name;
  String dob;
  String height;
  int periodLength;
  int cycleLength;
  String lastPeriodEnd;

  UserModel({
    required this.name,
    required this.dob,
    required this.height,
    required this.periodLength,
    required this.cycleLength,
    required this.lastPeriodEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "dob": dob,
      "height": height,
      "periodLength": periodLength,
      "cycleLength": cycleLength,
      "lastPeriodEnd": lastPeriodEnd,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      dob: map['dob'] ?? "",
      height: map['height'] ?? "",
      periodLength: map['periodLength'] ?? 0,
      cycleLength: map['cycleLength'] ?? 0,
      lastPeriodEnd: map['lastPeriodEnd'] ?? "",
    );
  }
}