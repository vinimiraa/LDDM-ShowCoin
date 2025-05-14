import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'screens/qrcode_screen.dart';
import 'screens/home_screen.dart';
import 'screens/statement_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Controlador para gerenciar a navegação
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  final Color _backgroundNavBar = AppColors.backgroundNavBar;
  final Color _activeColorButton = AppColors.activeNavBarButton;
  final Color _inactiveColorButton = AppColors.inativeNavBarButton;

  late List<Widget> _screens;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = _buildScreens();
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      StatementScreen(),
      QRCodeScreen(
        controller: _controller,
      ), // Passa o controlador para o QRCodeScreen
      SettingsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.graphic_eq),
        title: "Detalhes",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.qr_code),
        title: "QRCode",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Perfil",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      backgroundColor: _backgroundNavBar,
      isVisible: true,
      onItemSelected: (int index) {
        if (index == 0 && _previousIndex != 0) {
          setState(() {
            _screens[0] = HomeScreen(
              onFocus: () {
                print("Recarregando HomeScreen após voltar para a aba");
              },
            );
          });
        }
        _previousIndex = index;
      },
      onWillPop: (context) async {
        if (_controller.index != 0) {
          _controller.jumpToTab(0); // Volta para a aba inicial
          return false;
        }
        return true;
      },
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style9,
    );
  }
}
