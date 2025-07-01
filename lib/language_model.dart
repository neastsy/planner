class Language {
  final String code;
  final String name;

  const Language({required this.code, required this.name});

  static List<Language> languageList() {
    return <Language>[
      const Language(code: 'tr', name: 'Türkçe'),
      const Language(code: 'en', name: 'English'),
      const Language(code: 'de', name: 'Deutsch'),
      const Language(code: 'fr', name: 'Français'),
      const Language(code: 'es', name: 'Español'),
      const Language(code: 'ru', name: 'Русский'),
      const Language(code: 'ar', name: 'العربية'),
      const Language(code: 'ja', name: '日本語'),
      const Language(code: 'zh', name: '中文'),
    ];
  }
}