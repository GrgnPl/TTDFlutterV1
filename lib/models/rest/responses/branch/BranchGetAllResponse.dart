class BranchGetAllResponse {
  String? id;
  String? branchName;

  BranchGetAllResponse({required this.id, required this.branchName});

  factory BranchGetAllResponse.fromJson(Map<String, dynamic> json) {
    return BranchGetAllResponse(
      id: json["id"] ?? "",
      branchName: json["branchName"] ?? "",

    );
  }
}