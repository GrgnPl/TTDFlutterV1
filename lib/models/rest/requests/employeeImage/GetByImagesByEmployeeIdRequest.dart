class GetByImagesByEmployeeIdRequest {
  String? id;

  GetByImagesByEmployeeIdRequest({this.id});

  Map<String, dynamic> toQueryParameters() {
    return {
      if (id != null) 'id': id,
    };
  }
}