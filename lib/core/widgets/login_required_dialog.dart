import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class LoginRequiredDialog extends StatelessWidget {
  final String? subtitle;
  final VoidCallback onLogin;

  const LoginRequiredDialog({super.key, this.subtitle, required this.onLogin});

  static Future<void> show({
    required BuildContext context,
    String? subtitle,
    required VoidCallback onLogin,
  }) {
    return showDialog(
      context: context,
      builder: (_) => LoginRequiredDialog(subtitle: subtitle, onLogin: onLogin),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: YouthFieldColor.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('로그인이 필요합니다', style: YouthFieldTextStyle.body4,),
      content: Text(
        subtitle ?? '이 기능은 로그인 후 이용할 수 있습니다.',
        style: YouthFieldTextStyle.smallButton.copyWith(
          color: YouthFieldColor.black500,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '취소',
            style: YouthFieldTextStyle.smallButton.copyWith(
              color: YouthFieldColor.black500,
            ),
          ),
        ),
        const SizedBox(width: 20),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onLogin();
          },
          child: Text(
            '로그인',
            style: YouthFieldTextStyle.smallButton.copyWith(
              color: YouthFieldColor.blue700,
            ),
          ),
        ),
      ],
    );
  }
}
