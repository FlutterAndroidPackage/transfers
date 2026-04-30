import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/endpoints.dart';
import '../models/tu_to_trasf.dart';
import '../models/tu_batch_result.dart';

class PostTuBatchService {
  final CoreHttpClient _client;
  PostTuBatchService(this._client);

  Future<TuBatchResult> postTuBatch({
    required List<TuToTrasf> righe,
  }) async {
    final url = _client.buildUri(TransfersEndpoints.postTuBatch).toString();
    debugPrint('🌐 POST TU BATCH -> $url');

    final payload = _buildPayload(righe);

    return apiCall(() async {
      debugPrint('Payload: $payload');

      final response = await _client.post(url, body: payload);
      debugPrint('📥 TuBatch response body: ${response.body}');

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      if (data['success'] == false) {
        final msg = data['error']?['Message']?.toString() ??
            'Errore sconosciuto dal server';
        throw ApiException('Richiesta fallita: $msg');
      }

      final result = TuBatchResult.fromJson(data);

      if (result.success == true) {
        debugPrint('✅ ${result.message}');
      } else {
        debugPrint('❌ Trasferimento KO: ${result.message}');
        throw ApiException(result.message);
      }

      return result;
    }, context: 'il trasferimento TU');
  }

  Map<String, dynamic> _buildPayload(List<TuToTrasf> righe) {
    final rowsPayload = <Map<String, dynamic>>[];

    for (final r in righe) {
      final raw = r.id_mgmovints.trim();
      if (raw.isEmpty) continue;

      for (final id in raw.split(',')) {
        final parsed = int.tryParse(id.trim());
        if (parsed != null) rowsPayload.add({'Id_MgMovInt': parsed});
      }
    }

    return {
      'parameters': {'Righe': rowsPayload}
    };
  }
}
