
import 'dart:convert';
import 'dart:io';
import 'package:actual/common/const/colors.dart';
import 'package:actual/common/const/data.dart';
import 'package:actual/common/layout/defaultlayout.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/component/custom_text_form.dart';
import '../../common/view/root_tab.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username ='';
  String password = '';


  /*
  test@codefactory.ai : testtest
   */
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    final emulatorIp='10.0.2.2:3000';
    final simulatorIp='127.0.0.1:3000';
  //  final storage = FlutterSecureStorage();
    String os = Platform.operatingSystem;
    String ip = Platform.isAndroid ? emulatorIp : simulatorIp;


    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Title(),
              SizedBox(height: 10),
              _SubTitle(),
              Image.asset('asset/img/misc/logo.png',
              width: MediaQuery.of(context).size.width /3 * 2,
              height: 200,
              ),
              Custom_Text_Form(
                hinText: '이메일을 입력해주세요',
                onChanged: (String value){
                  username = value;
                },
              ),
              SizedBox(height: 20),
              Custom_Text_Form(
                hinText: '패스워드를 입력해주세요',
                obsecureText: true,
                onChanged: (String value){
                  password = value;
                },
              ),
              ElevatedButton(onPressed: () async{
                // 에뮬레이터 ip
                final rawString = '$username:$password';
                print(rawString);
                Codec<String, String> stringToBase64 = utf8.fuse(base64);

                String token = stringToBase64.encode(rawString);

                // simulator ip :127.0.0.1:3000
                final resp = await dio.post('http://$ip/auth/login',
                options: Options(
                  headers: {
                    'authorization' : 'Basic $token',
                  },
                ),
                );
               final refreshToken =resp.data['refreshToken'];
               final accessToken = resp.data['accessToken'];

               final storage= ref.read(secureStorageProvider);
               // 클릭했을때 함수 안이니까 read 로 해야한다.
               await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
               await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RootTab(),
                  ),
                );
                print(resp.data);
              },
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  )
                  ,child: Text('로그인')
              ),
              TextButton(onPressed: () async{
                // 리프래시 토큰값
              },
                  style: TextButton.styleFrom(
                    primary: PRIMARY_COLOR
                  ),
                  child: Text('회원가입')
              )
            ],
                ),
          ),
        ),
      ),);
  }
}


class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('환영합니다', style: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 34,
      color: Colors.black
    ),);
  }
}
class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('이메일과 비밀번호를 입력해서 로그인해주세요 \n오늘도 성공적인 주문이되길 :) ', style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: BODY_TEXT_COLOR
    ),);
  }
}