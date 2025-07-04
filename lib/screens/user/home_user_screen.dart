 // lib/screens/user/home_user_screen.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../services/data_service.dart';
import '../../models/product_model.dart';

class HomeUserScreen extends StatefulWidget {
  final String userEmail;

  const HomeUserScreen({super.key, required this.userEmail});

  @override
  _HomeUserScreenState createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  int _selectedIndex = 0;
  final DataService _dataService = DataService();
  String _selectedCategory = 'Tous';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FasoElectronic'),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onPrimary),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: AppColors.onPrimary),
                onPressed: () {
                  _showCartDialog();
                },
              ),
              if (_dataService.getTotalCartItems() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${_dataService.getTotalCartItems()}',
                      style: const TextStyle(
                        color: AppColors.onAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.person, color: AppColors.onPrimary),
            onSelected: (String value) {
              if (value == 'logout') {
                _handleLogout();
              } else if (value == 'profile') {
                Helpers.showToast('Profil bientôt disponible');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.textPrimary),
                    SizedBox(width: AppSpacing.sm),
                    Text('Profil'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.error),
                    SizedBox(width: AppSpacing.sm),
                    Text('Déconnexion', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Commandes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.cardBackground,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildCategoriesTab();
      case 2:
        return _buildOrdersTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    final products = _selectedCategory == 'Tous' 
        ? _dataService.products 
        : _dataService.getProductsByCategory(_selectedCategory);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message de bienvenue
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.waving_hand, color: AppColors.accent, size: 24),
                    SizedBox(width: AppSpacing.sm),
                    Text('Bienvenue !', style: AppTextStyles.heading2),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Connecté en tant que: ${widget.userEmail}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${_dataService.products.length} produits disponibles',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Filtres par catégorie
          const Text('Catégories', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip('Tous'),
                ..._dataService.getCategories().map((category) => _buildCategoryChip(category)),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Section produits
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedCategory == 'Tous' ? 'Tous nos produits' : _selectedCategory,
                style: AppTextStyles.heading2,
              ),
              Text(
                '${products.length} produit${products.length > 1 ? 's' : ''}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Grille de produits
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        backgroundColor: AppColors.cardBackground,
        selectedColor: AppColors.accent,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.onAccent : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.accent : AppColors.border,
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du produit
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  topRight: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getIconForCategory(product.category),
                      size: 50,
                      color: AppColors.accent,
                    ),
                  ),
                  if (product.isLowStock)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Stock faible',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Informations du produit
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    Helpers.formatPrice(product.price),
                    style: AppTextStyles.price.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Stock: ${product.stock}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: product.isInStock ? () => _addToCart(product) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: Text(
                        product.isInStock ? 'Ajouter' : 'Rupture',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final categories = _dataService.getCategories();
    
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Catégories', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final productCount = _dataService.getProductsByCategory(category).length;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: Icon(_getIconForCategory(category), color: AppColors.accent),
                    title: Text(category, style: AppTextStyles.bodyLarge),
                    subtitle: Text('$productCount produit${productCount > 1 ? 's' : ''}'),
                    trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final orders = _dataService.getUserOrders(widget.userEmail);
    
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          const Text('Mes commandes', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: orders.isEmpty ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.textSecondary),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Aucune commande', style: AppTextStyles.heading3),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Vous n\'avez pas encore passé de commande',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  CustomButton(
                    text: 'Explorer les produits',
                    onPressed: () => setState(() => _selectedIndex = 0),
                    width: 200,
                  ),
                ],
              ),
            ) : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.id, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                          Text(order.status, style: const TextStyle(color: AppColors.accent)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('${order.totalItems} article${order.totalItems > 1 ? 's' : ''}'),
                      Text(Helpers.formatPrice(order.totalAmount), style: AppTextStyles.price),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(ProductModel product) {
    _dataService.addToCart(product, 1);
    setState(() {}); // Refresh pour mettre à jour le badge du panier
    Helpers.showToast('${product.name} ajouté au panier');
  }

  void _showCartDialog() {
    final cartItems = _dataService.cartItems;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Mon panier', style: AppTextStyles.heading3),
        content: cartItems.isEmpty 
          ? const Text('Votre panier est vide')
          : SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...cartItems.map((item) => ListTile(
                    title: Text(item.productName),
                    subtitle: Text('Quantité: ${item.quantity}'),
                    trailing: Text(Helpers.formatPrice(item.totalPrice)),
                  )),
                  const Divider(),
                  Text('Total: ${Helpers.formatPrice(_dataService.getTotalCartPrice())}', 
                       style: AppTextStyles.price),
                ],
              ),
            ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (cartItems.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                final orderId = _dataService.placeOrder(widget.userEmail);
                Navigator.pop(context);
                setState(() {}); // Refresh
                Helpers.showToast('Commande $orderId passée avec succès !');
              },
              child: const Text('Commander'),
            ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: const Text('Rechercher', style: AppTextStyles.heading3),
            content: TextField(
              onChanged: (value) => searchQuery = value,
              decoration: const InputDecoration(
                hintText: 'Nom du produit...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (searchQuery.isNotEmpty) {
                    final results = _dataService.searchProducts(searchQuery);
                    Navigator.pop(context);
                    Helpers.showToast('${results.length} résultat${results.length > 1 ? 's' : ''} trouvé${results.length > 1 ? 's' : ''}');
                  }
                },
                child: const Text('Rechercher'),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Smartphones': return Icons.smartphone;
      case 'Ordinateurs': return Icons.laptop;
      case 'Audio': return Icons.headphones;
      case 'Télévisions': return Icons.tv;
      case 'Électroménager': return Icons.kitchen;
      default: return Icons.category;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Déconnexion', style: AppTextStyles.heading3),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?', style: AppTextStyles.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Helpers.showToast('Déconnexion réussie');
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}