import '../constants/app_texts.dart';

abstract final class Validators {
  static String? productName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.productNameRequired;
    }
    return null;
  }

  /// « 12,5 » ou « 12.5 » → 12.5 (virgule française acceptée).
  static num? parseQuantity(String? value) =>
      num.tryParse((value ?? '').trim().replaceAll(',', '.'));

  static String? quantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.quantityRequired;
    }

    final quantity = parseQuantity(value);

    if (quantity == null || quantity <= 0) {
      return AppTexts.quantityInvalid;
    }

    return null;
  }

  static String? minimumPrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.minimumPriceRequired;
    }

    final price = int.tryParse(value.trim());

    if (price == null || price <= 0) {
      return AppTexts.minimumPriceInvalid;
    }

    return null;
  }

  static String? harvestDate(DateTime? value) {
    if (value == null) {
      return AppTexts.harvestDateRequired;
    }

    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppTexts.addressRequired;
    }

    return null;
  }
}
