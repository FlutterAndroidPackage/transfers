import 'package:flutter/material.dart';

/// Pulsante di accesso rapido ai Trasferimenti, da usare nella home page.
///
/// Esempio d'uso:
/// ```dart
/// TransfersHomeButton(
///   onTap: () => Navigator.pushNamed(context, '/trasferimenti'),
///   color: Theme.of(context).colorScheme.primary,
/// )
/// ```
class TransfersHomeButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const TransfersHomeButton({
    super.key,
    required this.onTap,
    this.label = 'Trasferimenti',
    this.icon = Icons.swap_horiz_rounded,
    required this.color,
    this.subtitle = 'Uscita e rientro materiale',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: color.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
