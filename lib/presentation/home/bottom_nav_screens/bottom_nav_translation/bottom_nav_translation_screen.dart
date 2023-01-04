import 'package:avatar_glow/avatar_glow.dart';
import 'package:bhashaverse/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/controller/language_model_controller.dart';
import '../../../../common/widgets/custom_outline_button.dart';
import '../../../../localization/localization_keys.dart';
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
    return Padding(
      padding: AppEdgeInsets.instance.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 18.toHeight,
          ),
          Text(
            appName.tr,
            style: AppTextStyle().semibold22BalticSea,
          ),
          SizedBox(
            height: 18.toHeight,
          ),
          Flexible(
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  border: Border.all(
                    color: americanSilver,
                  )),
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: AppEdgeInsets.instance.all(16),
                child: Obx(
                  () => Column(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Visibility(
                              visible: _bottomNavTranslationController
                                  .isTranslateCompleted.value,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _bottomNavTranslationController
                                        .selectedSourceLanguage.value,
                                    style: AppTextStyle().regular16DolphinGrey,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _bottomNavTranslationController
                                          .resetAllValues();
                                    },
                                    child: Text(
                                      kReset.tr,
                                      style: AppTextStyle()
                                          .regular18DolphinGrey
                                          .copyWith(color: japaneseLaurel),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 6.toHeight),
                            // Source language tex field
                            Flexible(
                              child: TextField(
                                controller: _bottomNavTranslationController
                                    .sourceLanTextController,
                                focusNode: _sourceLangFocusNode,
                                readOnly: _bottomNavTranslationController
                                    .isTranslateCompleted.value,
                                style: _bottomNavTranslationController
                                        .isTranslateCompleted.value
                                    ? AppTextStyle().regular18balticSea
                                    : AppTextStyle().regular28balticSea,
                                expands: true,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: _bottomNavTranslationController
                                          .isTranslateCompleted.value
                                      ? null
                                      : _bottomNavTranslationController
                                              .isMicButtonTapped.value
                                          ? kListeningHintText.tr
                                          : kTranslationHintText.tr,
                                  hintStyle: AppTextStyle()
                                      .regular28balticSea
                                      .copyWith(color: mischkaGrey),
                                  hintMaxLines: _bottomNavTranslationController
                                          .isTranslateCompleted.value
                                      ? null
                                      : 2,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            SizedBox(height: 6.toHeight),
                            if (_bottomNavTranslationController
                                .isTranslateCompleted.value)
                              _buildSourceTargetTextActions(
                                  false,
                                  (_bottomNavTranslationController
                                          .isRecordedViaMic.value ||
                                      _bottomNavTranslationController
                                          .isLanguageSwapped)),
                          ],
                        ),
                      ),
                      SizedBox(height: 6.toHeight),
                      _buildInputActionButtons(),
                      Visibility(
                        visible: _bottomNavTranslationController
                            .isTranslateCompleted.value,
                        child: Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Divider(
                                      color: dolphinGray,
                                    ),
                                    SizedBox(
                                      height: 12.toHeight,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        _bottomNavTranslationController
                                            .selectedTargetLanguage.value,
                                        style:
                                            AppTextStyle().regular16DolphinGrey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.toHeight,
                                    ),
                                    Flexible(
                                      child: TextField(
                                        controller:
                                            _bottomNavTranslationController
                                                .targetLangTextController,
                                        focusNode: _transLangFocusNode,
                                        expands: true,
                                        maxLines: null,
                                        style:
                                            AppTextStyle().regular18balticSea,
                                        readOnly:
                                            _bottomNavTranslationController
                                                .isTranslateCompleted.value,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6.toHeight),
                                    if (_bottomNavTranslationController
                                        .isTranslateCompleted.value)
                                      _buildSourceTargetTextActions(
                                          true,
                                          (!_bottomNavTranslationController
                                                  .isLanguageSwapped ||
                                              (_bottomNavTranslationController
                                                      .isRecordedViaMic.value &&
                                                  _bottomNavTranslationController
                                                      .isLanguageSwapped))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // language selection buttons
          SizedBox(
            height: 35.toHeight,
          ),
          _buildSourceTargetLangButtons(),

          // mic button
          SizedBox(
            height: 20.toHeight,
          ),
          _buildMicButton(),
        ],
      ),
    );
  }

  _buildInputActionButtons() {
    return Obx(
      () => Visibility(
        visible: !_bottomNavTranslationController.isTranslateCompleted.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomOutlineButton(
              icon: iconClipBoardText,
              title: kPaste.tr,
              onTap: () async {
                ClipboardData? clipboardData =
                    await Clipboard.getData(Clipboard.kTextPlain);
                if (clipboardData != null &&
                    (clipboardData.text ?? '').isNotEmpty) {
                  _bottomNavTranslationController.sourceLanTextController.text =
                      clipboardData.text ?? '';
                } else {
                  showDefaultSnackbar(message: errorNoTextInClipboard.tr);
                }
              },
            ),
            CustomOutlineButton(
              title: kTranslate.tr,
              isHighlighted: true,
              onTap: () {
                _sourceLangFocusNode.unfocus();
                _transLangFocusNode.unfocus();
                if (_bottomNavTranslationController
                    .sourceLanTextController.text.isEmpty) {
                  showDefaultSnackbar(message: kErrorNoSourceText.tr);
                } else if (_bottomNavTranslationController
                    .isSourceAndTargetLangSelected()) {
                  _bottomNavTranslationController.translateSourceLanguage();
                } else {
                  showDefaultSnackbar(
                      message: kErrorSelectSourceAndTargetScreen.tr);
                }
              },
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

            dynamic selectedSourceLangIndex =
                await Get.toNamed(AppRoutes.languageSelectionRoute, arguments: {
              kLanguageList: sourceLanguageList,
              kIsSourceLanguage: true
            });
            if (selectedSourceLangIndex != null) {
              String selectedLanguage =
                  sourceLanguageList[selectedSourceLangIndex];
              _bottomNavTranslationController.selectedSourceLanguage.value =
                  selectedLanguage;
              if (selectedLanguage ==
                  _bottomNavTranslationController
                      .selectedTargetLanguage.value) {
                _bottomNavTranslationController.selectedTargetLanguage.value =
                    '';
              }
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
            _bottomNavTranslationController.swapSourceAndTargetLanguage();
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

            dynamic selectedTargetLangIndex =
                await Get.toNamed(AppRoutes.languageSelectionRoute, arguments: {
              kLanguageList: targetLanguageList,
              kIsSourceLanguage: false
            });
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
                  message: kErrorSelectSourceAndTargetScreen.tr);
            }
          },
          backgroundColor: flushOrangeColor,
          child: SvgPicture.asset(
            _bottomNavTranslationController.isMicButtonTapped.value
                ? iconListening
                : iconMicroPhone,
          ),
        ),
      ),
    );
  }

  Widget _buildSourceTargetTextActions(
      bool isForTargetSection, bool showSoundButton) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            String shareText = '';
            if (isForTargetSection) {
              shareText =
                  _bottomNavTranslationController.targetLangTextController.text;
            } else {
              shareText =
                  _bottomNavTranslationController.sourceLanTextController.text;
            }
            if (shareText.isEmpty) {
              showDefaultSnackbar(message: noTextForShare.tr);
              return;
            } else {
              Share.share(shareText);
            }
          },
          child: Padding(
            padding: AppEdgeInsets.instance.symmetric(vertical: 8),
            child: SvgPicture.asset(
              iconShare,
              height: 24.toWidth,
              width: 24.toWidth,
              color: brightGrey,
            ),
          ),
        ),
        SizedBox(width: 24.toWidth),
        InkWell(
          onTap: () async {
            String copyText = '';
            if (isForTargetSection) {
              copyText =
                  _bottomNavTranslationController.targetLangTextController.text;
            } else {
              copyText =
                  _bottomNavTranslationController.sourceLanTextController.text;
            }
            if (copyText.isEmpty) {
              showDefaultSnackbar(message: noTextForCopy.tr);
              return;
            } else {
              await Clipboard.setData(ClipboardData(text: copyText));
              showDefaultSnackbar(message: textCopiedToClipboard.tr);
            }
          },
          child: Padding(
            padding: AppEdgeInsets.instance.symmetric(vertical: 8),
            child: SvgPicture.asset(
              iconCopy,
              height: 24.toWidth,
              width: 24.toWidth,
              color: brightGrey,
            ),
          ),
        ),
        const Spacer(),
        Visibility(
          visible: showSoundButton,
          child: InkWell(
            onTap: () {
              _bottomNavTranslationController.playTTSOutput(isForTargetSection);
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: flushOrangeColor,
              ),
              padding: AppEdgeInsets.instance.all(8),
              child: SvgPicture.asset(
                iconSound,
                height: 24.toWidth,
                width: 24.toWidth,
                color: balticSea,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
