/// Package Flutter per la gestione dei trasferimenti magazzino (TU/TE).
///
/// Esporta le pagine, widget, modelli, servizi e costanti necessari
/// per la gestione dei trasferimenti di uscita (TU) e rientro (TE).
library;

// Pages
export 'src/pages/trasferimenti_page.dart';
export 'src/pages/tu_page.dart';
export 'src/pages/te_page.dart';

// Widgets
export 'src/widgets/transfers_home_button.dart';
export 'src/widgets/tu_to_trasf_card.dart';
export 'src/widgets/te_item_card.dart';

// Models
export 'src/models/tu_to_trasf.dart';
export 'src/models/tu_batch_result.dart';
export 'src/models/te_item.dart';

// Services
export 'src/services/get_tu_to_trasf_service.dart';
export 'src/services/post_tu_batch_service.dart';
export 'src/services/get_tu_check_service.dart';
export 'src/services/get_te_service.dart';
export 'src/services/post_te_genera_service.dart';
export 'src/services/get_te_check_service.dart';

// Constants
export 'src/constants/endpoints.dart';
