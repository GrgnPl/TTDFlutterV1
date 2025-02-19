import 'dart:ffi';

class TechninalErrorCount {
  String? idCount;
  int? completedCount;
  int? uncompletedCount;

  TechninalErrorCount({
    this.idCount,  // Artık opsiyonel
    required this.completedCount,
    required this.uncompletedCount,
  });

  factory TechninalErrorCount.fromJson(Map<String, dynamic> json) {
    return TechninalErrorCount(
      idCount: json["idCount"] ?? "",  // Eğer JSON'da yoksa boş string atıyor
      completedCount: json["completedCount"] as int?,
      uncompletedCount: json["uncompletedCount"] as int?,
    );
  }
}