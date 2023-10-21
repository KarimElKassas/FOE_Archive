import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/presentation/home/bloc/home_cubit.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_cubit.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_states.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'package:foe_archive/resources/strings_manager.dart';
import 'package:foe_archive/resources/values_manager.dart';
import 'package:foe_archive/utils/components.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:ui' as ui;
import '../../../core/service/service_locator.dart';
import '../../../data/models/selected_department_model.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/pdf_viewer.dart';
import '../../../resources/routes_manager.dart';
import '../../letter_details/helper/letter_details_args.dart';
import '../../widget/custom_thumbnail.dart';
import '../../widget/department_widget.dart';
import '../../widget/selected_action_departments_widget.dart';
import '../../widget/tags_widget.dart';

class UpdateLetterScreen extends StatelessWidget {
  UpdateLetterScreen({Key? key,required this.letterModel,required this.letterFiles,required this.selectedActionList, required this.selectedKnowList}) : super(key: key);
  LetterModel letterModel;
  List<PlatformFile> letterFiles;
  List<SelectedDepartmentModel?> selectedActionList;
  List<SelectedDepartmentModel?> selectedKnowList;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<UpdateLetterCubit>()
          ..initData(letterModel, letterFiles, selectedActionList, selectedKnowList)
          ..getAllDirections()..getTags()..getSectors(),
        child: BlocConsumer<UpdateLetterCubit,UpdateLetterStates>(
            listener: (context, state){
              if(state is UpdateLetterSuccessful){
                Navigator.pop(context);
                Navigator.pop(context);
                ReusableComponents.showMToast(context, AppStrings.letterUpdatedSuccessful.tr(), TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
              }
              if(state is UpdateLetterLoading){
                showDialog(context: context, barrierDismissible: false, barrierLabel: '', builder: (context) => BlurryProgressDialog(title: AppStrings.loading.tr()));
              }
              if(state is UpdateLetterError){
                ReusableComponents.showMToast(context, state.error, TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
              }
            },
            builder: (context,state){
              var cubit = UpdateLetterCubit.get(context);
              return Form(
                key: formKey,
                child: Scaffold(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  appBar: AppBar(
                    automaticallyImplyLeading: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
                    title: Text(
                        '${AppStrings.updateLetter.tr()} : ${letterModel.letterNumber}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: AppSize.s18,
                            fontFamily: FontConstants.family,
                            fontWeight: FontWeightManager.regular)),
                  ),
                    floatingActionButton:
                    MouseRegion(
                      cursor: MaterialStateMouseCursor.clickable,
                      child: Container(
                        padding: const EdgeInsets.all(AppSize.s8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s8),
                          color: Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).primaryColorDark,
                              width: AppSize.s1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Ionicons.checkmark_done_circle,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            const SizedBox(width: AppSize.s8),
                            Text(
                              AppStrings.updateLetter.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: FontConstants.family,
                                  fontSize: AppSize.s18,
                                  fontWeight: FontWeightManager.bold),
                            ),
                          ],
                        ),
                      ),
                    ).ripple(() {
                      if(formKey.currentState!.validate()){
                        cubit.updateLetter(letterModel);
                      }
                    },
                        borderRadius: BorderRadius.circular(AppSize.s8),
                        overlayColor: MaterialStateColor.resolveWith(
                                (states) => Theme.of(context)
                                .primaryColorDark
                                .withOpacity(AppSize.s0_2))),
                  body: Padding(
                    padding: const EdgeInsets.all(AppSize.s16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.s8),
                                    border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s0_2),
                                  ),
                                  padding: const EdgeInsets.all(AppSize.s12),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(AppStrings.securityLevel.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                            fontFamily: FontConstants.family,
                                            fontSize: AppSize.s16,
                                            fontWeight: FontWeightManager.bold),),
                                      ),
                                      const SizedBox(height: AppSize.s12,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(AppStrings.verySecure.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14,
                                                  fontWeight: FontWeightManager.bold),),
                                              const SizedBox(width: AppSize.s8,),
                                              Checkbox(
                                                value: cubit.securityLevel == 1,
                                                activeColor: Theme.of(context).primaryColorDark,
                                                checkColor: ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if(cubit.securityLevel != 1){
                                                    cubit.changeSecurityLevel(1);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(AppStrings.secure.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14,
                                                  fontWeight: FontWeightManager.bold),),
                                              const SizedBox(width: AppSize.s8,),
                                              Checkbox(
                                                value: cubit.securityLevel == 2,
                                                activeColor: Theme.of(context).primaryColorDark,
                                                checkColor: ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if(cubit.securityLevel != 2){
                                                    cubit.changeSecurityLevel(2);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(AppStrings.normal.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14,
                                                  fontWeight: FontWeightManager.bold),),
                                              const SizedBox(width: AppSize.s8,),
                                              Checkbox(
                                                value: cubit.securityLevel == 3,
                                                activeColor: Theme.of(context).primaryColorDark,
                                                checkColor: ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if(cubit.securityLevel != 3){
                                                    cubit.changeSecurityLevel(3);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSize.s16,),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSize.s8),
                                    border: Border.all(color: Theme.of(context).primaryColorDark,width: AppSize.s0_2),
                                  ),
                                  padding: const EdgeInsets.all(AppSize.s12),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(AppStrings.necessaryLevel.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                            fontFamily: FontConstants.family,
                                            fontSize: AppSize.s16,
                                            fontWeight: FontWeightManager.bold),),
                                      ),
                                      const SizedBox(height: AppSize.s8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(AppStrings.veryNecessary.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14,
                                                  fontWeight: FontWeightManager.bold),),
                                              const SizedBox(width: AppSize.s8,),
                                              Checkbox(
                                                value: cubit.necessaryLevel == 1,
                                                activeColor: Theme.of(context).primaryColorDark,
                                                checkColor: ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if(cubit.necessaryLevel != 1){
                                                    cubit.changeNecessaryLevel(1);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(AppStrings.necessary.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14,
                                                  fontWeight: FontWeightManager.bold),),
                                              const SizedBox(width: AppSize.s8,),
                                              Checkbox(
                                                value: cubit.necessaryLevel == 2,
                                                activeColor: Theme.of(context).primaryColorDark,
                                                checkColor: ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if(cubit.necessaryLevel != 2){
                                                    cubit.changeNecessaryLevel(2);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(AppStrings.normal.tr(),style: TextStyle(color: Theme.of(context).primaryColorDark,
                                                  fontFamily: FontConstants.family,
                                                  fontSize: AppSize.s14,
                                                  fontWeight: FontWeightManager.bold),),
                                              const SizedBox(width: AppSize.s8,),
                                              Checkbox(
                                                value: cubit.necessaryLevel == 3,
                                                activeColor: Theme.of(context).primaryColorDark,
                                                checkColor: ColorManager.goldColor,
                                                onChanged: (bool? value) async {
                                                  if(cubit.necessaryLevel != 3){
                                                    cubit.changeNecessaryLevel(3);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSize.s16,),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ReusableComponents.registerTextField(
                                  context: context,
                                  background: Colors.transparent,
                                  textInputType: TextInputType.text,
                                  hintText: AppStrings.letterAbout.tr(),
                                  textInputAction: TextInputAction.next,
                                  borderColor: Theme.of(context).primaryColorDark,
                                  controller: cubit.letterAboutController,
                                  validate: (value) {
                                    if(value!.isEmpty){
                                      return AppStrings.letterAboutRequired.tr();
                                    }
                                    if(value.length < 50){
                                      return AppStrings.lengthShorter.tr();
                                    }
                                  },
                                  onChanged: (String? value) {},
                                ),
                              ),
                              const SizedBox(width: AppSize.s16,),
                              Expanded(
                                flex: 1,
                                child: ReusableComponents.registerTextField(
                                  context: context,
                                  background: Colors.transparent,
                                  textInputType: TextInputType.text,
                                  hintText: AppStrings.letterNumber.tr(),
                                  textInputAction: TextInputAction.next,
                                  borderColor: Theme.of(context).primaryColorDark,
                                  controller: cubit.letterNumberController,
                                  validate: (value) {
                                    if(value!.isEmpty){
                                      return AppStrings.letterNumberRequired.tr();
                                    }
                                    if(value.length < 5){
                                      return AppStrings.lengthShorter.tr();
                                    }
                                  },
                                  onChanged: (String? value) {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSize.s16,),
                          ReusableComponents.registerTextField(
                            context: context,
                            background: Colors.transparent,
                            textInputType: TextInputType.text,
                            hintText: AppStrings.letterContent.tr(),
                            textInputAction: TextInputAction.next,
                            borderColor: Theme.of(context).primaryColorDark,
                            controller: cubit.letterContentController,
                            maxLines: 5,
                            contentPadding: const EdgeInsets.all(AppSize.s12),
                            validate: (value) {
                              if(value!.isEmpty){
                                return AppStrings.letterContentRequired.tr();
                              }
                              if(value.length < 50){
                                return AppStrings.lengthShorter.tr();
                              }
                            },
                            onChanged: (String? value) {},
                          ),
                          const SizedBox(height: AppSize.s16,),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
        )
    );
  }
  Widget alterPdfDialog(BuildContext context, UpdateLetterCubit cubit, PlatformFile file) {
    bool _isClosing = false;
    return Directionality(
      textDirection: AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: AlertDialog(
        // <-- SEE HERE
          title: Text(
            file.name,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: AppSize.s16,
                fontWeight: FontWeightManager.bold,
                fontFamily: FontConstants.family),
          ),
          backgroundColor: Theme.of(context).primaryColorLight,
          titlePadding: const EdgeInsets.only(
              top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
          contentPadding: const EdgeInsets.all(AppSize.s12),
          content: SizedBox(
              height: AppSize.s75Height,
              width: AppSize.sFullWidth,
              child: PdfViewer(
                file: file,
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (!_isClosing) {
                  _isClosing = true;
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
              child: Text(
                AppStrings.print.tr(),
                style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    fontWeight: FontWeightManager.heavy,
                    color: Theme.of(context).primaryColorDark),
                maxLines: AppSize.s1.toInt(),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!_isClosing) {
                  _isClosing = true;
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
              child: Text(
                AppStrings.exit.tr(),
                style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    fontWeight: FontWeightManager.heavy,
                    color: Theme.of(context).primaryColorDark),
                maxLines: AppSize.s1.toInt(),
              ),
            ),
          ],
          buttonPadding: const EdgeInsets.all(AppSize.s10)),
    );
  }

}
