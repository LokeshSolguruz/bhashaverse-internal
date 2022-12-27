import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/elevated_button.dart';
import '../../enums/gender_enum.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/screen_util/screen_util.dart';
import '../../utils/theme/app_colors.dart';
import '../../utils/theme/app_text_style.dart';
import 'controller/voice_assistant_controller.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  late VoiceAssistantController _voiceAssistantController;

  @override
  void initState() {
    super.initState();
    _voiceAssistantController = Get.put(VoiceAssistantController());
    ScreenUtil().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppEdgeInsets.instance.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.toHeight),
              Text(
                AppStrings.selectVoiceAssistant,
                style: AppTextStyle().semibold24BalticSea,
              ),
              SizedBox(height: 8.toHeight),
              Text(
                AppStrings.youWillHearTheTranslationText,
                style: AppTextStyle()
                    .light16BalticSea
                    .copyWith(color: dolphinGray),
              ),
              SizedBox(height: 56.toHeight),
              Row(
                children: [
                  _avatarWidgetBuilder(
                    GenderEnum.male,
                    imgMaleAvatar,
                    AppStrings.male,
                  ),
                  SizedBox(width: 10.toWidth),
                  _avatarWidgetBuilder(
                    GenderEnum.female,
                    imgFemaleAvatar,
                    AppStrings.female,
                  ),
                ],
              ),
              const Spacer(),
              elevatedButton(
                buttonText: AppStrings.letsTranslate,
                textStyle: AppTextStyle()
                    .semibold24BalticSea
                    .copyWith(fontSize: 18.toFont),
                backgroundColor: primaryColor,
                borderRadius: 16,
                onButtonTap: () => Get.offNamed(AppRoutes.homeRoute),
              ),
              SizedBox(height: 36.toHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarWidgetBuilder(
    GenderEnum gender,
    String avatarImage,
    String avatarTitle,
  ) {
    return Expanded(
      child: Obx(
        () => InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _voiceAssistantController.setSelectedGender(gender);
          },
          child: Container(
            padding: AppEdgeInsets.instance.all(22),
            decoration: BoxDecoration(
              color: (_voiceAssistantController.getSelectedGender() == gender)
                  ? sassyGreen
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                width: 1.toWidth,
                color: (_voiceAssistantController.getSelectedGender() == gender)
                    ? japaneseLaurel
                    : americanSilver,
              ),
            ),
            child: Column(
              children: [
                Image.asset(avatarImage),
                SizedBox(height: 16.toHeight),
                Text(
                  avatarTitle,
                  style: AppTextStyle().regular18DolphinGrey.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}