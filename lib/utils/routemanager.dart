import 'package:songer/utils/navigation_service.dart';
import 'package:songer/utils/serviceLocator.dart';

class RouteManager {
  //locators

  final NavigationService navigationService = locator.get<NavigationService>();
  Future<void> launchMusicPlayer() async {
    return;
  }
}
