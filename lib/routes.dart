import 'package:med_app/screens/home_screen.dart';
import 'package:med_app/screens/login_screen.dart';

var appRoutes = {
  '/': (ctx) => const HomeScreen(),
  '/login': (ctx) => LoginScreen(),
};
