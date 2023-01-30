import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../../utils/constants/app_constants.dart';
import '../../../../../utils/screen_util/screen_util.dart';
import '../../../../../utils/theme/app_colors.dart';

class MicButton extends StatelessWidget {
  const MicButton({
    Key? key,
    required bool isRecording,
    required Function onTap,
  })  : _isRecording = isRecording,
        _onTap = onTap,
        super(key: key);

  final bool _isRecording;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: _isRecording ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: AppEdgeInsets.instance.symmetric(horizontal: 16.0),
            child: LottieBuilder.asset(animationStaticWaveForRecording,
                fit: BoxFit.cover, animate: _isRecording),
          ),
        ),
        GestureDetector(
          onTap: () => _onTap(),
          child: PhysicalModel(
            color: Colors.transparent,
            shape: BoxShape.circle,
            elevation: 6,
            child: Container(
              decoration: const BoxDecoration(
                color: flushOrangeColor,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: AppEdgeInsets.instance.all(20.0),
                child: SvgPicture.asset(
                  _isRecording ? iconMicStop : iconMicroPhone,
                  height: 32.toHeight,
                  width: 32.toWidth,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
