// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../services/data_service.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final DataService _dataService = DataService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.onPrimary),
            onPressed: () {
              setState(() {}); // Refresh des données
              Helpers.showToast('Données actualisées');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.onPrimary),
            onPressed: () {
              final lowStockCount = _dataService.products.where((p) => p.isLowStock).length;
              if (lowStockCount > 0) {
                Helpers.showToast('$lowStockCount produits en stock faible !', isError: true);
              } else {
                Helpers.showToast('Tous les stocks sont OK');
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.admin_panel_settings, color: AppColors.onPrimary),
            onSelected: (String value) {
              if (value == 'logout') {
                _handleLogout();
              } else if (value == 'settings') {
                Helpers.showToast('Paramètres bientôt disponibles');
              } else if (value == 'export') {
                _exportData();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download, color: AppColors.textPrimary),
                    SizedBox(width: AppSpacing.sm),
                    Text('Exporter données'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: AppColors.textPrimary),
                    SizedBox(width: AppSpacing.sm),
                    Text('Paramètres'),
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
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Commandes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statistiques',
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
        return _buildDashboardTab();
      case 1:
        return _buildProductsTab();
      case 2:
        return _buildOrdersTab();
      case 3:
        return _buildStatsTab();
      default:
        return _buildDashboardTab();
    }
  }

  Widget _buildDashboardTab() {
    final stats = _dataService.getAdminStats();
    final recentOrders = _dataService.getRecentOrders(limit: 5);
    final lowStockProducts = _dataService.products.where((p) => p.isLowStock).toList();

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
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings, size: 40, color: AppColors.accent),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tableau de bord Admin', style: AppTextStyles.heading2),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Gérez votre boutique FasoElectronic',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Dernière mise à jour: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Statistiques rapides
          const Text('Vue d\'ensemble', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.md),
          
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            children: [
              _buildStatCard('Produits', '${stats['totalProducts']}', Icons.inventory, AppColors.accent),
              _buildStatCard('Commandes', '${stats['totalOrders']}', Icons.shopping_cart, AppColors.success),
              _buildStatCard('Revenus', Helpers.formatPrice(stats['totalRevenue']), Icons.monetization_on, AppColors.success),
              _buildStatCard('Stock faible', '${stats['lowStockProducts']}', Icons.warning, 
                stats['lowStockProducts'] > 0 ? AppColors.error : AppColors.success),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Alertes stock faible
          if (lowStockProducts.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.warning, color: AppColors.error),
                const SizedBox(width: AppSpacing.sm),
                Text('Alertes stock faible', style: AppTextStyles.heading3.copyWith(color: AppColors.error)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Column(
                children: lowStockProducts.take(3).map((product) => ListTile(
                  leading: const Icon(Icons.warning, color: AppColors.error),
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stock} unités'),
                  trailing: ElevatedButton(
                    onPressed: () => _showRestockDialog(product),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    child: const Text('Réapprovisionner'),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          
          // Commandes récentes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Commandes récentes', style: AppTextStyles.heading2),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                child: const Text('Voir tout', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          if (recentOrders.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 50, color: AppColors.textSecondary),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Aucune commande récente', style: AppTextStyles.bodyLarge),
                    Text('Les nouvelles commandes apparaîtront ici', 
                         style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            )
          else
            Column(
              children: recentOrders.map((order) => _buildOrderCard(order)).toList(),
            ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Actions rapides
          const Text('Actions rapides', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.md),
          
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Ajouter produit',
                  onPressed: () => _showAddProductDialog(),
                  icon: Icons.add,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CustomButton(
                  text: 'Voir rapports',
                  onPressed: () => setState(() => _selectedIndex = 3),
                  icon: Icons.analytics,
                  isOutlined: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final products = _dataService.products;
    final categories = _dataService.getCategories();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gestion des produits', style: AppTextStyles.heading2),
              ElevatedButton.icon(
                onPressed: () => _showAddProductDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Résumé par catégorie
          const Text('Par catégorie', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryProducts = _dataService.getProductsByCategory(category);
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_getIconForCategory(category), color: AppColors.accent, size: 30),
                      const SizedBox(height: AppSpacing.sm),
                      Text(category, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
                      Text('${categoryProducts.length}', style: AppTextStyles.heading3.copyWith(color: AppColors.accent)),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Liste des produits
          Text('Tous les produits (${products.length})', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductListItem(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    final orders = _dataService.orders;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Toutes les commandes', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          
          if (orders.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textSecondary),
                    const SizedBox(height: AppSpacing.lg),
                    const Text('Aucune commande', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Les commandes des clients apparaîtront ici',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _buildDetailedOrderCard(order);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final stats = _dataService.getAdminStats();
    final totalProducts = stats['totalProducts'] as int;
    final totalOrders = stats['totalOrders'] as int;
    final totalRevenue = stats['totalRevenue'] as double;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statistiques détaillées', style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          
          // Stats principales
          Row(
            children: [
              Expanded(
                child: _buildLargeStatCard(
                  'Chiffre d\'affaires',
                  Helpers.formatPrice(totalRevenue),
                  Icons.monetization_on,
                  AppColors.success,
                  'Total des ventes'
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildLargeStatCard(
                  'Commandes',
                  '$totalOrders',
                  Icons.shopping_cart,
                  AppColors.accent,
                  'Commandes passées'
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Analyse des produits
          const Text('Analyse des produits', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.md),
          
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildStatRow('Total produits', '$totalProducts'),
                _buildStatRow('Produits en stock', '${_dataService.products.where((p) => p.isInStock).length}'),
                _buildStatRow('Stock faible', '${stats['lowStockProducts']}'),
                _buildStatRow('Catégories', '${_dataService.getCategories().length}'),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Prochaines améliorations
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.upcoming, color: AppColors.accent),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Prochainement avec Firebase', style: AppTextStyles.heading3.copyWith(color: AppColors.accent)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('• Graphiques de ventes en temps réel'),
                const Text('• Analyse des tendances de vente'),
                const Text('• Rapports détaillés par période'),
                const Text('• Tableau de bord personnalisable'),
              ],
            ),
          ),
          
          // Ajouter de l'espace en bas pour éviter l'overflow
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLargeStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(value, style: AppTextStyles.heading1.copyWith(color: color)),
          Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    Color statusColor = _getStatusColor(order.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.id, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.xs),
                Text('Client: ${order.userId}', style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(Helpers.formatPrice(order.totalAmount), style: AppTextStyles.price.copyWith(fontSize: 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(order.status, style: AppTextStyles.bodySmall.copyWith(color: statusColor, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('${order.orderDate.day}/${order.orderDate.month}', style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedOrderCard(OrderModel order) {
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
              Text(order.id, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(order.status, style: TextStyle(color: _getStatusColor(order.status), fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Client: ${order.userId}'),
          Text('${order.totalItems} article${order.totalItems > 1 ? 's' : ''}'),
          Text('Date: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
          const SizedBox(height: AppSpacing.sm),
          Text(Helpers.formatPrice(order.totalAmount), style: AppTextStyles.price),
        ],
      ),
    );
  }

  Widget _buildProductListItem(ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(_getIconForCategory(product.category), color: AppColors.accent, size: 30),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(product.category, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                Text(Helpers.formatPrice(product.price), style: AppTextStyles.price.copyWith(fontSize: 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Stock: ${product.stock}', 
                   style: TextStyle(color: product.isLowStock ? AppColors.error : AppColors.success)),
              const SizedBox(height: AppSpacing.xs),
              if (product.isLowStock)
                const Icon(Icons.warning, color: AppColors.error, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Livré': return AppColors.success;
      case 'En cours': return AppColors.warning;
      case 'Confirmé': return AppColors.accent;
      case 'En attente': return AppColors.textSecondary;
      default: return AppColors.textSecondary;
    }
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

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Ajouter un produit', style: AppTextStyles.heading3),
        content: const Text('Cette fonctionnalité sera disponible avec Firebase.\n\nPour l\'instant, les produits sont gérés dans le code.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showRestockDialog(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Réapprovisionner', style: AppTextStyles.heading3),
        content: Text('Réapprovisionner "${product.name}" ?\n\nStock actuel: ${product.stock} unités'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Helpers.showToast('Demande de réapprovisionnement envoyée pour ${product.name}');
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    Helpers.showToast('Export des données en cours...');
    // Simulation d'export
    Future.delayed(const Duration(seconds: 2), () {
      Helpers.showToast('Données exportées avec succès !');
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Déconnexion Admin', style: AppTextStyles.heading3),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter du panel admin ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Helpers.showToast('Déconnexion admin réussie');
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}