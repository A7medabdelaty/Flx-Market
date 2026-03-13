import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Core/constants/assets_paths.dart';
import 'package:flx_market/Core/constants/nav_colors.dart';
import 'package:flx_market/Services/auth/domain/entities/user_role.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_bloc.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_state.dart';
import 'package:flx_market/Services/home/Presentation/Views/home_view.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_bloc.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_event.dart';
import 'package:flx_market/Services/products/presentation/pages/add_product_page.dart';
import 'package:flx_market/Services/products/presentation/pages/products_page.dart';
import 'package:flx_market/Services/profile/presentation/pages/profile_view.dart';
import 'package:flx_market/Services/wishlist/presentation/pages/wishlist_page.dart';

const TextStyle bntText = TextStyle(
  color: NavColors.navUnselectColor,
  fontWeight: FontWeight.w500,
);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const ProductsPage(),
    const WishlistPage(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isVendor = false;
        if (state is AuthAuthenticated) {
          isVendor = state.user.role == UserRole.vendor;
        }

        return Scaffold(
          backgroundColor: NavColors.navBgColor,
          body: Stack(
            children: [
              IndexedStack(index: _currentIndex, children: _pages),

              Align(
                alignment: Alignment.bottomCenter,
                child: _buildCustomNavBar(isVendor, context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomNavBar(bool isVendor, BuildContext context) {
    final items = [
      _NavItem(0, AssetsPaths.homeIcon, AssetsPaths.homeFilledIcon, "Home"),
      _NavItem(
        1,
        AssetsPaths.searchIcon,
        AssetsPaths.searchFilledIcon,
        "Product",
      ),
      if (isVendor)
        _NavItem(2, AssetsPaths.addIcon, AssetsPaths.addIcon, "Add"),
      _NavItem(
        isVendor ? 3 : 2,
        AssetsPaths.heartIcon,
        AssetsPaths.heartFilledIcon,
        "favorites",
      ),
      _NavItem(
        isVendor ? 4 : 3,
        AssetsPaths.profileIcon,
        AssetsPaths.profileFilledIcon,
        "Profile",
      ),
    ];

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: NavColors.navBarColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          int index = item.index;

          return GestureDetector(
            onTap: () async {
              if (isVendor && index == 2) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddProductPage(),
                  ),
                );

                if (result == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                return;
              }

              int pageIndex = index;
              if (isVendor && index > 2) pageIndex = index - 1;

              setState(() {
                _currentIndex = pageIndex;
              });

              if (pageIndex == 1) {
                context.read<ProductsBloc>().add(LoadProductsEvent());
              }
            },
            behavior: HitTestBehavior.opaque,
            child: _buildIconBtn(
              item.index,
              item.icon,
              item.filledIcon,
              item.label,
              isVendor,
              context,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconBtn(
    int index,
    String icon,
    String filledIcon,
    String label,
    bool isVendor,
    BuildContext context,
  ) {
    int activeUiIndex;
    if (isVendor) {
      if (_currentIndex >= 2)
        activeUiIndex = _currentIndex + 1;
      else
        activeUiIndex = _currentIndex;
    } else {
      activeUiIndex = _currentIndex;
    }

    bool isActive = activeUiIndex == index;

    final color = isActive ? Colors.black : NavColors.navUnselectColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? filledIcon : icon,
            width: 24,
            height: 24,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final int index;
  final String icon;
  final String filledIcon;
  final String label;

  _NavItem(this.index, this.icon, this.filledIcon, this.label);
}
