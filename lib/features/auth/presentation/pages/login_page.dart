import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/svg/background.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: YouthFieldColor.blue700),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xCC00255E), Color(0x6687B6FF)],
              ),
            ),
          ),
          // 뒤로가기 버튼
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: YouthFieldColor.white,
                size: 36,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '로그인',
                      style: YouthFieldTextStyle.title3.copyWith(
                        color: YouthFieldColor.white,
                      ),
                    ),
                    const SizedBox(height: 48),
                    AuthTextField(
                      controller: _emailController,
                      hint: '이메일을 입력해주세요.',
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _passwordController,
                      hint: '비밀번호를 입력해주세요.',
                      obscureText: !_passwordVisible,
                      suffix: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: YouthFieldColor.black500,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible = !_passwordVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AuthButton(
                      label: '로그인',
                      backgroundColor: YouthFieldColor.gold,
                      labelColor: YouthFieldColor.white,
                      onTap: () => Navigator.pop(context, true),
                    ),
                    const SizedBox(height: 10),
                    AuthButton(
                      label: '구글 로그인',
                      backgroundColor: YouthFieldColor.white,
                      labelColor: YouthFieldColor.black800,
                      prefix: SvgPicture.asset(
                        'assets/svg/google_logo.svg',
                        width: 24,
                        height: 24,
                        placeholderBuilder: (_) => Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA4335),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아직 계정이 없나요?  ',
                          style: YouthFieldTextStyle.placeholder.copyWith(
                            color: YouthFieldColor.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupPage(),
                            ),
                          ),
                          child: Text(
                            '회원가입',
                            style: YouthFieldTextStyle.placeholder.copyWith(
                              color: YouthFieldColor.gold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
