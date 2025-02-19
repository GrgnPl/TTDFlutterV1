class BranchByIdResponse {
  String? id;
  String? branchName;
  String? companyId;

  BranchByIdResponse({required this.id, required this.branchName, required this.companyId});

  factory BranchByIdResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      return BranchByIdResponse(
        id: json['data']['id'],
        branchName: json['data']['branchName'],
        companyId: json['data']['companyId'],
      );
    } else {
      throw Exception("Invalid JSON structure: 'data' field is missing or null.");
    }
  }
}