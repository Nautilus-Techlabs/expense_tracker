import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors_extension.dart';
import '../models/circle_data.dart';

class MemberAvatarStack extends StatelessWidget {
  final List<CircleMember> members;

  const MemberAvatarStack({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final visible = members.take(2).toList();
    final overflow = members.length - visible.length;
    final avatarSize = 32.w;
    const overlap = 10.0;

    return SizedBox(
      height: avatarSize,
      width:
          avatarSize * visible.length +
          (overflow > 0 ? avatarSize : 0) -
          (visible.length - 1) * overlap,
      child: Stack(
        children: [
          ...visible.asMap().entries.map((e) {
            return Positioned(
              left: e.key * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: e.value.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardDark
                        : Colors.white,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  e.value.initials,
                  style: context.appTexts.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }),
          if (overflow > 0)
            Positioned(
              left: visible.length * (avatarSize - overlap),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.cardDark
                        : Colors.white,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$overflow',
                  style: context.appTexts.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
