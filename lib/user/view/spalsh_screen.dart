import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/defaultlayout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:actual/user/view/loginscreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkToken();
  }

  //    storage.read(key:REFRESH_TOEKN_KEY);
  //     storage.read(key:ACCESS_TOEKN_KEY);

  void checkToken() async {

    final storage= ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key:REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key:ACCESS_TOKEN_KEY);

    final dio = Dio();

    try{
      final resp = await dio.post('http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization' : 'Bearer $refreshToken',
          },
        ),
      );
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => RootTab()),
            (route) => false,) ;
    }catch(e){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => LoginScreen()),
            (route) => false,);
    }



  }
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Image.asset('asset/img/misc/logo.png', width: MediaQuery.of(context).size.width /2,),

          const SizedBox(height: 16),
          CircularProgressIndicator(
            color: Colors.white,
          )
                ],
              ),
        ));
  }
}
