import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';
import 'package:youthfield/features/diary/domain/entities/diary_entry.dart';

const double kDiaryRowHeight = 100.0;
const double kDiaryRowGap = 10.0;

class DiaryListRow extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  const DiaryListRow({super.key, required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: kDiaryRowHeight,
        margin: const EdgeInsets.only(bottom: kDiaryRowGap),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: YouthFieldColor.blue50,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 160,
              child: Text(
                entry.formattedDate,
                style: YouthFieldTextStyle.textCount.copyWith(
                  color: YouthFieldColor.black800,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                entry.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: YouthFieldTextStyle.textCount.copyWith(
                  color: YouthFieldColor.black500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
