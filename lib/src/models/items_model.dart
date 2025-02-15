class ItemsModel {
  String? name;
  String? amountCents;
  String? description;
  String? quantity;

  ItemsModel({this.name, this.amountCents, this.description, this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount_cents': amountCents,
      'description': description,
      'quantity': quantity
    };
  }
}
