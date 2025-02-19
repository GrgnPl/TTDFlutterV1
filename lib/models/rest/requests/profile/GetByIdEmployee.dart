import '../RequestBase.dart';

class GetByIdEmployee {
  String? id;

  GetByIdEmployee({this.id});

  Map<String, dynamic> toQueryParameters() {
    return {
      if (id != null) 'id': id,
    };
  }
}