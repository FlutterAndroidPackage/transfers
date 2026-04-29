/// Costanti endpoint API per i trasferimenti (TU/TE).
class TransfersEndpoints {
  // TU — Trasferimenti Uscita
  static const getTUtoTrasfByCd_Mg =
      "/api/v1/ADB_AUDIOOHM/tu/getTUtoTrasfByCd_Mg";
  static const postTuBatch = "/api/v1/ADB_AUDIOOHM/tu/tuBatch";
  static const tuCheck = "/api/v1/ADB_AUDIOOHM/tu/tuCheck";

  // TE — Trasferimenti Entrata (rientro)
  static const getTE = "/api/v1/ADB_AUDIOOHM/te/getTE";
  static const postTEGenera = "/api/v1/ADB_AUDIOOHM/te/teGenera";
  static const teCheck = "/api/v1/ADB_AUDIOOHM/te/TEcheck";
}
