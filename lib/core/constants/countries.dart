/// Pays proposés à l'inscription (Afrique de l'Ouest).
/// Chaque pays ajouté doit aussi être autorisé dans Firebase :
/// Authentication → Settings → SMS region policy.
class Country {
  const Country(
    this.name,
    this.flag,
    this.dialCode,
    this.lengths, {
    this.trunkZero = false,
    this.startsWith = '',
    this.currency = 'XOF',
  });

  final String name;
  final String flag;

  /// Code ISO de la monnaie (XOF = franc CFA UEMOA), voir [currencySymbols].
  final String currency;

  /// Ex. « +229 ».
  final String dialCode;

  /// Longueurs possibles du numéro national, sans indicatif ni 0 de tête.
  final List<int> lengths;

  /// true = en national on tape un « 0 » devant (Nigeria : 0803… → +234 803…), retiré ici.
  final bool trunkZero;

  /// Début obligatoire du numéro national (Bénin : 01).
  final String startsWith;

  int get maxInputLength =>
      lengths.reduce((a, b) => a > b ? a : b) + (trunkZero ? 1 : 0);

  /// Numéro complet « +229… » si [input] est valide pour ce pays, sinon null.
  String? toE164(String? input) {
    var digits = (input ?? '').replaceAll(RegExp(r'\D'), '');
    if (trunkZero && digits.startsWith('0')) digits = digits.substring(1);
    if (!lengths.contains(digits.length) || !digits.startsWith(startsWith)) {
      return null;
    }
    return dialCode + digits;
  }
}

/// Symbole affiché après le prix, par code ISO.
const currencySymbols = {
  'XOF': 'FCFA',
  'CVE': 'ECV',
  'GMD': 'D',
  'GHS': 'GH₵',
  'GNF': 'GNF',
  'LRD': 'L\$',
  'MRU': 'UM',
  'NGN': '₦',
  'SLE': 'Le',
};

abstract final class Countries {
  static const benin = Country('Bénin', '🇧🇯', '+229', [10], startsWith: '01');

  static const all = [
    benin,
    Country('Burkina Faso', '🇧🇫', '+226', [8]),
    Country('Cap-Vert', '🇨🇻', '+238', [7], currency: 'CVE'),
    Country('Côte d\'Ivoire', '🇨🇮', '+225', [10]),
    Country('Gambie', '🇬🇲', '+220', [7], currency: 'GMD'),
    Country('Ghana', '🇬🇭', '+233', [9], trunkZero: true, currency: 'GHS'),
    Country('Guinée', '🇬🇳', '+224', [9], currency: 'GNF'),
    Country('Guinée-Bissau', '🇬🇼', '+245', [9]),
    Country('Liberia', '🇱🇷', '+231', [8, 9], trunkZero: true, currency: 'LRD'),
    Country('Mali', '🇲🇱', '+223', [8]),
    Country('Mauritanie', '🇲🇷', '+222', [8], currency: 'MRU'),
    Country('Niger', '🇳🇪', '+227', [8]),
    Country('Nigeria', '🇳🇬', '+234', [10], trunkZero: true, currency: 'NGN'),
    Country('Sénégal', '🇸🇳', '+221', [9]),
    Country('Sierra Leone', '🇸🇱', '+232', [8], trunkZero: true, currency: 'SLE'),
    Country('Togo', '🇹🇬', '+228', [8]),
  ];

  /// Pays d'un numéro complet (« +234… » → Nigeria). Inconnu → Bénin.
  static Country fromPhone(String phone) => all.firstWhere(
        (c) => phone.startsWith(c.dialCode),
        orElse: () => benin,
      );
}
