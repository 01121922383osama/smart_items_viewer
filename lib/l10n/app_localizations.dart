import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get items => _localizedValues[locale.languageCode]!['items']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get pullToRefresh =>
      _localizedValues[locale.languageCode]!['pullToRefresh']!;
  String get emptyList => _localizedValues[locale.languageCode]!['emptyList']!;
  String get cachedDataShown =>
      _localizedValues[locale.languageCode]!['cachedDataShown']!;
  String get updated => _localizedValues[locale.languageCode]!['updated']!;
  String get noConnectionOfflineMode =>
      _localizedValues[locale.languageCode]!['noConnectionOfflineMode']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get price => _localizedValues[locale.languageCode]!['price']!;
  String get rating => _localizedValues[locale.languageCode]!['rating']!;
  String get stock => _localizedValues[locale.languageCode]!['stock']!;
  String get brand => _localizedValues[locale.languageCode]!['brand']!;
  String get category => _localizedValues[locale.languageCode]!['category']!;
  String get discount => _localizedValues[locale.languageCode]!['discount']!;
  String get outOfStock =>
      _localizedValues[locale.languageCode]!['outOfStock']!;
  String get inStock => _localizedValues[locale.languageCode]!['inStock']!;
  String get reviews => _localizedValues[locale.languageCode]!['reviews']!;
  String get warranty => _localizedValues[locale.languageCode]!['warranty']!;
  String get shipping => _localizedValues[locale.languageCode]!['shipping']!;
  String get returnPolicy =>
      _localizedValues[locale.languageCode]!['returnPolicy']!;
  String get minimumOrder =>
      _localizedValues[locale.languageCode]!['minimumOrder']!;
  String get weight => _localizedValues[locale.languageCode]!['weight']!;
  String get dimensions =>
      _localizedValues[locale.languageCode]!['dimensions']!;
  String get barcode => _localizedValues[locale.languageCode]!['barcode']!;
  String get qrCode => _localizedValues[locale.languageCode]!['qrCode']!;
  String get createdAt => _localizedValues[locale.languageCode]!['createdAt']!;
  String get updatedAt => _localizedValues[locale.languageCode]!['updatedAt']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get light => _localizedValues[locale.languageCode]!['light']!;
  String get dark => _localizedValues[locale.languageCode]!['dark']!;
  String get arabic => _localizedValues[locale.languageCode]!['arabic']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get system => _localizedValues[locale.languageCode]!['system']!;
  String get online => _localizedValues[locale.languageCode]!['online']!;
  String get offline => _localizedValues[locale.languageCode]!['offline']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

final Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'items': 'Items',
    'retry': 'Retry',
    'pullToRefresh': 'Pull to refresh',
    'emptyList': 'No items available',
    'cachedDataShown': 'Showing cached data',
    'updated': 'Updated',
    'noConnectionOfflineMode': 'No connection - Offline mode',
    'loading': 'Loading...',
    'error': 'Error',
    'price': 'Price',
    'rating': 'Rating',
    'stock': 'Stock',
    'brand': 'Brand',
    'category': 'Category',
    'discount': 'Discount',
    'outOfStock': 'Out of Stock',
    'inStock': 'In Stock',
    'reviews': 'Reviews',
    'warranty': 'Warranty',
    'shipping': 'Shipping',
    'returnPolicy': 'Return Policy',
    'minimumOrder': 'Min. Order',
    'weight': 'Weight',
    'dimensions': 'Dimensions',
    'barcode': 'Barcode',
    'qrCode': 'QR Code',
    'createdAt': 'Created',
    'updatedAt': 'Updated',
    'language': 'Language',
    'theme': 'Theme',
    'light': 'Light',
    'dark': 'Dark',
    'arabic': 'Arabic',
    'english': 'English',
    'system': 'System',
    'online': 'Online',
    'offline': 'Offline',
  },
  'ar': {
    'items': 'العناصر',
    'retry': 'إعادة المحاولة',
    'pullToRefresh': 'اسحب للتحديث',
    'emptyList': 'لا توجد عناصر متاحة',
    'cachedDataShown': 'عرض البيانات المحفوظة',
    'updated': 'تم التحديث',
    'noConnectionOfflineMode': 'لا يوجد اتصال - وضع عدم الاتصال',
    'loading': 'جاري التحميل...',
    'error': 'خطأ',
    'price': 'السعر',
    'rating': 'التقييم',
    'stock': 'المخزون',
    'brand': 'العلامة التجارية',
    'category': 'الفئة',
    'discount': 'الخصم',
    'outOfStock': 'نفد المخزون',
    'inStock': 'متوفر',
    'reviews': 'التقييمات',
    'warranty': 'الضمان',
    'shipping': 'الشحن',
    'returnPolicy': 'سياسة الإرجاع',
    'minimumOrder': 'الحد الأدنى للطلب',
    'weight': 'الوزن',
    'dimensions': 'الأبعاد',
    'barcode': 'الباركود',
    'qrCode': 'رمز QR',
    'createdAt': 'تاريخ الإنشاء',
    'updatedAt': 'تاريخ التحديث',
    'language': 'اللغة',
    'theme': 'المظهر',
    'light': 'فاتح',
    'dark': 'داكن',
    'arabic': 'العربية',
    'english': 'الإنجليزية',
    'system': 'النظام',
    'online': 'متصل',
    'offline': 'غير متصل',
  },
};
