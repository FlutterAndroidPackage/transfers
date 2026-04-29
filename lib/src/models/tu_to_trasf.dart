class TuToTrasf {
  final String cd_ar;
  final String descrizione;
  final String cd_mg;
  final String? cd_mgubicazione;
  final String? cd_arlotto;
  final double quantita;
  final String cd_armisura;
  final String? dataArrivo;
  final String id_mgmovints;

  TuToTrasf({
    required this.cd_ar,
    required this.descrizione,
    required this.cd_mg,
    this.cd_mgubicazione,
    this.cd_arlotto,
    required this.quantita,
    required this.cd_armisura,
    this.dataArrivo,
    this.id_mgmovints = "",
  });

  factory TuToTrasf.fromJson(Map<String, dynamic> json) {
    return TuToTrasf(
      cd_ar: json['cd_ar'] ?? '',
      descrizione: json['descrizione'] ?? '',
      cd_mg: json['cd_mg'] ?? '',
      cd_mgubicazione: json['cd_mgubicazione'],
      cd_arlotto: json['cd_arlotto'],
      quantita: (json['quantita'] ?? 0).toDouble(),
      cd_armisura: json['cd_armisura'],
      dataArrivo: json['dataArrivo'] ?? '',
      id_mgmovints: json['id_mgmovints'] ?? '',
    );
  }
}
