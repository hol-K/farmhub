import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/theme/app_theme.dart';
import '../providers.dart';
import '../widgets/phone_input_field.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(phoneAuthProvider.notifier).sendCode(_phone.text);
  }

  @override
  Widget build(BuildContext context) {
    // SMS envoyé → écran du code.
    ref.listen(phoneAuthProvider, (prev, next) {
      if (prev?.verificationId == null && next.verificationId != null) {
        context.push('/otp');
      }
    });
    final auth = ref.watch(phoneAuthProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing * 1.5),
          children: [
            const SizedBox(height: 48),
            const Icon(Icons.agriculture, size: 72, color: AppTheme.primary),
            Text(
              AppTexts.appName,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Text(AppTexts.tagline, textAlign: TextAlign.center),
            const SizedBox(height: 48),
            Text(AppTexts.phoneTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: PhoneInputField(controller: _phone, onSubmitted: (_) => _submit()),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: auth.loading ? null : _submit,
              child: auth.loading
                  ? const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Text(AppTexts.sendCode),
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
