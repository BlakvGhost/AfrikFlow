class Country {
  final String code;
  final String id;
  final String slug;
  final String flag;
  final String countryCode;
  final String currency;

  Country({
    required this.code,
    required this.id,
    required this.slug,
    required this.flag,
    required this.countryCode,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      id: json['id'].toString(),
      slug: json['slug'] as String,
      flag: json['flag'] as String,
      countryCode: json['country_code'] as String,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'slug': slug,
      'flag': flag,
      'country_code': countryCode,
      'id': id,
      'currency': currency,
    };
  }
}

class CountriesResponse {
  final List<Country> countries;
  final Country currentCountry;

  CountriesResponse({
    required this.countries,
    required this.currentCountry,
  });

  factory CountriesResponse.fromJson(Map<String, dynamic> json) {
    var countriesList = (json['countries'] as List)
        .map((countryJson) => Country.fromJson(countryJson))
        .toList();

    return CountriesResponse(
      countries: countriesList,
      currentCountry: Country.fromJson(json['currentCountry']),
    );
  }
}
