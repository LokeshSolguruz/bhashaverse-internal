import 'package:bhashaverse/utils/screen_util/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../common/language_selection_widget.dart';
import '../../../enums/language_enum.dart';
import '../../../localization/localization_keys.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/remove_glow_effect.dart';
import '../../../utils/theme/app_colors.dart';
import '../../../utils/theme/app_text_style.dart';
import 'controller/language_selection_controller.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late LanguageSelectionController _translateFromController;
  late TextEditingController _languageSearchController;
  final FocusNode _focusNodeLanguageSearch = FocusNode();
  List<dynamic> languagesList = [];

  @override
  void initState() {
    _translateFromController = Get.find();
    _languageSearchController = TextEditingController();
    ScreenUtil().init();
    super.initState();
    var langFromArgument = Get.arguments;
    if (langFromArgument != null && langFromArgument.isNotEmpty) {
      languagesList = langFromArgument;
    }
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
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8.toHeight,
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                    ),
                    itemCount: languagesList.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () {
                          return LanguageSelectionWidget(
                            title: languagesList[index],
                            subTitle: APIConstants.getLanguageCodeOrName(
                                value: languagesList[index],
                                returnWhat: LanguageMap.englishName,
                                lang_code_map: APIConstants.LANGUAGE_CODE_MAP),
                            onItemTap: () async {
                              Get.back(result: index);
                            },
                            index: index,
                            selectedIndex: _translateFromController
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
          hintText: searchLanguage.tr,
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
          kTranslateSourceTitle.tr,
          style: AppTextStyle().semibold24BalticSea,
        ),
      ],
    );
  }
}
