class Country {
  final String code;
  final String id;
  final String slug;
  final String countryCode;

  Country({
    required this.code,
    required this.id,
    required this.slug,
    required this.countryCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      id: json['id'].toString(),
      slug: json['slug'] as String,
      countryCode: json['country_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'slug': slug,
      'country_code': countryCode,
      'id': id,
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
