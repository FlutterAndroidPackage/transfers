import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/transfers_endpoints.dart';
import '../models/tu_to_trasf.dart';

class GetTuToTrasfService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TuToTrasf>> _fetchTuToTrasf(Uri uri) async {
    await _apiClient.ensureInitialized();
    final url = uri.toString();

    debugPrint("🌐 GET TUTOTRASF -> $url");

    try {
      final response = await _apiClient.get(url);

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      // NO_DATA => lista vuota
      final rows = ApiJson.extractRowsOrThrow(data, noDataIsEmptyList: true);

      final list = rows
          .map((r) => TuToTrasf.fromJson(r as Map<String, dynamic>))
          .toList();

      debugPrint("✅ TuToTrasf trovati: ${list.length}");
      return list;
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
        "Errore imprevisto durante il recupero delle TuToTrasf: $e",
      );
    }
  }

  /// Recupera i movimenti da trasferire per il magazzino [codiceMagazzino].
  Future<List<TuToTrasf>> getTuToTrasfByMg(String codiceMagazzino) async {
    await _apiClient.ensureInitialized();

    final uri = _apiClient.buildUri(
      TransfersEndpoints.getTUtoTrasfByCd_Mg,
      queryParameters: {
        "cd_mg": codiceMagazzino.trim(),
      },
    );

    return _fetchTuToTrasf(uri);
  }
}
