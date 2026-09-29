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
