// lib/models/order_model.dart
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String status; // 'En attente', 'Confirmé', 'En cours', 'Livré', 'Annulé'
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'],
      items: (map['items'] as List).map((item) => CartItemModel.fromMap(item)).toList(),
      totalAmount: map['totalAmount'].toDouble(),
      status: map['status'],
      orderDate: DateTime.parse(map['orderDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    List<CartItemModel>? items,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
    );
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get isCompleted => status == 'Livré';
  bool get isCancelled => status == 'Annulé';
  bool get isPending => status == 'En attente';
}