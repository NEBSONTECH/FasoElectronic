// lib/services/data_service.dart
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class DataService {
  // Singleton pattern pour avoir une seule instance
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Données des produits (simulées - remplacées par Firebase plus tard)
  final List<ProductModel> _products = [
    // Smartphones
    ProductModel(
      id: 'phone_001',
      name: 'iPhone 15 Pro',
      description: 'Dernier iPhone avec puce A17 Pro, appareil photo professionnel et écran Super Retina XDR. Parfait pour la photographie et les vidéos.',
      price: 650000,
      imageUrl: 'https://via.placeholder.com/300x300?text=iPhone+15+Pro',
      category: 'Smartphones',
      stock: 15,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'phone_002',
      name: 'Samsung Galaxy S24',
      description: 'Galaxy S24 avec intelligence artificielle intégrée, appareil photo 50MP et écran Dynamic AMOLED 2X.',
      price: 550000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Galaxy+S24',
      category: 'Smartphones',
      stock: 23,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'phone_003',
      name: 'Tecno Camon 20',
      description: 'Smartphone Tecno populaire au Burkina Faso, excellente autonomie et appareil photo portrait.',
      price: 180000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Tecno+Camon+20',
      category: 'Smartphones',
      stock: 45,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'phone_004',
      name: 'Infinix Hot 40',
      description: 'Smartphone abordable avec grande batterie 5000mAh, idéal pour les étudiants burkinabé.',
      price: 120000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Infinix+Hot+40',
      category: 'Smartphones',
      stock: 60,
      createdAt: DateTime.now(),
    ),

    // Ordinateurs
    ProductModel(
      id: 'laptop_001',
      name: 'MacBook Air M3',
      description: 'MacBook Air avec puce M3, 13 pouces, parfait pour le travail et la créativité. Autonomie exceptionnelle.',
      price: 850000,
      imageUrl: 'https://via.placeholder.com/300x300?text=MacBook+Air+M3',
      category: 'Ordinateurs',
      stock: 8,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'laptop_002',
      name: 'Dell Inspiron 15',
      description: 'Ordinateur portable Dell fiable, processeur Intel Core i5, 8GB RAM, SSD 512GB.',
      price: 450000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Dell+Inspiron+15',
      category: 'Ordinateurs',
      stock: 12,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'laptop_003',
      name: 'HP Pavilion Gaming',
      description: 'PC portable gaming HP avec carte graphique dédiée, parfait pour les jeux et le design.',
      price: 520000,
      imageUrl: 'https://via.placeholder.com/300x300?text=HP+Pavilion+Gaming',
      category: 'Ordinateurs',
      stock: 6,
      createdAt: DateTime.now(),
    ),

    // Audio
    ProductModel(
      id: 'audio_001',
      name: 'AirPods Pro',
      description: 'Écouteurs Apple avec réduction de bruit active, qualité audio exceptionnelle.',
      price: 125000,
      imageUrl: 'https://via.placeholder.com/300x300?text=AirPods+Pro',
      category: 'Audio',
      stock: 30,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'audio_002',
      name: 'Sony WH-1000XM5',
      description: 'Casque sans fil Sony avec la meilleure réduction de bruit du marché.',
      price: 185000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Sony+WH-1000XM5',
      category: 'Audio',
      stock: 18,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'audio_003',
      name: 'JBL Flip 6',
      description: 'Enceinte Bluetooth portable étanche, son puissant, parfaite pour les fêtes.',
      price: 65000,
      imageUrl: 'https://via.placeholder.com/300x300?text=JBL+Flip+6',
      category: 'Audio',
      stock: 25,
      createdAt: DateTime.now(),
    ),

    // Télévisions
    ProductModel(
      id: 'tv_001',
      name: 'Samsung Smart TV 55"',
      description: 'TV Samsung 55 pouces 4K UHD, Smart TV avec Netflix, YouTube intégrés.',
      price: 380000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Samsung+TV+55',
      category: 'Télévisions',
      stock: 10,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'tv_002',
      name: 'LG OLED 48"',
      description: 'TV LG OLED 48 pouces, qualité d\'image exceptionnelle, parfaite pour le gaming.',
      price: 650000,
      imageUrl: 'https://via.placeholder.com/300x300?text=LG+OLED+48',
      category: 'Télévisions',
      stock: 5,
      createdAt: DateTime.now(),
    ),

    // Électroménager
    ProductModel(
      id: 'appliance_001',
      name: 'Réfrigérateur LG 350L',
      description: 'Réfrigérateur LG 350 litres, économe en énergie, adapté au climat burkinabé.',
      price: 420000,
      imageUrl: 'https://via.placeholder.com/300x300?text=LG+Frigo+350L',
      category: 'Électroménager',
      stock: 8,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'appliance_002',
      name: 'Climatiseur Split 12000 BTU',
      description: 'Climatiseur split 12000 BTU, indispensable pour le confort à Ouagadougou.',
      price: 285000,
      imageUrl: 'https://via.placeholder.com/300x300?text=Clim+Split+12000',
      category: 'Électroménager',
      stock: 15,
      createdAt: DateTime.now(),
    ),
  ];

  // Panier de l'utilisateur (en mémoire pour l'instant)
  final List<CartItemModel> _cartItems = [];

  // Commandes de l'utilisateur
  final List<OrderModel> _orders = [];

  // Getters pour accéder aux données
  List<ProductModel> get products => List.unmodifiable(_products);
  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);
  List<OrderModel> get orders => List.unmodifiable(_orders);

  // Méthodes pour gérer les produits
  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<String> getCategories() {
    return _products.map((product) => product.category).toSet().toList();
  }

  List<ProductModel> searchProducts(String query) {
    return _products.where((product) => 
      product.name.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Méthodes pour gérer le panier
  void addToCart(ProductModel product, int quantity) {
    // Vérifier si le produit est déjà dans le panier
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id
    );

    if (existingIndex != -1) {
      // Augmenter la quantité
      _cartItems[existingIndex].quantity += quantity;
    } else {
      // Ajouter nouveau produit au panier
      _cartItems.add(CartItemModel(
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        price: product.price,
        quantity: quantity,
      ));
    }
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.productId == productId);
  }

  void updateCartItemQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _cartItems[index].quantity = newQuantity;
    }
  }

  void clearCart() {
    _cartItems.clear();
  }

  double getTotalCartPrice() {
    return _cartItems.fold(0.0, (total, item) => total + item.totalPrice);
  }

  int getTotalCartItems() {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  // Méthodes pour gérer les commandes
  String placeOrder(String userId) {
    if (_cartItems.isEmpty) return '';

    final orderId = 'CMD${DateTime.now().millisecondsSinceEpoch}';
    final order = OrderModel(
      id: orderId,
      userId: userId,
      items: List.from(_cartItems),
      totalAmount: getTotalCartPrice(),
      status: 'En attente',
      orderDate: DateTime.now(),
    );

    _orders.add(order);
    clearCart();
    return orderId;
  }

  List<OrderModel> getUserOrders(String userId) {
    return _orders.where((order) => order.userId == userId).toList();
  }

  // Statistiques pour l'admin
  Map<String, dynamic> getAdminStats() {
    return {
      'totalProducts': _products.length,
      'totalOrders': _orders.length,
      'totalRevenue': _orders.fold(0.0, (sum, order) => sum + order.totalAmount),
      'lowStockProducts': _products.where((p) => p.stock < 10).length,
    };
  }

  List<OrderModel> getRecentOrders({int limit = 10}) {
    final sortedOrders = List<OrderModel>.from(_orders);
    sortedOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return sortedOrders.take(limit).toList();
  }
}