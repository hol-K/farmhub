import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers.dart';

/// Après la 1re connexion : nom + rôle. Crée users/{uid}.
class ProfileChoiceScreen extends ConsumerStatefulWidget {
  const ProfileChoiceScreen({super.key});

  @override
  ConsumerState<ProfileChoiceScreen> createState() => _ProfileChoiceScreenState();
}

class _ProfileChoiceScreenState extends ConsumerState<ProfileChoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _choose(UserRole role) {
    if (!_formKey.currentState!.validate()) return;
    ref.read(phoneAuthProvider.notifier).createProfile(name: _name.text, role: role);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(phoneAuthProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing * 1.5),
          children: [
            const SizedBox(height: 32),
            Text(AppTexts.roleTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  labelText: AppTexts.nameLabel,
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? AppTexts.nameRequired : null,
              ),
            ),
            const SizedBox(height: 32),
            _RoleButton(
              icon: Icons.agriculture,
              label: AppTexts.iAmProducer,
              onPressed: auth.loading ? null : () => _choose(UserRole.producer),
            ),
            const SizedBox(height: AppTheme.spacing),
            _RoleButton(
              icon: Icons.storefront,
              label: AppTexts.iAmBuyer,
              onPressed: auth.loading ? null : () => _choose(UserRole.buyer),
            ),
            if (auth.loading)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (auth.error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppTheme.spacing),
                child: Text(
                  auth.error!,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({required this.icon, required this.label, this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppTheme.iconSize),
      label: Text(label),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(88)),
    );
  }
}
