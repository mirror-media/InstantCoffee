class District {
  final String zip;
  final String name;    

  District({
    this.zip,
    this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      zip: json['zip'],
      name: json['name'],
    );
  }
}