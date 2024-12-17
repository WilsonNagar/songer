import 'package:flutter/material.dart';

class NavigationService {
  NavigationService();

  @override
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _childNavigator = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get childNavigatorKey => _childNavigator;

  void setNavigatorKey(GlobalKey<NavigatorState> newNavigatorKey) {
    _navigationKey = newNavigatorKey;
    _previousNavigator = newNavigatorKey;
  }

  @override
  RouteObserver<ModalRoute<dynamic>> get routeObserver => _routeObserver;
  final RouteObserver<ModalRoute<dynamic>> _routeObserver =
      RouteObserver<ModalRoute<dynamic>>();

  String? oldToastMessage = "";

  @override
  String getCurrentRouteName() {
    String? routeName;
    navigationKey.currentState?.popUntil((Route<dynamic> route) {
      routeName = route.settings.name;
      return true;
    });

    return routeName ?? "";
  }

  @override
  bool isFirstRoute() {
    bool isFirst = false;
    navigationKey.currentState?.popUntil((Route<dynamic> route) {
      isFirst = route.isFirst;
      return true;
    });

    return isFirst;
  }

  @override
  Future<T?> launchBottomSheet<T>({
    required Widget widget,
    bool enableDrag = true,
    bool barrierDismissible = true,
    bool isScrollControlled = false,
    bool deviceBackDismissible = true,
    double? textScaleFactor,
    RouteSettings? routeSettings,
    ShapeBorder? shape,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      barrierColor: barrierColor,
      context: _getNavigationKey().currentContext!,
      builder: (BuildContext context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaleFactor: textScaleFactor ?? 0.95),
        child: PopScope(canPop: deviceBackDismissible, child: widget),
      ),
      routeSettings: routeSettings,
    );
  }

  @override
  Future<T?> launchDialog<T>(
      {required Widget widget,
      bool barrierDismissible = true,
      RouteSettings? routeSettings}) {
    return showDialog<T>(
      context: _getNavigationKey().currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => widget,
      useSafeArea: false,
      routeSettings: routeSettings,
    );
  }

  @override
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _getNavigationKey(routeName: routeName)
        .currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> navigateToAndReplace(String routeName, {dynamic arguments}) {
    return Navigator.of(_getNavigationKey(routeName: routeName).currentContext!)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> popAndReplace(String routeName, {dynamic arguments}) {
    return Navigator.of(_getNavigationKey(routeName: routeName).currentContext!)
        .popAndPushNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> navigateToRoute(Route<dynamic> route) {
    return _getNavigationKey(route: route).currentState!.push(route);
  }

  late GlobalKey<NavigatorState> _previousNavigator = _navigationKey;

  bool isChildWindowDialog = false;

  GlobalKey<NavigatorState> _getNavigationKey({
    Route<dynamic>? route,
    String? routeName,
  }) {
    //Currently it will true if launching dialog or poping
    if (route == null && routeName == null) return _previousNavigator;
    GlobalKey<NavigatorState> navigator;
    if (isChildWindowDialog) {
      navigator = _childNavigator;
    } else {
      navigator = _navigationKey;
    }
    _previousNavigator = navigator;
    return navigator;
  }

  @override
  void pop<T extends Object>([T? result]) {
    final NavigatorState? navigator = _getNavigationKey().currentState;
    if (navigator != null) {
      if (navigator.canPop()) {
        return navigator.pop(result);
      }
    }
  }

  @override
  void popToRoot() {
    return _getNavigationKey().currentState?.popUntil((Route<dynamic> route) {
      return route.isFirst;
    });
  }

  @override
  void popUntil(String routeName) {
    return _getNavigationKey(routeName: routeName)
        .currentState
        ?.popUntil((Route<dynamic> route) {
      return route.isFirst || route.settings.name == routeName;
    });
  }
}
