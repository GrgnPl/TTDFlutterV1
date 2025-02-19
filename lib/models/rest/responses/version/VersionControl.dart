class VersionControl  {
  String? id;
  String? versionName;


  VersionControl({
    required this.id,
    required this.versionName});

  factory VersionControl.fromJson(Map<String, dynamic> json) {
    return VersionControl(
      id: json["id"] ?? "",
      versionName: json["versionName"],
    );
  }
}