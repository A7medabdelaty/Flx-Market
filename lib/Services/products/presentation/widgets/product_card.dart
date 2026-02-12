import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Services/home/domain/entities/home_entities.dart';
import 'package:flx_market/Services/products/presentation/pages/product_details_page.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flx_market/Services/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flx_market/Services/wishlist/presentation/widgets/wishlist_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final bool showWishlistButton;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    this.showWishlistButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showWishlistButton)
              Positioned(
                top: 8,
                right: 8,
                child: WishlistButton(
                  isFavorite: isFavorite,
                  onTap: () {
                    context.read<WishlistBloc>().add(ToggleWishlistEvent(product));
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
