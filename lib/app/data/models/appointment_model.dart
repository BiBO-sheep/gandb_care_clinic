class AppointmentModel {
  final int id;
  final String queueNumber;
  final String tanggal;
  final String jam;
  final String status;
  final Poli poli;
  final Dokter? dokter;

  AppointmentModel({
    required this.id,
    required this.queueNumber,
    required this.tanggal,
    required this.jam,
    required this.status,
    required this.poli,
    this.dokter,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      queueNumber: json['queue_number'],
      tanggal: json['tanggal'],
      jam: json['jam'],
      status: json['status'],
      poli: Poli.fromJson(json['poli']),
      dokter: json['dokter'] != null ? Dokter.fromJson(json['dokter']) : null,
    );
  }
}

class Poli {
  final int id;
  final String name;
  final String ruangan;

  Poli({required this.id, required this.name, required this.ruangan});

  factory Poli.fromJson(Map<String, dynamic> json) {
    return Poli(
      id: json['id'],
      name: json['name'],
      ruangan: json['ruangan'] ?? '',
    );
  }
}

class Dokter {
  final int id;
  final String name;

  Dokter({required this.id, required this.name});

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      id: json['id'],
      name: json['name'],
    );
  }
}
