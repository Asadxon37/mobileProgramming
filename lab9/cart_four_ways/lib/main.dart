import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bloc/cart_page_bloc.dart';
import 'cubit/cart_page_cubit.dart';
import 'models/cart.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'setstate/cart_page_setstate.dart';

/// Logs every Cubit change and every Bloc transition (Bloc also shows the event).
class LoggingObserver extends BlocObserver {
  String _d(Object? s) => s is CartState
      ? '[${s.itemCount} items, total ${s.total.toStringAsFixed(2)}, ${s.status.name}]'
      : '$s';

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} change: ${_d(change.currentState)} -> ${_d(change.nextState)}');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> t) {
    super.onTransition(bloc, t);
    debugPrint('${bloc.runtimeType} transition: ${_d(t.currentState)} '
        '--${t.event.runtimeType}--> ${_d(t.nextState)}');
  }
}

void main() {
  Bloc.observer = LoggingObserver();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'One Cart, Four Ways',
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        home: const HomePage(),
      );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _button(BuildContext context, String label, Widget page) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: FilledButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page)),
            child: Text(label)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('One Cart, Four Ways')),
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _button(context, 'setState', const SetStateCartPage()),
            _button(context, 'Riverpod', const RiverpodCartPage()),
            _button(context, 'Cubit', const CubitCartPage()),
            _button(context, 'Bloc', const BlocCartPage()),
          ]),
        ),
      );
}
