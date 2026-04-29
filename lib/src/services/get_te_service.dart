import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/transfers_endpoints.dart';
import '../models/te_item.dart';

class GetTeService {
  final ApiClient _apiClient = ApiClient();

  Future<List<TeItem>> getTE(String cdMg) async {
    await _apiClient.ensureInitialized();

    final uri = _apiClient.buildUri(
      TransfersEndpoints.getTE,
      queryParameters: {"cd_mg": cdMg.trim()},
    );

    final url = uri.toString();
    debugPrint("🌐 GET TE -> $url");

    try {
      final response = await _apiClient.get(url);

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      final rows = ApiJson.extractRowsOrThrow(data, noDataIsEmptyList: true);

      final list = rows
          .map((r) => TeItem.fromJson(r as Map<String, dynamic>))
          .toList();

      debugPrint("✅ TE trovati: ${list.length}");
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
      throw ApiException("Errore imprevisto durante il recupero TE: $e");
    }
  }
}
