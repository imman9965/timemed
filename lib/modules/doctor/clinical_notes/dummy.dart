class ClinicalNote {
  final String id;
  final DateTime dateTime;

  // Vitals
  final double height; // cm
  final double weight; // kg
  final int pulse; // /min
  final double temperature; // °C

  // Text fields
  final String diseaseComplaints;
  final String allergies;
  final String symptoms;
  final String diagnosis;
  final String causes;
  final String investigation;

  ClinicalNote({
    required this.id,
    required this.dateTime,
    required this.height,
    required this.weight,
    required this.pulse,
    required this.temperature,
    this.diseaseComplaints = '',
    this.allergies = '',
    this.symptoms = '',
    this.diagnosis = '',
    this.causes = '',
    this.investigation = '',
  });

  ClinicalNote copyWith({
    DateTime? dateTime,
    double? height,
    double? weight,
    int? pulse,
    double? temperature,
    String? diseaseComplaints,
    String? allergies,
    String? symptoms,
    String? diagnosis,
    String? causes,
    String? investigation,
  }) {
    return ClinicalNote(
      id: id,
      dateTime: dateTime ?? this.dateTime,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      pulse: pulse ?? this.pulse,
      temperature: temperature ?? this.temperature,
      diseaseComplaints: diseaseComplaints ?? this.diseaseComplaints,
      allergies: allergies ?? this.allergies,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      causes: causes ?? this.causes,
      investigation: investigation ?? this.investigation,
    );
  }
}
