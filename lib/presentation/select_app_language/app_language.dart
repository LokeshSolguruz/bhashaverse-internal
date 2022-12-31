import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/elevated_button.dart';
import '../../common/language_selection_widget.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/remove_glow_effect.dart';
import '../../utils/screen_util/screen_util.dart';
import '../../utils/theme/app_colors.dart';
import '../../utils/theme/app_text_style.dart';
import 'controller/app_language_controller.dart';

class AppLanguage extends StatefulWidget {
  const AppLanguage({super.key});

  @override
  State<AppLanguage> createState() => _AppLanguageState();
}

class _AppLanguageState extends State<AppLanguage> {
  late AppLanguageController _appLanguageController;
  late TextEditingController _languageSearchController;
  final FocusNode _focusNodeLanguageSearch = FocusNode();

  @override
  void initState() {
    _appLanguageController = Get.put(AppLanguageController());
    _languageSearchController = TextEditingController();
    ScreenUtil().init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_focusNodeLanguageSearch.hasFocus) {
      _focusNodeLanguageSearch.unfocus();
    }
    _focusNodeLanguageSearch.dispose();
    _appLanguageController.dispose();
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
              Text(
                AppStrings.selectAppLanguage,
                style: AppTextStyle().semibold24BalticSea,
              ),
              SizedBox(height: 8.toHeight),
              Text(
                AppStrings.youCanAlwaysChange,
                style: AppTextStyle()
                    .light16BalticSea
                    .copyWith(color: dolphinGray),
              ),
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
                    itemCount:
                        _appLanguageController.getAppLanguageList().length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () {
                          return LanguageSelectionWidget(
                            title: _appLanguageController
                                .getAppLanguageList()[index]
                                .title,
                            subTitle: _appLanguageController
                                .getAppLanguageList()[index]
                                .subTitle,
                            onItemTap: () => _appLanguageController
                                .setSelectedLanguageIndex(index),
                            index: index,
                            selectedIndex: _appLanguageController
                                .getSelectedLanguageIndex(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.toHeight),
              elevatedButton(
                buttonText: AppStrings.continueText,
                textStyle: AppTextStyle()
                    .semibold24BalticSea
                    .copyWith(fontSize: 18.toFont),
                backgroundColor: primaryColor,
                borderRadius: 16,
                onButtonTap: () {
                  if (_focusNodeLanguageSearch.hasFocus) {
                    _focusNodeLanguageSearch.unfocus();
                  }
                  _languageSearchController.clear();
                  Future.delayed(const Duration(milliseconds: 200)).then((_) {
                    Get.toNamed(AppRoutes.onboardingRoute);
                  });
                },
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
}
