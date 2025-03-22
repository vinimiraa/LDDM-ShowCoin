import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'screens/qrcode_screen.dart';
import 'screens/home_screen.dart';
import 'screens/statement_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/utils.dart';
import 'screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Controlador para gerenciar a navegação
  final PersistentTabController _controller = PersistentTabController( initialIndex: 0 );

  final Color _backgroundNavBar = AppColors.backgroundNavBar;
  final Color _activeColorButton = AppColors.activeNavBarButton;
  final Color _inactiveColorButton = AppColors.inativeNavBarButton;

  // Lista de telas que serão exibidas em cada aba
  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      StatementScreen(),
      QRCodeScreen(),
      ProfileScreen()
    ];
  }

  // Configuração dos itens da Navbar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
        // ? Configuração de rota, talvez seja útil futuramente, exemplo:
        // routeAndNavigatorSettings: RouteAndNavigatorSettings(
        //   initialRoute: "/",
        //   routes: {
        //   "/first": (final context) => const MainScreen2(),
        //   "/second": (final context) => const MainScreen3(),
        //   },
        // ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.graphic_eq),
        title: "Detalhes",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code),
        title: "QRCode",
        activeColorPrimary: _activeColorButton,
        inactiveColorPrimary: _inactiveColorButton,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
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
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true, // Padrão é verdadeiro.
      resizeToAvoidBottomInset:
          true, // Isso precisa ser verdadeiro se você deseja mover a tela para cima em uma tela não rolável quando o teclado aparece. O padrão é verdadeiro.
      stateManagement: true, // Padrão é true
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      backgroundColor: _backgroundNavBar,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Propriedades de animação dos itens da Navbar
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Transição de tela ao mudar de aba
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style9, // Escolha o estilo da Navbar
    );
  }
}
