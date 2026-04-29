import 'package:flutter/material.dart';
import 'package:my_core_package/my_core_package.dart';

import 'tu_page.dart';
import 'te_page.dart';

class TrasferimentiPage extends StatelessWidget {
  const TrasferimentiPage({super.key});

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
                    builder: (_) => const TUPage(destinazione: "Maiocca"),
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
                    builder: (_) => const TUPage(destinazione: "Terranova"),
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
                    builder: (_) => const TEPage(destinazione: "Maiocca"),
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
                    builder: (_) => const TEPage(destinazione: "Terranova"),
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
