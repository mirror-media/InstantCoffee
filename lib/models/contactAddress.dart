class ContactAddress {
  String country;
  String city;
  String district;
  String address;

  ContactAddress({
    this.country,
    this.city,
    this.district,
    this.address,
  });

  // deep copy
  ContactAddress copy() {
    return ContactAddress(
      country: this.country,
      city: this.city,
      district: this.district,
      address: this.address,
    );
  }

  @override
  String toString() {
    return '$country, $city, $district, $address';
  }
}