import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/transfers_endpoints.dart';
import '../models/tu_to_trasf.dart';
import '../models/tu_batch_result.dart';

class PostTuBatchService {
  final ApiClient _apiClient = ApiClient();

  Future<TuBatchResult> postTuBatch({
    required List<TuToTrasf> righe,
  }) async {
    await _apiClient.ensureInitialized();

    final url = "${_apiClient.baseUrl}${TransfersEndpoints.postTuBatch}";
    debugPrint("🌐 POST TU BATCH -> $url");

    final payload = _buildPayload(righe);

    try {
      debugPrint("Payload: $payload");

      final response = await _apiClient.post(url, body: payload);

      debugPrint("📥 TuBatch response body: ${response.body}");

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

      final result = TuBatchResult.fromJson(data);

      if (result.success == true) {
        debugPrint("✅ ${result.message}");
      } else {
        debugPrint("❌ Trasferimento KO: ${result.message}");
        throw ApiException(result.message);
      }

      return result;
    } on SocketException {
      throw const ApiException(
        "Connessione di rete assente. Controlla la connessione internet.",
      );
    } on HttpException catch (e) {
      throw ApiException("Errore HTTP: ${e.message}");
    } on FormatException catch (e) {
      throw ApiException("Errore di formato: ${e.message}");
    } catch (e) {
      throw ApiException(
        "Errore imprevisto durante il trasferimento TU: $e",
      );
    }
  }

  Map<String, dynamic> _buildPayload(List<TuToTrasf> righe) {
    final rowsPayload = <Map<String, dynamic>>[];

    for (final r in righe) {
      final raw = (r.id_mgmovints).trim();
      if (raw.isEmpty) continue;

      final ids = raw.split(',');

      for (final id in ids) {
        final parsed = int.tryParse(id.trim());
        if (parsed != null) {
          rowsPayload.add({
            "Id_MgMovInt": parsed,
          });
        }
      }
    }

    return {
      "parameters": {
        "Righe": rowsPayload,
      }
    };
  }
}
