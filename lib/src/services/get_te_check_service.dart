import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/transfers_endpoints.dart';

class GetTeCheckService {
  final ApiClient _apiClient = ApiClient();

  /// Ritorna il conteggio di record non ancora elaborati per [idXlogEvadiDocument].
  /// Ritorna 0 quando il documento è stato processato con successo.
  Future<int> getTeCheck({required int idXlogEvadiDocument}) async {
    await _apiClient.ensureInitialized();

    final uri = _apiClient.buildUri(
      TransfersEndpoints.teCheck,
      queryParameters: {
        "id_xlogEvadiDocument": idXlogEvadiDocument.toString(),
      },
    );

    final url = uri.toString();
    debugPrint("🌐 GET TE CHECK -> $url");

    try {
      final response = await _apiClient.get(url);

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      final rows = ApiJson.extractRowsOrThrow(data, noDataIsEmptyList: true);
      if (rows.isEmpty) return 0;

      final row = rows.first as Map<String, dynamic>;
      return (row['generat'] as num?)?.toInt() ?? 0;
    } on SocketException {
      throw const ApiException(
        "Connessione di rete assente. Controlla la connessione internet.",
      );
    } on HttpException catch (e) {
      throw ApiException("Errore HTTP: ${e.message}");
    } on FormatException catch (e) {
      throw ApiException("Errore di formato: ${e.message}");
    } catch (e) {
      throw ApiException("Errore imprevisto durante TEcheck: $e");
    }
  }
}
