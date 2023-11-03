import 'package:delivery_app/common/component/custom_text_form_filed.dart';
import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/user/model/user_model.dart';
import 'package:delivery_app/user/provider/user_me_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userMeProvider);
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag, // 드래그 시 사라짐
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(height: 16.0),
                const _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  onPressed: state is UserModelLoading
                      ? null
                      : () async {
                          ref
                              .read(userMeProvider.notifier)
                              .login(username: username, password: password);

                          // // Id:Pass
                          // // final rawString = 'test@codefactory.ai:testtest';
                          // final rawString = '$username:$password';

                          // // string -> base64 인코딩 코드
                          // Codec<String, String> stringToBase64 = utf8.fuse(base64);
                          // String token = stringToBase64.encode(rawString);

                          // final resp = await dio.post(
                          //   'http://$ip/auth/login',
                          //   options:
                          //       Options(headers: {'authorization': 'Basic $token'}),
                          // );

                          // final accessToken = resp.data['accessToken'];
                          // final refreshToken = resp.data['refreshToken'];

                          // final storage = ref.read(secureStorageProvider);
                          // await storage.write(
                          //     key: REFRESH_TOKEN_KEY, value: refreshToken);
                          // await storage.write(
                          //     key: ACCESS_TOKEN_KEY, value: accessToken);

                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const RootTab()));
                        },
                  child: Text('로그인'),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  onPressed: () async {},
                  child: const Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다 !',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길:)',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: BODY_TEXT_COLOR),
    );
  }
}
