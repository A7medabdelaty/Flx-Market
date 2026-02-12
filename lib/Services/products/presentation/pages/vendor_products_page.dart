import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Services/products/data/repositories/products_repository_impl.dart';
import 'package:flx_market/Services/products/presentation/bloc/vendor_products_bloc.dart';
import 'package:flx_market/Services/products/presentation/widgets/product_card.dart';

class VendorProductsPage extends StatelessWidget {
  final String ownerId;
  const VendorProductsPage({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VendorProductsBloc(
        context.read<ProductsRepositoryImpl>(),
      )..add(LoadVendorProductsEvent(ownerId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Products'),
        ),
        body: BlocBuilder<VendorProductsBloc, VendorProductsState>(
          builder: (context, state) {
            if (state is VendorProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VendorProductsError) {
              return Center(child: Text(state.message));
            } else if (state is VendorProductsLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(child: Text('You have not published any products yet.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: products[index],
                    isFavorite: false,
                    showWishlistButton: false,
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
