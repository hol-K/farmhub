import 'package:farmhub/core/constants/app_texts.dart';
import 'package:farmhub/core/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('textes profil centralisés', () {
    expect(AppTexts.appName, 'FarmHub');
    expect(AppTexts.profileTitle, 'Profil');
    expect(AppTexts.logout, 'Se déconnecter');
    expect(AppTexts.roleLabelFor(UserRole.producer.name), AppTexts.roleProducer);
    expect(AppTexts.roleLabelFor(UserRole.buyer.name), AppTexts.roleBuyer);
  });
}
