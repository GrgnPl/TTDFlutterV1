class MaterialManagement {
  final String id;
  final String materialName;
  final List<String> materialUsage;
  final List<String> securityAlert;

  MaterialManagement({
    required this.id,
    required this.materialName,
    required this.materialUsage,
    required this.securityAlert,
  });

  factory MaterialManagement.fromJson(Map<String, dynamic> json) {
    return MaterialManagement(
      id: json['id'],
      materialName: json['materialName'],
      materialUsage: List<String>.from(json['materialUsage']),
      securityAlert: List<String>.from(json['securityAlert']),
    );
  }
}