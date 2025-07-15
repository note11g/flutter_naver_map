part of "../../../flutter_naver_map.dart";

/// Flutter 네이버 지도 SDK에서 사용하는 Locale 객체입니다.
///
/// 현재 네이버 지도 SDK는 한국어, 영어, 중국어, 일본어만을 지원합니다.
class NLocale extends Locale with NMessageableWithMap {
  const NLocale(super.languageCode, [super.countryCode]);

  NLocale.fromLocale(Locale locale)
      : super(locale.languageCode, locale.countryCode);

  @override
  NPayload toNPayload() => NPayload.make({
        "languageCode": languageCode,
        "countryCode": countryCode,
      });

  static const NLocale systemLocale = NLocale("sys");
}
