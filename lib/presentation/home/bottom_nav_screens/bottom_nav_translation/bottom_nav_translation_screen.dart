import 'package:avatar_glow/avatar_glow.dart';
import 'package:bhashaverse/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/controller/language_model_controller.dart';
import '../../../../common/widgets/custom_outline_button.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/screen_util/screen_util.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_text_style.dart';
import 'controller/bottom_nav_translation_controller.dart';

class BottomNavTranslation extends StatefulWidget {
  const BottomNavTranslation({super.key});

  @override
  State<BottomNavTranslation> createState() => _BottomNavTranslationState();
}

class _BottomNavTranslationState extends State<BottomNavTranslation> {
  late BottomNavTranslationController _bottomNavTranslationController;
  late LanguageModelController _languageModelController;
  final FocusNode _sourceLangFocusNode = FocusNode();
  final FocusNode _transLangFocusNode = FocusNode();

  @override
  void initState() {
    _bottomNavTranslationController = Get.find();
    _languageModelController = Get.find();
    ScreenUtil().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use proper laoding widget
    return Obx(
      () => _bottomNavTranslationController.isLsLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: AppEdgeInsets.instance.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 46.toHeight,
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Obx(
                        () => Stack(
                          children: [
                            Padding(
                              padding: AppEdgeInsets.instance.all(16),
                              child: Column(
                                children: [
                                  if (_bottomNavTranslationController
                                      .isTranslateCompleted.value)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _bottomNavTranslationController
                                              .selectedSourceLanguage.value,
                                          style: AppTextStyle()
                                              .regular18DolphinGrey,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _bottomNavTranslationController
                                                .sourceLanTextController
                                                .clear();
                                            _bottomNavTranslationController
                                                .targetLangTextController
                                                .clear();
                                            _bottomNavTranslationController
                                                .isMicButtonTapped
                                                .value = false;
                                            _bottomNavTranslationController
                                                .isTranslateCompleted
                                                .value = false;
                                          },
                                          child: Text(
                                            AppStrings.kClearAll,
                                            style: AppTextStyle()
                                                .regular18DolphinGrey
                                                .copyWith(
                                                    color: japaneseLaurel),
                                          ),
                                        )
                                      ],
                                    ),
                                  SizedBox(
                                    height: 6.toHeight,
                                  ),
                                  TextField(
                                    controller: _bottomNavTranslationController
                                        .sourceLanTextController,
                                    focusNode: _sourceLangFocusNode,
                                    onChanged: (_) {
                                      if (_bottomNavTranslationController
                                          .sourceLanTextController
                                          .value
                                          .text
                                          .isEmpty) {
                                      } else {}
                                    },
                                    maxLines: 6,
                                    decoration: InputDecoration.collapsed(
                                        hintText: _bottomNavTranslationController
                                                .isTranslateCompleted.value
                                            ? ''
                                            : _bottomNavTranslationController
                                                    .isMicButtonTapped.value
                                                ? AppStrings.kListeningHintText
                                                : AppStrings
                                                    .kTranslationHintText),
                                  ),
                                  SizedBox(height: 6.toHeight),
                                  if (_bottomNavTranslationController
                                      .isTranslateCompleted.value)
                                    _buildSourceTargetTextActions(false),
                                  SizedBox(height: 6.toHeight),
                                  Expanded(
                                    child: Obx(
                                      () => Visibility(
                                        visible: _bottomNavTranslationController
                                            .isTranslateCompleted.value,
                                        child: Column(
                                          children: [
                                            const Divider(),
                                            if (_bottomNavTranslationController
                                                .isSourceAndTargetLangSelected())
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  _bottomNavTranslationController
                                                      .selectedTargetLanguage
                                                      .value,
                                                  style: AppTextStyle()
                                                      .regular18DolphinGrey,
                                                ),
                                              ),
                                            SizedBox(
                                              height: 6.toHeight,
                                            ),
                                            TextField(
                                              controller:
                                                  _bottomNavTranslationController
                                                      .targetLangTextController,
                                              focusNode: _transLangFocusNode,
                                              maxLines: 6,
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none),
                                            ),
                                            SizedBox(height: 6.toHeight),
                                            if (_bottomNavTranslationController
                                                .isTranslateCompleted.value)
                                              _buildSourceTargetTextActions(
                                                  true),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: !_bottomNavTranslationController
                                  .isTranslateCompleted.value,
                              child: Positioned(
                                bottom: 24.toHeight,
                                left: 24.toWidth,
                                child: CustomOutlineButton(
                                  icon: iconClipBoardText,
                                  title: AppStrings.kPaste,
                                  onTap: () {},
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !_bottomNavTranslationController
                                  .isTranslateCompleted.value,
                              child: Positioned(
                                bottom: 24.toHeight,
                                right: 24.toWidth,
                                child: CustomOutlineButton(
                                  title: AppStrings.kTranslate,
                                  onTap: () {
                                    _sourceLangFocusNode.unfocus();
                                    _transLangFocusNode.unfocus();
                                    if (_bottomNavTranslationController
                                        .sourceLanTextController.text.isEmpty) {
                                      showDefaultSnackbar(
                                          message:
                                              AppStrings.kErrorNoSourceText);
                                    } else if (_bottomNavTranslationController
                                        .isSourceAndTargetLangSelected()) {
                                      _bottomNavTranslationController
                                          .translateSourceLanguage();
                                    } else {
                                      showDefaultSnackbar(
                                          message: AppStrings
                                              .kErrorSelectSourceAndTargetScreen);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35.toHeight,
                  ),
                  _buildSourceTargetLangButtons(),
                  SizedBox(
                    height: 32.toHeight,
                  ),
                  _buildMicButton(),
                  SizedBox(
                    height: 10.toHeight,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSourceTargetLangButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            _sourceLangFocusNode.unfocus();
            _transLangFocusNode.unfocus();

            List<dynamic> sourceLanguageList =
                _languageModelController.allAvailableSourceLanguages.toList();

            if (_bottomNavTranslationController
                .selectedTargetLanguage.value.isNotEmpty) {
              sourceLanguageList.removeWhere((eachAvailableSourceLanguage) {
                return eachAvailableSourceLanguage ==
                    _bottomNavTranslationController
                        .selectedTargetLanguage.value;
              });
            }

            dynamic selectedSourceLangIndex = await Get.toNamed(
                AppRoutes.languageSelectionRoute,
                arguments: sourceLanguageList);
            if (selectedSourceLangIndex != null) {
              _bottomNavTranslationController.selectedSourceLanguage.value =
                  sourceLanguageList[selectedSourceLangIndex];
            }
          },
          child: Container(
            width: ScreenUtil.screenWidth / 2.8,
            height: 70.toHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Obx(
              () {
                return Text(
                  _bottomNavTranslationController
                      .getSelectedSourceLanguageName(),
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle()
                      .regular18DolphinGrey
                      .copyWith(fontSize: 16.toFont),
                );
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _bottomNavTranslationController
                .interchangeSourceAndTargetLanguage();
          },
          child: SvgPicture.asset(
            iconArrowSwapHorizontal,
            height: 32.toHeight,
            width: 32.toWidth,
          ),
        ),
        InkWell(
          onTap: () async {
            _sourceLangFocusNode.unfocus();
            _transLangFocusNode.unfocus();

            List<dynamic> targetLanguageList =
                _languageModelController.allAvailableTargetLanguages.toList();

            if (_bottomNavTranslationController
                .selectedSourceLanguage.value.isNotEmpty) {
              targetLanguageList.removeWhere((eachAvailableTargetLanguage) {
                return eachAvailableTargetLanguage ==
                    _bottomNavTranslationController
                        .selectedSourceLanguage.value;
              });
            }

            dynamic selectedTargetLangIndex = await Get.toNamed(
                AppRoutes.languageSelectionRoute,
                arguments: targetLanguageList);
            if (selectedTargetLangIndex != null) {
              _bottomNavTranslationController.selectedTargetLanguage.value =
                  targetLanguageList[selectedTargetLangIndex];
            }
          },
          child: Container(
            width: ScreenUtil.screenWidth / 2.8,
            height: 70.toHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Obx(
              () => Text(
                _bottomNavTranslationController.getSelectedTargetLanguageName(),
                style: AppTextStyle()
                    .regular18DolphinGrey
                    .copyWith(fontSize: 16.toFont),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMicButton() {
    return Obx(
      () => AvatarGlow(
        animate: _bottomNavTranslationController.isMicButtonTapped.value,
        glowColor: flushOrangeColor,
        endRadius: 40.0,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        showTwoGlows: true,
        startDelay: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: () {
            if (_bottomNavTranslationController
                .isSourceAndTargetLangSelected()) {
              if (!_bottomNavTranslationController.isMicButtonTapped.value) {
                _bottomNavTranslationController.startVoiceRecording();
              } else {
                _bottomNavTranslationController
                    .stopVoiceRecordingAndGetResult();
              }
            } else {
              showDefaultSnackbar(
                  message: AppStrings.kErrorSelectSourceAndTargetScreen);
            }
          },
          backgroundColor: flushOrangeColor,
          child: SvgPicture.asset(
            iconMicroPhone,
          ),
        ),
      ),
    );
  }

  Widget _buildSourceTargetTextActions(bool isForTargetSection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset(
          iconShare,
          height: 20.toWidth,
          width: 20.toWidth,
          color: dolphinGray,
        ),
        SizedBox(width: 8.toWidth),
        SvgPicture.asset(
          iconCopy,
          height: 20.toWidth,
          width: 20.toWidth,
          color: dolphinGray,
        ),
        SizedBox(width: 8.toWidth),
        InkWell(
          onTap: () {
            //: TODO: fix source TTS issue
            // _bottomNavTranslationController.playTTSOutput(isForTargetSection);
          },
          child: SvgPicture.asset(
            iconSound,
            height: 20.toWidth,
            width: 20.toWidth,
            color: dolphinGray,
          ),
        ),
      ],
    );
  }
}
