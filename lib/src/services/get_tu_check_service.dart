import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/transfers_endpoints.dart';

class GetTuCheckService {
  final ApiClient _apiClient = ApiClient();

  /// Ritorna il numero di record non ancora processati per [xTuTesta].
  /// Ritorna 0 quando tutti i record sono stati elaborati.
  Future<int> getTuCheck({required String xTuTesta}) async {
    await _apiClient.ensureInitialized();

    final uri = _apiClient.buildUri(
      TransfersEndpoints.tuCheck,
      queryParameters: {'xTuTesta': xTuTesta.trim()},
    );
    final url = uri.toString();
    debugPrint('🌐 GET TU CHECK -> $url');

    return apiCall(() async {
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
      return (row['nResidui'] as num?)?.toInt() ?? 0;
    }, context: 'TuCheck');
  }
}
