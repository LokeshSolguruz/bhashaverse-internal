import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:bhashaverse/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/controller/language_model_controller.dart';
import '../../../../common/widgets/custom_outline_button.dart';
import '../../../../localization/localization_keys.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/screen_util/screen_util.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_text_style.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../utils/wavefrom_style.dart';
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
                                  isForTargetSection: false,
                                  showSoundButton:
                                      _bottomNavTranslationController
                                          .isRecordedViaMic.value),
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
                                          isForTargetSection: true),
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
      () => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity:
                _bottomNavTranslationController.isMicButtonTapped.value ? 1 : 0,
            duration: const Duration(milliseconds: 600),
            child: Padding(
              padding: AppEdgeInsets.instance.symmetric(horizontal: 16.0),
              child: LottieBuilder.asset(
                animationStaticWave,
                fit: BoxFit.cover,
              ),
            ),
          ),
          FloatingActionButton(
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
        ],
      ),
    );
  }

  Widget _buildSourceTargetTextActions({
    required bool isForTargetSection,
    bool showSoundButton = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: !shouldShowWaveforms(isForTargetSection),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  String shareText = '';
                  if (isForTargetSection) {
                    shareText = _bottomNavTranslationController
                        .targetLangTextController.text;
                  } else {
                    shareText = _bottomNavTranslationController
                        .sourceLanTextController.text;
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
              SizedBox(width: 12.toWidth),
              InkWell(
                onTap: () async {
                  String copyText = '';
                  if (isForTargetSection) {
                    copyText = _bottomNavTranslationController
                        .targetLangTextController.text;
                  } else {
                    copyText = _bottomNavTranslationController
                        .sourceLanTextController.text;
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
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => Visibility(
              visible: shouldShowWaveforms(isForTargetSection),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AudioFileWaveforms(
                    size: Size(WaveformStyle.getDefaultWidth,
                        WaveformStyle.getDefaultHeight),
                    playerController:
                        _bottomNavTranslationController.controller,
                    waveformType: WaveformType.fitWidth,
                    playerWaveStyle: WaveformStyle.getDefaultPlayerStyle(
                        isRecordedAudio: !isForTargetSection),
                  ),
                  SizedBox(width: 8.toWidth),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          DateTImeUtils().getTimeFromMilliseconds(
                              timeInMillisecond: _bottomNavTranslationController
                                  .currentDuration.value),
                          style: AppTextStyle()
                              .regular14Arsenic
                              .copyWith(color: dolphinGray),
                          textAlign: TextAlign.start),
                      Text(
                          DateTImeUtils().getTimeFromMilliseconds(
                              timeInMillisecond: _bottomNavTranslationController
                                  .maxDuration.value),
                          style: AppTextStyle()
                              .regular14Arsenic
                              .copyWith(color: dolphinGray),
                          textAlign: TextAlign.end),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.toWidth),
        Visibility(
          visible: showSoundButton,
          child: InkWell(
            onTap: () async {
              shouldShowWaveforms(isForTargetSection)
                  ? await _bottomNavTranslationController.stopPlayer()
                  : _bottomNavTranslationController
                      .playTTSOutput(isForTargetSection);
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: flushOrangeColor,
              ),
              padding: AppEdgeInsets.instance.all(8),
              child: Obx(
                () => SvgPicture.asset(
                  shouldShowWaveforms(isForTargetSection)
                      ? iconStopPlayback
                      : iconSound,
                  height: 24.toWidth,
                  width: 24.toWidth,
                  color: balticSea,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool shouldShowWaveforms(bool isForTargetSection) {
    return ((isForTargetSection &&
            _bottomNavTranslationController.isPlayingTarget.value) ||
        (!isForTargetSection &&
            _bottomNavTranslationController.isPlayingSource.value));
  }
}
