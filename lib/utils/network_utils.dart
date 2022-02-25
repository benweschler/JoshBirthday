import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> isConnectedToInternet() {
  InternetConnectionChecker().checkInterval = const Duration(milliseconds: 300);
  return InternetConnectionChecker().hasConnection;
}

class AccessVersion {
  static const String version = "2.4";
}