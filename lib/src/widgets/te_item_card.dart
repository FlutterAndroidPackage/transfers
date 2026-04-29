import 'package:flutter/material.dart';

import '../models/te_item.dart';

class TeItemCard extends StatelessWidget {
  const TeItemCard({super.key, required this.item});

  final TeItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final valueStyle = theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: scheme.primary,
        ) ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: scheme.primary,
        );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Documento
          Text(item.doc.isNotEmpty ? item.doc : "-", style: valueStyle),

          const SizedBox(height: 10),

          // Destinazione e ubicazione
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  label: "Destinazione",
                  value: item.cdMgA.isNotEmpty ? item.cdMgA : "-",
                  style: valueStyle,
                ),
              ),
              const SizedBox(width: 12),
              _InfoRow(
                label: "Ubicazione",
                value: item.cdMgubicazioneA.isNotEmpty
                    ? item.cdMgubicazioneA
                    : "-",
                style: valueStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle style;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$label: ",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(value, style: style),
      ],
    );
  }
}
