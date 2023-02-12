part of flutter_naver_map;

class NLocale extends Locale with NMessageableWithMap {
  const NLocale(super.languageCode);

  NLocale.fromLocale(Locale locale) : super(locale.languageCode);

  @override
  NPayload toNPayload() => NPayload.make({
        "languageCode": languageCode,
        "countryCode": countryCode,
      });

  static const NLocale systemLocale = NLocale("sys");
}
