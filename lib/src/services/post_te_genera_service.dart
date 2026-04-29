import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/transfers_endpoints.dart';

class PostTeGeneraService {
  final ApiClient _apiClient = ApiClient();

  /// Inserisce una riga in xLogEvadiDocument per [idDotes] e ritorna
  /// l'id del log appena creato (SCOPE_IDENTITY).
  Future<int> postTeGenera({
    required String cdMg,
    required int idDotes,
  }) async {
    await _apiClient.ensureInitialized();

    final url = "${_apiClient.baseUrl}${TransfersEndpoints.postTEGenera}";
    debugPrint("🌐 POST TE GENERA -> $url (id_dotes=$idDotes)");

    final payload = {
      "parameters": {
        "cd_mg": cdMg.trim(),
        "id_dotes": idDotes,
      }
    };

    try {
      final response = await _apiClient.post(url, body: payload);

      debugPrint("📥 TeGenera response body: ${response.body}");

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      if (data['success'] == false) {
        final msg =
            data['error']?['Message']?.toString() ?? "Errore sconosciuto dal server";
        throw ApiException("Richiesta fallita: $msg");
      }

      final rows = ApiJson.extractRowsOrThrow(data, noDataIsEmptyList: false);
      final row = rows.first as Map<String, dynamic>;
      final idLog = (row['id_xlogEvadiDocument'] as num?)?.toInt();

      if (idLog == null) {
        throw const ApiException("id_xlogEvadiDocument mancante nella risposta");
      }

      debugPrint("✅ TeGenera OK: id_xlogEvadiDocument=$idLog");
      return idLog;
    } on SocketException {
      throw const ApiException(
        "Connessione di rete assente. Controlla la connessione internet.",
      );
    } on HttpException catch (e) {
      throw ApiException("Errore HTTP: ${e.message}");
    } on FormatException catch (e) {
      throw ApiException("Errore di formato: ${e.message}");
    } catch (e) {
      throw ApiException("Errore imprevisto durante teGenera: $e");
    }
  }
}
