import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _codeSent = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  String get _timerText {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _sendCode() {
    setState(() {
      _codeSent = true;
      _remainingSeconds = 300;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Symbols.arrow_back_ios,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '회원가입',
                        style: YouthFieldTextStyle.title3.copyWith(
                          color: YouthFieldColor.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AuthTextField(
                      controller: _emailController,
                      hint: '이메일을 입력해주세요.',
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: _sendCode,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: YouthFieldColor.blue50,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '인증번호 발송',
                          style: YouthFieldTextStyle.placeholder.copyWith(
                            color: YouthFieldColor.black800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    AuthTextField(
                      controller: _codeController,
                      hint: '인증번호를 입력해주세요.',
                    ),
                    if (_codeSent) ...[
                      const SizedBox(height: 6),
                      Text(
                        _timerText,
                        style: YouthFieldTextStyle.placeholder.copyWith(
                          color: YouthFieldColor.gold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _passwordController,
                      hint: '비밀번호를 입력해주세요.',
                      obscureText: !_passwordVisible,
                      suffix: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Symbols.visibility
                              : Symbols.visibility_off,
                          color: YouthFieldColor.black500,
                        ),
                        onPressed: () => setState(
                          () => _passwordVisible = !_passwordVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AuthTextField(
                      controller: _confirmPasswordController,
                      hint: '비밀번호를 한번 더 입력해주세요.',
                      obscureText: !_confirmPasswordVisible,
                      suffix: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Symbols.visibility
                              : Symbols.visibility_off,
                          color: YouthFieldColor.black500,
                        ),
                        onPressed: () => setState(
                          () => _confirmPasswordVisible =
                              !_confirmPasswordVisible,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    AuthButton(
                      label: '회원가입',
                      backgroundColor: YouthFieldColor.gold,
                      labelColor: YouthFieldColor.white,
                      onTap: () {},
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
