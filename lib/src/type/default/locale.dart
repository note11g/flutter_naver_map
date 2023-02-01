part of flutter_naver_map;

class NLocale extends Locale implements NMessageable {
  const NLocale(super.languageCode);

  const NLocale.fromSubtags({
    String languageCode = "und",
    String? countryCode,
  }) : super.fromSubtags(languageCode: languageCode, countryCode: countryCode);

  NLocale.fromLocale(Locale locale) : super(locale.languageCode);

  @override
  NPayload toNPayload() => NPayload.make({
        "languageCode": languageCode,
        "countryCode": countryCode,
      });

  static const NLocale systemLocale = NLocale("sys");
}
