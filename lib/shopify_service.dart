import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShopifyService {
  final String shopUrl = dotenv.env['SHOPIFY_STORE_URL'] ?? '';
  final String accessToken = dotenv.env['SHOPIFY_API_KEY'] ?? '';
  final String apiVersion = dotenv.env['SHOPIFY_API_VERSION'] ?? '';

  Future<List<dynamic>> getAllProducts() async {
    List<dynamic> allProducts = [];
    String? nextPageUrl;

    do {
      final String url = nextPageUrl ?? "$shopUrl/admin/api/$apiVersion/products.json?limit=50";


      final response = await http.get(Uri.parse(url), headers: {
        "X-Shopify-Access-Token": accessToken,
        "Content-Type": "application/json"
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        allProducts.addAll(data["products"]);

        // Vérifier s'il y a une page suivante
        nextPageUrl = _extractNextPageUrl(response.headers['link']);
      } else {
        throw Exception("❌ Erreur lors de la récupération des produits: ${response.statusCode}");
      }
    } while (nextPageUrl != null);

    return allProducts;
  }

  /// 📌 Fonction pour extraire l'URL de la page suivante depuis l'en-tête "Link"
  String? _extractNextPageUrl(String? linkHeader) {
    if (linkHeader == null) return null;
    
    final match = RegExp(r'<(.*?)>; rel="next"').firstMatch(linkHeader);
    return match?.group(1);
  }
  Future<void> updateStock(String inventoryItemId, int newQuantity) async {
  final String url = "$shopUrl/admin/api/$apiVersion/inventory_levels/set.json";


  final response = await http.post(
    Uri.parse(url),
    headers: {
      "X-Shopify-Access-Token": accessToken,
      "Content-Type": "application/json"
    },
    body: json.encode({
      "location_id": "",  // Remplace par l'ID de ton entrepôt Shopify
      "inventory_item_id": inventoryItemId,
      "available": newQuantity
    }),
  );

  if (response.statusCode == 200) {
  } else {
  }
}

  updateGeneralStock(String inventoryItemId, int change) {}
}