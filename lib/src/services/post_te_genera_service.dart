import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/endpoints.dart';

class PostTeGeneraService {
  final CoreHttpClient _client;
  PostTeGeneraService(this._client);

  /// Inserisce una riga in xLogEvadiDocument per [idDotes] e ritorna
  /// l'id del log appena creato (SCOPE_IDENTITY).
  Future<int> postTeGenera({
    required String cdMg,
    required int idDotes,
  }) async {
    final url = _client.buildUri(TransfersEndpoints.postTEGenera).toString();
    debugPrint('🌐 POST TE GENERA -> $url (id_dotes=$idDotes)');

    final payload = {
      'parameters': {
        'cd_mg': cdMg.trim(),
        'id_dotes': idDotes,
      }
    };

    return apiCall(() async {
      final response = await _client.post(url, body: payload);
      debugPrint('📥 TeGenera response body: ${response.body}');

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      final rows = ApiJson.extractRowsOrThrow(data, noDataIsEmptyList: false);
      final row = rows.first as Map<String, dynamic>;
      final idLog = (row['id_xlogEvadiDocument'] as num?)?.toInt();

      if (idLog == null) {
        throw const ApiException(
            'id_xlogEvadiDocument mancante nella risposta');
      }

      debugPrint('✅ TeGenera OK: id_xlogEvadiDocument=$idLog');
      return idLog;
    }, context: 'teGenera');
  }
}
