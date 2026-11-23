import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() => runApp(const SpotItApp());

class SpotItApp extends StatefulWidget {
  const SpotItApp({super.key});

  @override
  State<SpotItApp> createState() => _SpotItAppState();
}

class _SpotItAppState extends State<SpotItApp> {
  final AppState _state = AppState();

  @override
  void initState() {
    super.initState();
    _state.load(); 
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'SpotIt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const WelcomeScreen(),
      ),
    );
  }
}
