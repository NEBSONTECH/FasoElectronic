// lib/models/cart_item_model.dart
class CartItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'],
      productName: map['productName'],
      productImage: map['productImage'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
    );
  }

  CartItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}