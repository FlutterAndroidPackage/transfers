import 'package:flutter/material.dart';
import 'package:my_core_package/my_core_package.dart';

import 'tu_page.dart';
import 'te_page.dart';

/// Pagina hub per la gestione dei trasferimenti magazzino (TU/TE).
///
/// ### Parametri obbligatori
/// - [getAccessToken]: ritorna il token JWT corrente
/// - [getBaseUrl]: ritorna il base URL del server
///
/// ### Parametri opzionali
/// - [onUnauthorized]: callback su 401 non recuperabile
/// - [tryRefreshToken]: tenta il refresh del token su 401; se ritorna true
///   la richiesta viene ripetuta automaticamente una sola volta
class TrasferimentiPage extends StatelessWidget {
  final Future<String> Function() getAccessToken;
  final String Function() getBaseUrl;
  final void Function()? onUnauthorized;
  final Future<bool> Function()? tryRefreshToken;

  const TrasferimentiPage({
    super.key,
    required this.getAccessToken,
    required this.getBaseUrl,
    this.onUnauthorized,
    this.tryRefreshToken,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final labelStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: scheme.onSurfaceVariant,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Trasferimenti"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Uscita materiale",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),

              HomeActionCard(
                icon: Text("M", style: labelStyle),
                title: "Uscita da Maiocca",
                subtitle: "Genera bolla uscita Maiocca",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TUPage(
                      destinazione: "Maiocca",
                      getAccessToken: getAccessToken,
                      getBaseUrl: getBaseUrl,
                      onUnauthorized: onUnauthorized,
                      tryRefreshToken: tryRefreshToken,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              HomeActionCard(
                icon: Text("T", style: labelStyle),
                title: "Uscita da Terranova",
                subtitle: "Genera bolla uscita Terranova",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TUPage(
                      destinazione: "Terranova",
                      getAccessToken: getAccessToken,
                      getBaseUrl: getBaseUrl,
                      onUnauthorized: onUnauthorized,
                      tryRefreshToken: tryRefreshToken,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Rientro materiale",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),

              HomeActionCard(
                icon: Text("M", style: labelStyle),
                title: "Rientro a Maiocca",
                subtitle: "Conferma rientro da Maiocca",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TEPage(
                      destinazione: "Maiocca",
                      getAccessToken: getAccessToken,
                      getBaseUrl: getBaseUrl,
                      onUnauthorized: onUnauthorized,
                      tryRefreshToken: tryRefreshToken,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              HomeActionCard(
                icon: Text("T", style: labelStyle),
                title: "Rientro a Terranova",
                subtitle: "Conferma rientro da Terranova",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TEPage(
                      destinazione: "Terranova",
                      getAccessToken: getAccessToken,
                      getBaseUrl: getBaseUrl,
                      onUnauthorized: onUnauthorized,
                      tryRefreshToken: tryRefreshToken,
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
