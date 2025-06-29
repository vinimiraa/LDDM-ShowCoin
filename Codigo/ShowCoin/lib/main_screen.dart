import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'screens/qrcode_screen.dart';
import 'screens/home_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/utils.dart';
import 'screens/currency_converter_screen.dart';

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
  // int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    try {
      _screens = _buildScreens();
    } catch (e, s) {
      debugPrint('Erro ao construir telas principais: $e\n$s');
      _screens = [
        Scaffold(
          body: Center(
            child: Text('Erro ao carregar telas. Reinicie o app.'),
          ),
        ),
      ];
    }
  }

  List<Widget> _buildScreens() {
    try {
      return [
        HomeScreen(controller: _controller),
        TransactionScreen(),
        QRCodeScreen(controller: _controller),
        const CurrencyConverterScreen(),
        SettingsScreen(),
      ];
    } catch (e, s) {
      debugPrint('Erro ao instanciar telas: $e\n$s');
      return [
        Scaffold(
          body: Center(
            child: Text('Erro ao carregar telas. Reinicie o app.'),
          ),
        ),
      ];
    }
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
        icon: const Icon(Icons.currency_exchange),
        title: "Conversor",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: "Configurações",
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
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      backgroundColor: _backgroundNavBar,
      isVisible: true,
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
