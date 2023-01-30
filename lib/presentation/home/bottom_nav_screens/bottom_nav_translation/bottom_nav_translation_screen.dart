import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/widgets/custom_outline_button.dart';
import '../../../../common/widgets/custom_plain_button.dart';
import '../../../../localization/localization_keys.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/screen_util/screen_util.dart';
import '../../../../utils/snackbar_utils.dart';
import '../../../../utils/theme/app_colors.dart';
import '../../../../utils/theme/app_text_style.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../utils/wavefrom_style.dart';
import 'controller/bottom_nav_translation_controller.dart';
import 'widgets/mic_button.dart';

class BottomNavTranslation extends StatefulWidget {
  const BottomNavTranslation({super.key});

  @override
  State<BottomNavTranslation> createState() => _BottomNavTranslationState();
}

class _BottomNavTranslationState extends State<BottomNavTranslation>
    with WidgetsBindingObserver {
  late BottomNavTranslationController _bottomNavTranslationController;
  final FocusNode _sourceLangFocusNode = FocusNode();
  final FocusNode _transLangFocusNode = FocusNode();

  @override
  void initState() {
    _bottomNavTranslationController = Get.find();
    WidgetsBinding.instance.addObserver(this);

    ScreenUtil().init();
    super.initState();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _bottomNavTranslationController.isKeyboardVisible.value) {
      _bottomNavTranslationController.isKeyboardVisible.value = newValue;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
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
                                      unFocusTextFields();
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
                            // Source language text field
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
                                onChanged: (newText) {
                                  if (_bottomNavTranslationController
                                      .isTransliterationEnabled()) {
                                    getTransliterationHints(newText);
                                  } else {
                                    _bottomNavTranslationController
                                        .transliterationWordHints
                                        .clear();
                                  }
                                },
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
          SizedBox(
            height: 8.toHeight,
          ),

          SizedBox(
            height: 70.toHeight,
            child: Obx(
              () => Visibility(
                visible:
                    _bottomNavTranslationController.isKeyboardVisible.value,
                child: Column(
                  children: [
                    SingleChildScrollView(
                      controller: _bottomNavTranslationController
                          .transliterationHintsScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ..._bottomNavTranslationController
                              .transliterationWordHints
                              .map((hintText) => GestureDetector(
                                    onTap: () {
                                      replaceTextWithTransliterationHint(
                                          hintText);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: lilyWhite,
                                      ),
                                      margin: AppEdgeInsets.instance.all(4),
                                      padding: AppEdgeInsets.instance.symmetric(
                                          vertical: 4, horizontal: 6),
                                      alignment: Alignment.center,
                                      child: Container(
                                        constraints: BoxConstraints(
                                          minWidth: (ScreenUtil.screenWidth / 6)
                                              .toWidth,
                                          // maxWidth: 300,
                                        ),
                                        child: Text(
                                          hintText,
                                          style: AppTextStyle()
                                              .regular18DolphinGrey
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_bottomNavTranslationController
                              .isScrolledTransliterationHints.value &&
                          _bottomNavTranslationController
                              .transliterationWordHints.isNotEmpty,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.grey.shade400,
                          size: 22.toHeight,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // language selection buttons
          SizedBox(
            height: 20.toHeight,
          ),
          Obx(
            () => _bottomNavTranslationController.isKeyboardVisible.value
                ? const SizedBox.shrink()
                : _buildSourceTargetLangButtons(),
          ),

          // mic button
          Obx(
            () => _bottomNavTranslationController.isKeyboardVisible.value
                ? const SizedBox.shrink()
                : _buildMicButton(),
          ),
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
                unFocusTextFields();
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
        Obx(
          () => CustomPlainButton(
              title: _bottomNavTranslationController
                  .getSelectedSourceLanguageName(),
              onTap: () async {
                unFocusTextFields();
                _bottomNavTranslationController.updateSourceLanguage();
              }),
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
        Obx(
          () => CustomPlainButton(
              title: _bottomNavTranslationController
                  .getSelectedTargetLanguageName(),
              onTap: () async {
                unFocusTextFields();
                _bottomNavTranslationController.updateTargetLanguage();
              }),
        ),
      ],
    );
  }

  Widget _buildMicButton() {
    return Obx(
      () => MicButton(
        isRecording: _bottomNavTranslationController.isMicButtonTapped.value,
        onTap: () {
          if (_bottomNavTranslationController.isSourceAndTargetLangSelected()) {
            unFocusTextFields();
            if (!_bottomNavTranslationController.isMicButtonTapped.value) {
              _bottomNavTranslationController.startVoiceRecording();
            } else {
              _bottomNavTranslationController.stopVoiceRecordingAndGetResult();
            }
          } else {
            showDefaultSnackbar(message: kErrorSelectSourceAndTargetScreen.tr);
          }
        },
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
                  SizedBox(
                    width: WaveformStyle.getDefaultWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            DateTImeUtils().getTimeFromMilliseconds(
                                timeInMillisecond:
                                    _bottomNavTranslationController
                                        .currentDuration.value),
                            style: AppTextStyle()
                                .regular12Arsenic
                                .copyWith(color: manateeGray),
                            textAlign: TextAlign.start),
                        Text(
                            DateTImeUtils().getTimeFromMilliseconds(
                                timeInMillisecond:
                                    _bottomNavTranslationController
                                        .maxDuration.value),
                            style: AppTextStyle()
                                .regular12Arsenic
                                .copyWith(color: manateeGray),
                            textAlign: TextAlign.end),
                      ],
                    ),
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

  void getTransliterationHints(String newText) {
    String wordToSend = newText.split(" ").last;
    if (wordToSend.isNotEmpty) {
      if (_bottomNavTranslationController
          .selectedSourceLanguage.value.isNotEmpty) {
        _bottomNavTranslationController.getTransliterationOutput(wordToSend);
      }
    } else {
      _bottomNavTranslationController.clearTransliterationHints();
    }
  }

  void replaceTextWithTransliterationHint(String currentHintText) {
    List<String> oldString = _bottomNavTranslationController
        .sourceLanTextController.text
        .trim()
        .split(' ');
    oldString.removeLast();
    oldString.add(currentHintText);
    _bottomNavTranslationController.sourceLanTextController.text =
        '${oldString.join(' ')} ';
    _bottomNavTranslationController.sourceLanTextController.selection =
        TextSelection.fromPosition(TextPosition(
            offset: _bottomNavTranslationController
                .sourceLanTextController.text.length));
    _bottomNavTranslationController.clearTransliterationHints();
  }

  bool shouldShowWaveforms(bool isForTargetSection) {
    return ((isForTargetSection &&
            _bottomNavTranslationController.isPlayingTarget.value) ||
        (!isForTargetSection &&
            _bottomNavTranslationController.isPlayingSource.value));
  }

  void unFocusTextFields() {
    _sourceLangFocusNode.unfocus();
    _transLangFocusNode.unfocus();
  }
}
