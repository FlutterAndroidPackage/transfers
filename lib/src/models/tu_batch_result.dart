class TuBatchResult {
  final bool success;
  final String message;
  final int count;
  final String? xTUTesta;

  TuBatchResult({
    required this.success,
    required this.message,
    required this.count,
    this.xTUTesta,
  });

  factory TuBatchResult.fromJson(Map<String, dynamic> json) {
    final rows = json['rows'];
    String? xTUTesta;

    // Se una riga contiene success:false → errore reale
    if (rows is List) {
      for (final row in rows) {
        if (row is Map<String, dynamic>) {
          if (row['success'] == false) {
            return TuBatchResult(
              success: false,
              message:
                  row['error_message']?.toString() ?? "Errore sconosciuto",
              count: json['count'] is num
                  ? (json['count'] as num).toInt()
                  : 0,
              xTUTesta: null,
            );
          }
          // Cattura xTUTesta dalla prima riga valida
          xTUTesta ??= row['xTUTesta']?.toString();
        }
      }
    }

    // Caso OK
    return TuBatchResult(
      success: true,
      message:
          json['error']?['Message']?.toString() ?? "Operazione completata",
      count: json['count'] is num
          ? (json['count'] as num).toInt()
          : 0,
      xTUTesta: xTUTesta,
    );
  }
}
