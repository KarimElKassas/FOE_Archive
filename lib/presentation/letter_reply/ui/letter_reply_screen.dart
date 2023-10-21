import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/presentation/letter_details/ui/letter_details_screen.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_cubit.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_states.dart';
import 'package:foe_archive/presentation/widget/selected_action_departments_widget.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../core/service/service_locator.dart';
import '../../../data/models/letter_model.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/pdf_viewer.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../utils/components.dart';
import 'dart:ui' as ui;

import '../../widget/custom_thumbnail.dart';
import '../../widget/department_widget.dart';
import '../../widget/tags_widget.dart';
class LetterReplyScreen extends StatelessWidget {
  LetterReplyScreen({Key? key, required this.letterModel}) : super(key: key);
  final LetterModel letterModel;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => sl<LetterReplyCubit>()..getAllDirections()..getTags()..getSectors(),
        child: BlocConsumer<LetterReplyCubit,LetterReplyStates>(
            listener: (context, state){
              if(state is LetterReplySuccessfulSend){
                Navigator.pop(context);
                Navigator.pop(context);
                ReusableComponents.showMToast(context, AppStrings.letterSentSuccessful.tr(), TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
              }
              if(state is LetterReplyLoadingSend){
                showDialog(context: context, barrierDismissible: true, barrierLabel: '', builder: (context) => BlurryProgressDialog(title: AppStrings.loading.tr()));
              }
              if(state is LetterReplyErrorSend){
                ReusableComponents.showMToast(context, state.error, TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
              }
            },
            builder: (context, state){
              var cubit = LetterReplyCubit.get(context);
              return Form(
                key: formKey,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
                    title: Row(
                      children: [
                        Text(
                            AppStrings.replyOnLetterWithNumber.tr(),
                            style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: AppSize.s18,fontFamily: FontConstants.family,fontWeight: FontWeightManager.regular)
                        ),
                        MouseRegion(
                          cursor: MaterialStateMouseCursor.clickable,
                          onEnter: (_) => cubit.changeLetterNumberColor(Colors.blue),
                          onExit: (_) => cubit.changeLetterNumberColor(ColorManager.goldColor),
                          child: GestureDetector(
                            onTap: () => scaleDialog(context, true, alterLetterDialog(context, cubit)),
                            child: Text(
                                letterModel.letterNumber,
                                style: TextStyle(color: cubit.letterNumberColor, fontSize: AppSize.s18,fontFamily: FontConstants.family,fontWeight: FontWeightManager.bold, decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: MouseRegion(
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
                            Icons.done,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          const SizedBox(width: AppSize.s8),
                          Text(
                            AppStrings.replyOnLetter.tr(),
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
                    cubit.tokenHandle();
                    if(formKey.currentState!.validate()){
                      if(cubit.selectedActionDepartmentsList.isEmpty){
                        ReusableComponents.showMToast(context, AppStrings.departmentsRequired.tr(), TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
                        return;
                      }
                      cubit.createLetter(letterModel.letterId);
                    }
                  },
                      borderRadius: BorderRadius.circular(AppSize.s8),
                      overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  body: Padding(
                    padding: const EdgeInsets.all(AppSize.s16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme
                                    .of(context)
                                    .primaryColorDark
                                    .withOpacity(0.3)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.s6)),
                                color: Colors.transparent,
                              ),
                              constraints: const BoxConstraints(maxWidth: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.s8, vertical: AppSize.s8),
                              child: Row(
                                children: [
                                  Icon(Icons.group_add_rounded, color: Theme
                                      .of(context)
                                      .primaryColorDark, size: AppSize.s22,),
                                  const SizedBox(width: AppSize.s8,),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppStrings.addDepartments.tr(),
                                        style: TextStyle(color: Theme
                                            .of(context)
                                            .primaryColorDark,
                                            fontSize: AppSize.s14,
                                            fontFamily: FontConstants.family,
                                            fontWeight: FontWeightManager
                                                .regular),),
                                    ),
                                  )
                                ],
                              ),
                            ).ripple(() {
                              scaleDialog(context, true, departmentDialog(
                                  context, "Letter Reply", cubit));
                            },
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.s6)),
                                overlayColor: MaterialStateColor.resolveWith((
                                    states) => Theme.of(context).primaryColorDark.withOpacity(0.15))),
                            const SizedBox(width: AppSize.s8,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme
                                    .of(context)
                                    .primaryColorDark
                                    .withOpacity(0.3)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.s6)),
                                color: Colors.transparent,
                              ),
                              constraints: const BoxConstraints(maxWidth: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.s8, vertical: AppSize.s8),
                              child: Row(
                                children: [
                                  Icon(Icons.tag_rounded, color: Theme
                                      .of(context)
                                      .primaryColorDark, size: AppSize.s22,),
                                  const SizedBox(width: AppSize.s8,),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(AppStrings.addTags.tr(),
                                        style: TextStyle(color: Theme
                                            .of(context)
                                            .primaryColorDark,
                                            fontSize: AppSize.s14,
                                            fontFamily: FontConstants.family,
                                            fontWeight: FontWeightManager
                                                .bold),),
                                    ),
                                  )
                                ],
                              ),
                            ).ripple(() {
                              scaleDialog(context, true,
                                  tagsDialog(context, "Letter Reply", cubit));
                            },
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.s6)),
                                overlayColor: MaterialStateColor.resolveWith((
                                    states) =>
                                    Theme
                                        .of(context)
                                        .primaryColorDark
                                        .withOpacity(0.15))),
                            const SizedBox(width: AppSize.s8,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme
                                    .of(context)
                                    .primaryColorDark
                                    .withOpacity(0.3)),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.s6)),
                                color: Colors.transparent,
                              ),
                              constraints: const BoxConstraints(maxWidth: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSize.s8, vertical: AppSize.s8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.file_upload_outlined, color: Theme
                                      .of(context)
                                      .primaryColorDark, size: AppSize.s22,),
                                  const SizedBox(width: AppSize.s8,),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(AppStrings.pickFiles.tr(),
                                        style: TextStyle(color: Theme
                                            .of(context)
                                            .primaryColorDark,
                                            fontSize: AppSize.s14,
                                            fontFamily: FontConstants.family,
                                            fontWeight: FontWeightManager
                                                .bold),),
                                    ),
                                  )
                                ],
                              ),
                            ).ripple(() {
                              cubit.pickFile();
                            },
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(AppSize.s6)),
                                overlayColor: MaterialStateColor.resolveWith((
                                    states) =>
                                    Theme
                                        .of(context)
                                        .primaryColorDark
                                        .withOpacity(0.15))),
                            const Spacer(),
                            if(cubit.isSecretary())
                              Row(
                                children: [
                                  Text(AppStrings.letterDirection.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: AppSize.s16,fontFamily: FontConstants.family),),
                                  const SizedBox(width: AppSize.s8,),
                                  SizedBox(height: AppSize.s35, child: SelectDirectionComponent(fromRoute: "Letter Reply", cubit: cubit)),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSize.s16,),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cubit.selectedActionDepartmentsList.isNotEmpty ? selectedActionDepartmentsWidget(context, cubit) : const SizedBox.shrink(),
                            SizedBox(width: cubit.selectedKnowDepartmentsList.isNotEmpty ? AppSize.s16 : AppSize.s0,),
                            cubit.selectedKnowDepartmentsList.isNotEmpty ? selectedKnowDepartmentsWidget(context, cubit) : const SizedBox.shrink(),
                            SizedBox(width: cubit.selectedTagsList.isNotEmpty ? AppSize.s16 : AppSize.s0,),
                            cubit.selectedTagsList.isNotEmpty ? Align(alignment: Alignment.centerLeft, child: tagsWidget(context, "Letter Reply", cubit)) : const SizedBox.shrink(),
                            SizedBox(width: cubit.pickedFiles.isNotEmpty ? AppSize.s16 : AppSize.s0,),
                            cubit.pickedFiles.isNotEmpty ? SizedBox(
                              width: 350,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSize.s6),
                                  color: Theme.of(context).splashColor,
                                ),
                                height: 160,
                                padding: const EdgeInsets.symmetric(horizontal: AppSize.s12),
                                child: Column(
                                  children: [
                                    const SizedBox(height: AppSize.s8,),
                                    Text(AppStrings.attachments.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
                                    const SizedBox(height: AppSize.s8,),
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          // final uniqueKey = UniqueKey();
                                          return Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.circular(AppSize.s8),
                                                      border: Border.all(color: ColorManager.goldColor,width: 0.8),
                                                    ),
                                                    padding: const EdgeInsets.all(AppSize.s4),
                                                    child: MPdfThumbnail.fromFile(cubit.pickedFiles[index].path!,
                                                      currentPage: 1,
                                                      key: Key(cubit.pickedFiles[index].name),
                                                      height: 90,
                                                      loadingIndicator: Center(child: CircularProgressIndicator(strokeWidth: AppSize.s0_8,color: ColorManager.goldColor,),),backgroundColor: Colors.transparent,),
                                                  ).ripple((){
                                                    scaleDialog(
                                                        context,
                                                        true,
                                                        alterPdfDialog(context,cubit, PlatformFile(path: cubit.pickedFiles[index].path, name: cubit.pickedFiles[index].name, size: cubit.pickedFiles[index].size)));
                                                  },
                                                    borderRadius: BorderRadius.circular(AppSize.s8),
                                                    overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2)),
                                                  ),
                                                  Positioned(
                                                    right: AppSize.s6,
                                                    top: AppSize.s6,
                                                    child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red), padding: const EdgeInsets.all(AppSize.s4) , child: Icon(Icons.close_rounded, color: Theme.of(context).primaryColorDark, size: AppSize.s12,))
                                                        .ripple((){cubit.deleteFile(cubit.pickedFiles[index]);}, borderRadius: BorderRadius.circular(AppSize.s5),
                                                        overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: AppSize.s8,)
                                            ],
                                          );
                                        },
                                        itemCount: cubit.pickedFiles.length,
                                      ),
                                    ),
                                    const SizedBox(height: AppSize.s8,),
                                  ],
                                ),
                              ),
                            ) : const SizedBox.shrink(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
        )
    );
  }
  Widget alterPdfDialog(BuildContext context, LetterReplyCubit cubit, PlatformFile file) {
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
  Widget letterItem(BuildContext context, LetterReplyCubit cubit, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSize.s8),
      child: Material(
        color: Theme.of(context).splashColor,
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
              color: ColorManager.goldColor.withOpacity(0.2)
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSize.s12, vertical: AppSize.s6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  cubit.departmentsList[index].departmentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s8,),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: cubit.isDepartmentFoundAsAction(cubit.departmentsList[index]),
                      activeColor: Theme.of(context).primaryColorDark,
                      checkColor: ColorManager.goldColor,
                      onChanged: (bool? value) {
                        cubit.addDepartmentToAction(cubit.departmentsList[index]);
                      },
                    ),
                  ),
                  Text(
                    AppStrings.action.tr(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: FontConstants.family,
                        fontSize: AppSize.s16,
                        fontWeight: FontWeightManager.bold),
                  ),
                ],
              ),
              const SizedBox(width: AppSize.s8,),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: cubit.isDepartmentFoundAsKnow(cubit.departmentsList[index]),
                      activeColor: Theme.of(context).primaryColorDark,
                      checkColor: ColorManager.goldColor,
                      onChanged: (bool? value) {
                        cubit.addDepartmentToKnow(cubit.departmentsList[index]);
                      },
                    ),
                  ),
                  Text(
                    AppStrings.know.tr(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: FontConstants.family,
                        fontSize: AppSize.s16,
                        fontWeight: FontWeightManager.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget alterLetterDialog(BuildContext context, LetterReplyCubit cubit) {
    bool _isClosing = false;
    return Directionality(
      textDirection: AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: AlertDialog(
        // <-- SEE HERE
          title: Text(
            AppStrings.replyOnLetter.tr(),
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
              width: MediaQuery.sizeOf(context).width * 0.80,
              child: LetterDetailsScreen(letterModel: letterModel, fromReplyScreen: true,)),
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
