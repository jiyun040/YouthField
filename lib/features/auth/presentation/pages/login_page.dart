import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/auth/presentation/pages/profile_setup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});
        await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
                Symbols.chevron_left,
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
                        color: YouthFieldColor.white.withValues(alpha: 0.8),
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
