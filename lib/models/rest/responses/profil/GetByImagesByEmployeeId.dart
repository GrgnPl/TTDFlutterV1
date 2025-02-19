class GetByImagesByEmployeeId  {
  String? id;
  String? employeeId;
  String? imagePath;


  GetByImagesByEmployeeId({
    required this.id,
    required this.employeeId ,
    required this.imagePath});

  factory GetByImagesByEmployeeId.fromJson(Map<String, dynamic> json) {
    return GetByImagesByEmployeeId(
      id: json["id"] ?? "",
      employeeId: json["employeeId"],
      imagePath: json["imagePath"] ?? "",
    );
  }
}