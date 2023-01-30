import 'package:flutter/material.dart';

import '../../utils/screen_util/screen_util.dart';
import '../../utils/theme/app_text_style.dart';

class CustomPlainButton extends StatelessWidget {
  const CustomPlainButton({
    Key? key,
    required String title,
    required Function onTap,
  })  : _title = title,
        _onTap = onTap,
        super(key: key);

  final String _title;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(),
      child: Container(
        width: ScreenUtil.screenWidth / 2.8,
        height: 50.toHeight,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          _title,
          overflow: TextOverflow.ellipsis,
          style:
              AppTextStyle().regular18DolphinGrey.copyWith(fontSize: 16.toFont),
        ),
      ),
    );
  }
}
