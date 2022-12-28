import 'package:bhashaverse/presentation/home/bottom_nav_screens/bottom_nav_translation/controller/bottom_nav_translation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../common/language_selection_widget.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/remove_glow_effect.dart';
import '../../../utils/screen_util/screen_util.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_text_style.dart';
import 'controller/target_language_controller.dart';

class TargetLanguageScreen extends StatefulWidget {
  const TargetLanguageScreen({super.key});

  @override
  State<TargetLanguageScreen> createState() => _TargetLanguageScreenState();
}

class _TargetLanguageScreenState extends State<TargetLanguageScreen> {
  late BottomNavTranslationController _translationController;
  late TargetLanguageController _translateToController;
  late TextEditingController _languageSearchController;
  final FocusNode _focusNodeLanguageSearch = FocusNode();

  @override
  void initState() {
    _translationController = Get.find();
    _translateToController = Get.find();
    _languageSearchController = TextEditingController();
    ScreenUtil().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppEdgeInsets.instance.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.toHeight),
              _headerWidget(),
              SizedBox(height: 24.toHeight),
              _textFormFieldContainer(),
              SizedBox(height: 24.toHeight),
              Expanded(
                child: ScrollConfiguration(
                  behavior: RemoveScrollingGlowEffect(),
                  child: ListView.builder(
                    itemCount:
                        _translateToController.getAppLanguageList().length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () {
                          return LanguageSelectionWidget(
                            title: _translateToController
                                .getAppLanguageList()[index]
                                .title,
                            subTitle: _translateToController
                                .getAppLanguageList()[index]
                                .subTitle,
                            imageUrl: _translateToController
                                .getAppLanguageList()[index]
                                .image,
                            onItemTap: () async {
                              _translateToController
                                  .setSelectedLanguageIndex(index);
                              _translationController.targetLanguage.value =
                                  _translateToController
                                      .getAppLanguageList()[index];
                              if (_focusNodeLanguageSearch.hasFocus) {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                              }
                              Get.back(result: ['true']);
                            },
                            index: index,
                            selectedIndex: _translateToController
                                .getSelectedLanguageIndex(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.toHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFormFieldContainer() {
    return Container(
      margin: AppEdgeInsets.instance.symmetric(horizontal: 8),
      padding: AppEdgeInsets.instance.only(left: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: goastWhite,
      ),
      child: TextFormField(
        cursorColor: dolphinGray,
        decoration: InputDecoration(
          contentPadding: AppEdgeInsets.instance.all(0),
          border: InputBorder.none,
          icon: const Icon(
            Icons.search,
            color: dolphinGray,
          ),
          hintText: AppStrings.searchLanguage,
          hintStyle: AppTextStyle()
              .light16BalticSea
              .copyWith(fontSize: 18.toFont, color: manateeGray),
        ),
        controller: _languageSearchController,
        focusNode: _focusNodeLanguageSearch,
      ),
    );
  }

  Widget _headerWidget() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => Get.back(),
          child: Container(
            padding: AppEdgeInsets.instance.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1.toWidth, color: goastWhite),
            ),
            child: SvgPicture.asset(
              iconPrevious,
            ),
          ),
        ),
        SizedBox(width: 24.toWidth),
        Text(
          AppStrings.kTranslateTargetTitle,
          style: AppTextStyle().semibold24BalticSea,
        ),
      ],
    );
  }
}
