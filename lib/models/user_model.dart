class UserModel {
  String name;
  String dob;
  String height;
  int periodLength;
  int cycleLength;
  String lastPeriodEnd;
  // ISO strings for the most recent cycle range (start/end)
  String? periodStart;
  String? periodEnd;

  UserModel({
    required this.name,
    required this.dob,
    required this.height,
    required this.periodLength,
    required this.cycleLength,
    required this.lastPeriodEnd,
    this.periodStart,
    this.periodEnd,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "dob": dob,
      "height": height,
      "periodLength": periodLength,
      "cycleLength": cycleLength,
      "lastPeriodEnd": lastPeriodEnd,
      if (periodStart != null) "periodStart": periodStart,
      if (periodEnd != null) "periodEnd": periodEnd,
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
      periodStart: map['periodStart'],
      periodEnd: map['periodEnd'],
    );
  }
}