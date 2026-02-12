import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Services/home/domain/entities/home_entities.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flx_market/Services/wishlist/presentation/widgets/wishlist_button.dart';
import 'package:flx_market/Services/payment/presentation/pages/payment_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            product.location,
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                          const Spacer(),
                           Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: product.isFeatured ? Colors.amber.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: product.isFeatured 
                              ? const Text(
                                  'Featured',
                                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                                )
                              : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Description',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description.isEmpty 
                            ? 'No description available for this product.' 
                            : product.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, state) {
                      bool isFavorite = false;
                      if (state is WishlistLoaded) {
                        isFavorite = state.products.any((p) => p.id == product.id);
                      }
                      
                      return Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: WishlistButton(
                            isFavorite: isFavorite,
                            onTap: () {
                              context.read<WishlistBloc>().add(ToggleWishlistEvent(product));
                            },
                            // Override size for this page if needed, but standard logic inside widget should be fine
                            // Wait, WishlistButton has padding/shadow.
                            // The container here adds border.
                            // Let's rely on standard WishlistButton behavior?
                            // Standard WishlistButton is white circle with shadow.
                            // This design puts it next to Buy Now.
                            // Let's just use the WishlistButton directly without extra container if it looks good.
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(product: product),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
}
