class BlockGetAllResponse {
  String? id;
  String? branchId;
  String? branchName;

  BlockGetAllResponse({required this.id,required this.branchId ,required this.branchName});

  factory BlockGetAllResponse.fromJson(Map<String, dynamic> json) {
    return BlockGetAllResponse(
      id: json["id"] ?? "",
      branchId: json["branchId"],
      branchName: json["branchName"] ?? "",

    );
  }
}