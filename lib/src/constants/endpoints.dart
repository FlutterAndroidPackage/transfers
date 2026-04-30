/// Costanti endpoint API per i trasferimenti (TU/TE).
class TransfersEndpoints {
  // TU — Trasferimenti Uscita
  static const getTUtoTrasfByCd_Mg =
      '/api/v1/pack_transfers/getTUtoTrasfByCd_Mg';
  static const postTuBatch = '/api/v1/pack_transfers/tuBatch';
  static const tuCheck = '/api/v1/pack_transfers/tuCheck';

  // TE — Trasferimenti Entrata (rientro)
  static const getTE = '/api/v1/pack_transfers/getTE';
  static const postTEGenera = '/api/v1/pack_transfers/teGenera';
  static const teCheck = '/api/v1/pack_transfers/TEcheck';
}
