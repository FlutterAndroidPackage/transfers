import 'package:flutter/foundation.dart';
import 'package:my_core_package/my_core_package.dart';

import '../constants/endpoints.dart';
import '../models/tu_to_trasf.dart';

class GetTuToTrasfService {
  final CoreHttpClient _client;
  GetTuToTrasfService(this._client);

  Future<List<TuToTrasf>> _fetchTuToTrasf(Uri uri) {
    final url = uri.toString();
    debugPrint('🌐 GET TUTOTRASF -> $url');

    return apiCall(() async {
      final response = await _client.get(url);

      final data = ApiJson.decodeMapResponse(
        url: url,
        statusCode: response.statusCode,
        body: response.body,
        reasonPhrase: response.reasonPhrase,
      );

      final rows = ApiJson.extractRowsOrThrow(data, noDataIsEmptyList: true);
      final list = rows
          .map((r) => TuToTrasf.fromJson(r as Map<String, dynamic>))
          .toList();

      debugPrint('✅ TuToTrasf trovati: ${list.length}');
      return list;
    }, context: 'il recupero TuToTrasf');
  }

  /// Recupera i movimenti da trasferire per il magazzino [codiceMagazzino].
  Future<List<TuToTrasf>> getTuToTrasfByMg(String codiceMagazzino) async {
    final uri = _client.buildUri(
      TransfersEndpoints.getTUtoTrasfByCd_Mg,
      queryParameters: {'cd_mg': codiceMagazzino.trim()},
    );

    return _fetchTuToTrasf(uri);
  }
}
