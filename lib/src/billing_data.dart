class BillingData {
  String? apartment;
  String? email;
  String? floor;
  String? firstName;
  String? street;
  String? building;
  String? phoneNumber;
  String? shippingMethod;
  String? postalCode;
  String? city;
  String? country;
  String? lastName;
  String? state;

  BillingData({
    this.apartment = 'NA',
    this.email = 'NA',
    this.floor = 'NA',
    this.firstName = 'NA',
    this.street = 'NA',
    this.building = 'NA',
    this.phoneNumber = 'NA',
    this.shippingMethod = 'NA',
    this.postalCode = 'NA',
    this.city = 'NA',
    this.country = 'NA',
    this.lastName = 'NA',
    this.state = 'NA',
  });

  Map<String, dynamic> toJson() => {
        'apartment': apartment,
        'email': email,
        'floor': floor,
        'first_name': firstName,
        'street': street,
        'building': building,
        'phone_number': phoneNumber,
        'shipping_method': shippingMethod,
        'postal_code': postalCode,
        'city': city,
        'country': country,
        'last_name': lastName,
        'state': state,
      };
}