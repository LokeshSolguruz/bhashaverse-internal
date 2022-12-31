import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../enums/gender_enum.dart';
import '../../../../localization/localization_keys.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/screen_util/screen_util.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_text_style.dart';
import 'controller/settings_controller.dart';

class BottomNavSettings extends StatefulWidget {
  const BottomNavSettings({super.key});

  @override
  State<BottomNavSettings> createState() => _BottomNavSettingsState();
}

class _BottomNavSettingsState extends State<BottomNavSettings> {
  late SettingsController _settingsController;

  @override
  void initState() {
    super.initState();
    _settingsController = Get.find();
    ScreenUtil().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sassyGreen,
      body: SafeArea(
        child: Padding(
          padding: AppEdgeInsets.instance.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.toHeight),
              Text(
                kSettings.tr,
                style: AppTextStyle()
                    .semibold24BalticSea
                    .copyWith(fontSize: 20.toFont),
              ),
              SizedBox(height: 48.toHeight),
              _containerWidget(
                widget: _popupMenuBuilder(),
                title: appTheme.tr,
                subtitle: appInterfaceWillChange.tr,
              ),
              SizedBox(height: 24.toHeight),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: _containerWidget(
                  widget: Row(
                    children: [
                      //TODO: remove static
                      Text(
                        english.tr,
                        style: AppTextStyle()
                            .light16BalticSea
                            .copyWith(color: arsenicColor),
                      ),
                      SizedBox(width: 8.toWidth),
                      RotatedBox(
                        quarterTurns: 3,
                        child: SvgPicture.asset(iconArrowDown),
                      ),
                    ],
                  ),
                  title: english.tr,
                  subtitle: appInterfaceWillChangeInSelected.tr,
                ),
              ),
              SizedBox(height: 24.toHeight),
              _voiceAssistantTileWidget(),
              SizedBox(height: 24.toHeight),
              _containerWidget(
                widget: Obx(
                  () => CupertinoSwitch(
                    value: _settingsController.isTransLiterationOn.value,
                    activeColor: japaneseLaurel,
                    trackColor: americanSilver,
                    onChanged: (value) {
                      _settingsController.isTransLiterationOn.value = value;
                    },
                  ),
                ),
                title: transLiteration.tr,
                subtitle: transLiterationWillInitiateWord.tr,
              ),
              SizedBox(height: 24.toHeight),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: _containerWidget(
                  widget: SvgPicture.asset(iconArrowDown),
                  title: advanceSettings.tr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _containerWidget({
    required Widget widget,
    required String title,
    String subtitle = '',
  }) {
    return Container(
      padding: AppEdgeInsets.instance.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.toWidth,
          color: goastWhite,
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTextStyle().regular18DolphinGrey.copyWith(
                      fontSize: 20.toFont,
                      color: balticSea,
                    ),
              ),
              const Spacer(),
              widget,
            ],
          ),
          if (subtitle.isNotEmpty) SizedBox(height: 16.toHeight),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: AppTextStyle().light16BalticSea.copyWith(
                    fontSize: 14.toFont,
                    color: dolphinGray,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _voiceAssistantTileWidget() {
    return Container(
      padding: AppEdgeInsets.instance.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1.toWidth,
          color: goastWhite,
        ),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              voiceAssistant.tr,
              style: AppTextStyle().regular18DolphinGrey.copyWith(
                    fontSize: 20.toFont,
                    color: balticSea,
                  ),
            ),
          ),
          _radioWidgetBuilder(
            GenderEnum.male,
            male.tr,
          ),
          SizedBox(width: 8.toWidth),
          _radioWidgetBuilder(
            GenderEnum.female,
            female.tr,
          ),
        ],
      ),
    );
  }

  Widget _radioWidgetBuilder(
    GenderEnum enumComparisonValue,
    String title,
  ) {
    return Obx(
      () => InkWell(
        onTap: () {
          _settingsController.selectedGender.value = enumComparisonValue;
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.toWidth,
              color: (_settingsController.selectedGender.value ==
                      enumComparisonValue)
                  ? japaneseLaurel
                  : americanSilver,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding:
              AppEdgeInsets.instance.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                (_settingsController.selectedGender.value ==
                        enumComparisonValue)
                    ? iconSelectedRadio
                    : iconUnSelectedRadio,
              ),
              SizedBox(width: 5.toWidth),
              Text(
                title,
                style: AppTextStyle().regular18DolphinGrey.copyWith(
                      fontSize: 16.toFont,
                      color: (_settingsController.selectedGender.value ==
                              enumComparisonValue)
                          ? japaneseLaurel
                          : dolphinGray,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _popupMenuBuilder() {
    return Obx(
      () => PopupMenuButton(
        onSelected: (value) {
          _settingsController.selectedThemeMode.value = value;
        },
        child: Row(
          children: [
            Text(
              _getThemeModeName(_settingsController.selectedThemeMode.value),
              style:
                  AppTextStyle().light16BalticSea.copyWith(color: arsenicColor),
            ),
            SizedBox(width: 8.toWidth),
            SvgPicture.asset(iconArrowDown),
          ],
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: ThemeMode.light,
            child: Text((light.tr)),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Text(dark.tr),
          ),
          PopupMenuItem(
            value: ThemeMode.system,
            child: Text(systemDefault.tr),
          ),
        ],
      ),
    );
  }

  /// Get ThemeMode in string of given ThemeMode
  String _getThemeModeName(ThemeMode themeMode) {
    //TODO: set return keys not translatedble
    switch (themeMode) {
      case ThemeMode.system:
        return systemDefault;
      case ThemeMode.light:
        return light;
      case ThemeMode.dark:
        return dark;
    }
  }
}
