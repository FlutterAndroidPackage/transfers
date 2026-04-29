class TeItem {
  final int idDotes;
  final String datadoc;
  final String numerodoc;
  final String doc;
  final String cdMgA;
  final String cdMgubicazioneA;

  const TeItem({
    required this.idDotes,
    required this.datadoc,
    required this.numerodoc,
    required this.doc,
    required this.cdMgA,
    required this.cdMgubicazioneA,
  });

  factory TeItem.fromJson(Map<String, dynamic> json) {
    return TeItem(
      idDotes: (json['id_dotes'] as num?)?.toInt() ?? 0,
      datadoc: json['datadoc']?.toString() ?? '',
      numerodoc: json['numerodoc']?.toString() ?? '',
      doc: json['doc']?.toString() ?? '',
      cdMgA: json['cd_mg_A']?.toString() ?? '',
      cdMgubicazioneA: json['cd_mgubicazione_a']?.toString() ?? '',
    );
  }
}
