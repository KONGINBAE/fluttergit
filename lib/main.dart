import 'package:actual/user/view/loginscreen.dart';
import 'package:actual/user/view/spalsh_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/component/custom_text_form.dart';

void main() {
  runApp(
    ProviderScope(child: _APP(),)
  );
}

class _APP extends StatelessWidget {
  const _APP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),

      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}

