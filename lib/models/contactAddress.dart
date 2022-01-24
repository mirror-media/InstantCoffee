class ContactAddress {
  String? country;
  String? city;
  String? district;
  String? address;

  ContactAddress({
    this.country,
    this.city,
    this.district,
    this.address,
  });
  
  @override
  String toString() {
    return '$country, $city, $district, $address';
  }
}