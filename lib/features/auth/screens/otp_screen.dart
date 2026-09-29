import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/theme/app_theme.dart';
import '../providers.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(phoneAuthProvider.notifier).verifyCode(_code.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(phoneAuthProvider);
    final theme = Theme.of(context);

    // ponytail: pas de compte à rebours avant « Renvoyer » ; Firebase limite déjà les abus.
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacing * 1.5),
          children: [
            Text(AppTexts.otpTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(AppTexts.otpSentTo(auth.phone ?? '')),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _code,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, letterSpacing: 12),
                maxLength: AppConfig.otpLength,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofillHints: const [AutofillHints.oneTimeCode],
                decoration: const InputDecoration(counterText: ''),
                validator: (v) =>
                    v?.length == AppConfig.otpLength ? null : AppTexts.otpInvalid,
                onChanged: (v) {
                  if (v.length == AppConfig.otpLength && !auth.loading) _submit();
                },
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: auth.loading ? null : _submit,
              child: auth.loading
                  ? const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : const Text(AppTexts.validate),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: auth.loading
                  ? null
                  : ref.read(phoneAuthProvider.notifier).resendCode,
              child: const Text(AppTexts.resendCode),
            ),
            if (auth.error != null)
              Text(
                auth.error!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
