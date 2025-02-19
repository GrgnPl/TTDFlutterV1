import 'dart:ffi';

class RoomDutyCount {
  String? idCount;
  int? completedCount;
  int? uncompletedCount;
  int? appointedCount;

  RoomDutyCount({
    this.idCount,  // Artık opsiyonel
    required this.completedCount,
    required this.uncompletedCount,
    this.appointedCount
  });

  factory RoomDutyCount.fromJson(Map<String, dynamic> json) {
    return RoomDutyCount(
      idCount: json["idCount"] ?? "",  // Eğer JSON'da yoksa boş string atıyor
      completedCount: json["completedCount"] as int?,
      uncompletedCount: json["uncompletedCount"] as int?,
      appointedCount: json["appointedCount"] as int?,

    );
  }
}