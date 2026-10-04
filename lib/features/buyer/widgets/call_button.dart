import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Gros bouton « Appeler » : affiche le numéro, puis ouvre l'app téléphone.
class CallButton extends StatelessWidget {
  const CallButton({super.key, required this.phone});

  final String phone;

  Future<void> _call(BuildContext context) async {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: cleaned);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Contacter le producteur'),
        content: SelectableText(
          phone,
          style: Theme.of(ctx)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(ctx).pop(true),
            icon: const Icon(Icons.call),
            label: const Text('Appeler'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Impossible d'appeler le $phone")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabled = phone.trim().isEmpty;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: disabled ? null : () => _call(context),
        icon: const Icon(Icons.call, size: 28),
        label: Text(
          disabled ? 'Numéro indisponible' : 'Appeler',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}