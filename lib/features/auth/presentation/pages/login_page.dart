import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  final _googleSignIn = GoogleSignIn(
    // TODO: Google Cloud Console에서 발급받은 Client ID로 교체하세요.
    clientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final account = await _googleSignIn.signIn();
      if (account != null && mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인에 실패하였습니다. 다시 시도해주세요.'),
            backgroundColor: YouthFieldColor.blue700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                Icons.chevron_left,
                color: YouthFieldColor.white,
                size: 36,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Youth Field',
                      style: YouthFieldTextStyle.title3.copyWith(
                        color: YouthFieldColor.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '유소년 축구 선수들의 성장을 함께합니다',
                      style: YouthFieldTextStyle.placeholder.copyWith(
                        color: YouthFieldColor.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                    _GoogleLoginButton(
                      isLoading: _isLoading,
                      onTap: _signInWithGoogle,
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

class _GoogleLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _GoogleLoginButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: YouthFieldColor.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: YouthFieldColor.blue700,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/google_logo.svg',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Google로 로그인',
                    style: YouthFieldTextStyle.body4.copyWith(
                      color: YouthFieldColor.black800,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
