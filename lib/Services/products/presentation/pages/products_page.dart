import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_bloc.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_event.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_state.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flx_market/Services/wishlist/presentation/widgets/wishlist_button.dart';
import 'package:flx_market/Services/products/presentation/pages/product_details_page.dart';
import 'package:flx_market/Services/products/presentation/widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use stored bloc if possible, or context.read.
    // Ensure bloc is provided by parent (MainPage -> MultiBlocProvider in main).
    // Initial load is called in main.dart provider creation usually, or we call it here.
    // If we want to refresh on entering page, we might check state.
    // But main.dart provider handles lifecycle.
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<ProductsBloc>().add(SearchProductsEvent(value));
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            Expanded(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, productsState) {

                  if (productsState is ProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productsState is ProductsError) {
                    return Center(child: Text(productsState.message));
                  } else if (productsState is ProductsLoaded) {
                    if (productsState.products.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }
                    
                    return BlocBuilder<WishlistBloc, WishlistState>(
                      builder: (context, wishlistState) {
                        final wishlistProductIds = (wishlistState is WishlistLoaded) 
                            ? wishlistState.products.map((p) => p.id).toSet() 
                            : <String>{};

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: productsState.products.length,
                          itemBuilder: (context, index) {
                            final product = productsState.products[index];
                            final isFavorite = wishlistProductIds.contains(product.id);

                            return ProductCard(
                              product: product,
                              isFavorite: isFavorite,
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
    );
  }
}
