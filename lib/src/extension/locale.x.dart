import 'dart:ui';

extension LocaleX on Locale {
  String get languageName {
    return switch (languageCode) {
      'zh' => '中文',
      'en' => 'English',
      'es' => 'Español',
      'fr' => 'Français',
      'de' => 'Deutsch',
      'it' => 'Italiano',
      'pt' => 'Português',
      'ru' => 'Русский',
      'ja' => '日本語',
      'ko' => '한국어',
      'ar' => 'العربية',
      'hi' => 'हिन्दी',
      'tr' => 'Türkçe',
      'vi' => 'Tiếng Việt',
      'th' => 'ไทย',
      'pl' => 'Polski',
      'nl' => 'Nederlands',
      'sv' => 'Svenska',
      'da' => 'Dansk',
      'fi' => 'Suomi',
      'el' => 'Ελληνικά',
      'he' => 'עברית',
      'id' => 'Bahasa Indonesia',
      'ms' => 'Bahasa Melayu',
      'tl' => 'Wikang Tagalog',
      'ca' => 'Català',
      'ro' => 'Română',
      'hu' => 'Magyar',
      'cs' => 'Čeština',
      'sk' => 'Slovenčina',
      'bg' => 'Български',
      'uk' => 'Українська',
      'hr' => 'Hrvatski',
      'sl' => 'Slovenščina',
      'et' => 'Eesti',
      'lv' => 'Latviešu',
      'lt' => 'Lietuvių',
      'af' => 'Afrikaans',
      'is' => 'Íslenska',
      'jw' => 'Basa Jawa',
      _ => '未知',
    };
  }
}

extension LocaleIterableX on Iterable<Locale> {
  List<String> get languageNames {
    return [for (final item in this) item.languageName];
  }
}
