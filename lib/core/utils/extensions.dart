import 'package:intl/intl.dart';

final _thousands = NumberFormat.decimalPattern('fr');
final _date = DateFormat('dd/MM/yyyy');

extension PriceFormat on num {
  /// 15000 → « 15 000 FCFA »
  String get fcfa => '${_thousands.format(this)} FCFA';
}

extension DateFormatFr on DateTime {
  /// → « 29/09/2026 »
  String get dmy => _date.format(this);
}

extension PhoneFormat on String {
  /// « +229 01 97… » → « 2290197… » (pour wa.me).
  String get digitsOnly => replaceAll(RegExp(r'\D'), '');

  /// « +2290197000000 » → « +229 01 97 00 00 00 ». Autre format : renvoyé tel quel.
  String get phoneFr {
    final digits = digitsOnly;
    if (digits.length != 13 || !digits.startsWith('229')) return this;
    final local = digits.substring(3);
    final pairs = [for (var i = 0; i < 10; i += 2) local.substring(i, i + 2)];
    return '+229 ${pairs.join(' ')}';
  }
}
