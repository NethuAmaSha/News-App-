import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewmodels/news_viewmodel.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isDarkTheme),
      child: MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme;

  ThemeProvider(this._isDarkTheme);

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ChangeNotifierProvider(
          create: (_) => NewsViewModel(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News App',
            theme: themeProvider.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
            home: HomeScreen(),
          ),
        );
      },
    );
  }
}
