class AddMedicineRequest {
  final String dosage;
  final String frequency;
  final String name;
  final int patientId;
  final String startDate;
  final String endDate;
  final String notes;

  AddMedicineRequest({
    required this.dosage,
    required this.frequency,
    required this.name,
    required this.patientId,
    required this.startDate,
    required this.endDate,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        "dosage": dosage,
        "frequency": frequency,
        "name": name,
        "patientId": patientId,
        "startDate": startDate,
        "endDate": endDate,
        "notes": notes,
      };

  factory AddMedicineRequest.fromMap(Map<String, dynamic> map) {
    return AddMedicineRequest(
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      name: map['name'] ?? '',
      patientId: map['patientId'] ?? 0,
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}
