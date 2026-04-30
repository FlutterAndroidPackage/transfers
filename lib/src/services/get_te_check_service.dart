import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/endpoints.dart';

class GetTeCheckService {
  final CoreHttpClient _client;
  GetTeCheckService(this._client);

  /// Ritorna il conteggio di record non ancora elaborati per [idXlogEvadiDocument].
  /// Ritorna 0 quando il documento è stato processato con successo.
  Future<int> getTeCheck({required int idXlogEvadiDocument}) async {
    final uri = _client.buildUri(
      TransfersEndpoints.teCheck,
      queryParameters: {
        'id_xlogEvadiDocument': idXlogEvadiDocument.toString(),
      },
    );
    final url = uri.toString();
    debugPrint('🌐 GET TE CHECK -> $url');

    return apiCall(() async {
      final response = await _client.get(url);

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
    }, context: 'TEcheck');
  }
}
