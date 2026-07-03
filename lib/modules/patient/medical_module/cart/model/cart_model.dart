class CartItem {
  final String medicineId;
  final String name;
  final String brand;
  final String dosage;
  final String imageUrl;
  final double price;

  int quantity;

  CartItem({
    required this.medicineId,
    required this.name,
    required this.brand,
    required this.dosage,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}
