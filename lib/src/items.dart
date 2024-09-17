class Items {
  String? name;
  String? amountCents;
  String? description;
  String? quantity;

  Items({this.name, this.amountCents, this.description, this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount_cents': amountCents,
      'description': description,
      'quantity': quantity
    };
  }
}