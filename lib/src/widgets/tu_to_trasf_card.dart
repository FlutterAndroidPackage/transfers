import 'package:flutter/material.dart';
import 'package:my_core_package/my_core_package.dart';

import '../models/tu_to_trasf.dart';

class TuToTrasfCard extends StatelessWidget {
  const TuToTrasfCard({super.key, required this.tuToTrasf});

  final TuToTrasf tuToTrasf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final codice = tuToTrasf.cd_ar;
    final descrizione = tuToTrasf.descrizione;
    final magazzino = tuToTrasf.cd_mg;
    final ubicazione = tuToTrasf.cd_mgubicazione ?? "-";
    final lotto = tuToTrasf.cd_arlotto ?? "-";
    final dataArrivo = DataHelper.format(tuToTrasf.dataArrivo);
    final quantita = tuToTrasf.quantita;
    final misura = tuToTrasf.cd_armisura;

    final quantitaStr =
        (quantita % 1 == 0) ? quantita.toInt().toString() : quantita.toString();

    // Colore Q.TÀ
    Color qtyColor;
    if (quantita < 0) {
      qtyColor = Colors.red;
    } else if (quantita == 0) {
      qtyColor = Colors.amber.shade800;
    } else {
      qtyColor = theme.colorScheme.primary;
    }

    final valueStyle = theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ) ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: theme.colorScheme.primary,
        );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Codice articolo
          Text(codice, style: valueStyle),

          const SizedBox(height: 4),

          // Descrizione
          Text(
            descrizione,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Info + quantità
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      label: "Magazzino",
                      value: magazzino,
                      style: valueStyle,
                    ),
                    _InfoRow(
                      label: "Ubicazione",
                      value: ubicazione,
                      style: valueStyle,
                    ),
                    _InfoRow(label: "Lotto", value: lotto, style: valueStyle),
                    _InfoRow(
                      label: "Arrivo",
                      value: dataArrivo,
                      style: valueStyle,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Q.TÀ
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: qtyColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      quantitaStr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: qtyColor,
                      ),
                    ),
                    if (misura.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        misura,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: qtyColor,
                        ),
                      ),
                    ],
                  ],
                ),
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

  bool get isCritical {
    final v = value.toUpperCase();
    return v.startsWith("NC");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: style.copyWith(
              color: isCritical ? Colors.red.shade700 : style.color,
              fontWeight: isCritical ? FontWeight.bold : style.fontWeight,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
