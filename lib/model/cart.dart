class CartItem{
  String id;
  String itemID;
  String userID;
  String type;
  String name;
  double price;
  int quantity;
  double total;
  String imageUrl;

  CartItem({
    required this.id,
    required this.itemID,
    required this.userID,
    required this.type,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.imageUrl
  });
}