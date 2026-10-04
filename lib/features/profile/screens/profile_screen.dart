import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers.dart';

/// Profil utilisateur : téléphone (lecture seule), nom modifiable, rôle, déconnexion.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  String? _boundUid;
  var _nameReady = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _ensureName(AppUser user) {
    if (_boundUid == user.uid) return;
    _boundUid = user.uid;
    _name.text = user.name;
    _nameReady = true;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(profileProvider.notifier).updateName(_name.text);
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final profile = ref.watch(profileProvider);
    final theme = Theme.of(context);

    ref.listen(authProvider, (prev, next) {
      final user = next.value;
      if (user == null) return;
      if (_boundUid == user.uid) return;
      setState(() => _ensureName(user));
    });

    ref.listen(profileProvider, (prev, next) {
      if (next.saved && prev?.saved != true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppTexts.nameSaved)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.profileTitle)),
      body: authAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text(AppTexts.profileUnavailable)),
        data: (user) {
          if (user == null) {
            return const Center(child: Text(AppTexts.profileUnavailable));
          }
          if (!_nameReady || _boundUid != user.uid) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() => _ensureName(user));
            });
          }

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spacing * 1.5),
              children: [
                const SizedBox(height: 8),
                Icon(
                  user.role == UserRole.producer
                      ? Icons.agriculture
                      : Icons.storefront,
                  size: 64,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: AppTheme.spacing),
                Text(
                  AppTexts.roleLabelFor(user.role.name),
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Text(
                  AppTexts.roleLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Text(AppTexts.phoneLabel, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    helperText: AppTexts.phoneReadonlyHint,
                  ),
                  child: Text(
                    user.phone,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 24),
                Text(AppTexts.nameLabel, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? AppTexts.nameRequired
                        : null,
                    onFieldSubmitted: (_) => _save(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: profile.loading ? null : _save,
                  child: profile.loading
                      ? const SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      : const Text(AppTexts.save),
                ),
                if (profile.error != null) ...[
                  const SizedBox(height: AppTheme.spacing),
                  Text(
                    profile.error!,
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 48),
                OutlinedButton.icon(
                  onPressed: profile.loading
                      ? null
                      : () => ref.read(profileProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text(AppTexts.logout),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    minimumSize: const Size.fromHeight(AppTheme.buttonHeight),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
