import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/currency_converte_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moedas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: MainWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainWrapper extends StatefulWidget {
  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool _isLoggedIn = false;

  void _handleLogin(bool success) {
    if (success) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? CurrencyConverterScreen(onLogout: _handleLogout)
        : LoginScreen(onLogin: _handleLogin);
  }
}