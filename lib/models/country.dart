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
      code: json['code'],
      slug: json['slug'],
      countryCode: json['country_code'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'slug': slug,
      'countryCode': countryCode,
      'id': id,
    };
  }
}

class CountriesResponse {
  
}
