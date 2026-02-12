import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flx_market/Core/constants/assets_paths.dart';
import 'package:flx_market/Core/constants/nav_colors.dart';
import 'package:flx_market/Core/widgets/button_notch.dart';
import 'package:flx_market/Services/auth/domain/entities/user_role.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_bloc.dart';
import 'package:flx_market/Services/auth/presentation/bloc/auth_state.dart';
import 'package:flx_market/Services/home/Presentation/Views/home_view.dart';
import 'package:flx_market/Services/products/presentation/pages/add_product_page.dart';
import 'package:flx_market/Services/products/presentation/pages/products_page.dart';
import 'package:flx_market/Services/profile/presentation/pages/profile_view.dart';
import 'package:flx_market/Services/wishlist/presentation/pages/wishlist_page.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_bloc.dart';
import 'package:flx_market/Services/products/presentation/bloc/products_event.dart';

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
      _NavItem(0, AssetsPaths.homeIcon, "Home"),
      _NavItem(1, AssetsPaths.searchIcon, "Product"),
      if (isVendor) _NavItem(2, AssetsPaths.addIcon, "Add"),
      _NavItem(isVendor ? 3 : 2, AssetsPaths.heartIcon, "Likes"),
      _NavItem(isVendor ? 4 : 3, AssetsPaths.profileIcon, "Profile"),
    ];

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: NavColors.navBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
    double height = isActive ? 60.0 : 0.0;
    double width = isActive ? 50.0 : 0.0;

    return SizedBox(
      width: 75,
      height: 70,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              height: height,
              width: width,
              duration: const Duration(milliseconds: 600),
              child: isActive
                  ? CustomPaint(painter: ButtonNotch())
                  : const SizedBox(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              icon,
              color: isActive ? NavColors.navSelectColor : NavColors.navUnselectColor,
              scale: 2,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                label,
                style: isActive
                    ? bntText.copyWith(color: NavColors.navSelectColor)
                    : bntText.copyWith(color: NavColors.navUnselectColor),
              ),
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
  final String label;

  _NavItem(this.index, this.icon, this.label);
}
