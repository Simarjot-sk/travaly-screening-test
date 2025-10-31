class PropertyDto {
  final String propertyName;
  final int? propertyStar;
  final String? propertyImage;
  final String? rate;
  final PropertyAddress? address;

  const PropertyDto({
    required this.propertyName,
    this.propertyStar,
    this.propertyImage,
    this.address,
    this.rate,
  });
}

class PropertyAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? mapAddress;

  const PropertyAddress({
    this.street,
    this.city,
    this.state,
    this.country,
    this.mapAddress,
  });
}
