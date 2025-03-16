import 'package:flutter/material.dart';
import 'shopify_service.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ShopifyService shopifyService = ShopifyService();
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true; // 📌 Pour gérer l'affichage du loader initial

  @override
  void initState() {
    super.initState();
    loadProducts();
    searchController.addListener(() {
      filterProducts();
    });
  }

  /// 📌 Récupérer la liste des produits et afficher un loader pendant le chargement
  Future<void> loadProducts() async {
    setState(() {
      isLoading = true; // Active le loader
    });

    try {
      final productList = await shopifyService.getAllProducts();
      setState(() {
        products = productList;
        filteredProducts = productList;
        isLoading = false; // Désactive le loader après le chargement
      });
    } catch (e) {
      print("❌ Erreur: $e");
      setState(() {
        isLoading = false; // Désactive le loader même en cas d'erreur
      });
    }
  }

  /// 🔍 Filtrer les produits en fonction de la recherche
  void filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        String title = product["title"].toLowerCase();
        return title.contains(query);
      }).toList();
    });
  }

  /// 📌 Mettre à jour le stock en local et envoyer la mise à jour à Shopify
  Future<void> updateStock(String inventoryItemId, int index, int change) async {
    setState(() {
      // 📌 Modifier le stock en local pour éviter de recharger toute la liste
      filteredProducts[index]["variants"][0]["inventory_quantity"] += change;
    });

    // 📌 Mettre à jour Shopify sans recharger la liste complète
    await shopifyService.updateGeneralStock(inventoryItemId, change);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Barre de recherche
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Rechercher un produit...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),

        // 📦 Gestion de l'affichage des produits
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // ⏳ Loader pendant le chargement
              : filteredProducts.isEmpty
                  ? const Center(child: Text("Aucun produit trouvé")) // 🛑 Message si aucun produit
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        int stock = product["variants"][0]["inventory_quantity"] ?? 0;
                        String inventoryItemId = product["variants"][0]["inventory_item_id"].toString();
                        String imageUrl = product["image"] != null ? product["image"]["src"] : ""; // 📌 Récupère l'image

                        return Card(
                          child: ListTile(
                            leading: imageUrl.isNotEmpty
                                ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.image_not_supported, size: 50), // 📌 Icône si pas d’image
                            title: Text(product["title"]),
                            subtitle: Text("Stock : $stock unités"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 🔽 Bouton pour diminuer le stock
                                IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.red),
                                  onPressed: stock > 0 ? () => updateStock(inventoryItemId, index, -1) : null,
                                ),
                                // 🔼 Bouton pour augmenter le stock
                                IconButton(
                                  icon: const Icon(Icons.add, color: Colors.green),
                                  onPressed: () => updateStock(inventoryItemId, index, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}