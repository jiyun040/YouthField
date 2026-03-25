import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class DiarySleepTimePicker extends StatelessWidget {
  final String? sleepStart;
  final String? sleepEnd;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  const DiarySleepTimePicker({
    super.key,
    required this.sleepStart,
    required this.sleepEnd,
    required this.onPickStart,
    required this.onPickEnd,
  });

  Widget _timeBox(String? time, String placeholder, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time ?? placeholder,
          style: YouthFieldTextStyle.placeholder.copyWith(
            color: time != null
                ? YouthFieldColor.black800
                : YouthFieldColor.black300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _timeBox(sleepStart, '취침시간', onPickStart),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '~',
            style: YouthFieldTextStyle.textCount.copyWith(
              color: YouthFieldColor.black500,
            ),
          ),
        ),
        _timeBox(sleepEnd, '기상시간', onPickEnd),
      ],
    );
  }
}

class DiaryReadOnlySleepTime extends StatelessWidget {
  final String? sleepStart;
  final String? sleepEnd;

  const DiaryReadOnlySleepTime({super.key, this.sleepStart, this.sleepEnd});

  @override
  Widget build(BuildContext context) {
    final text = (sleepStart != null && sleepEnd != null)
        ? '$sleepStart ~ $sleepEnd'
        : '-';
    return Text(
      text,
      style: YouthFieldTextStyle.textCount.copyWith(
        color: YouthFieldColor.black800,
      ),
    );
  }
}
