import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/core/service/service_locator.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_states.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'package:v_chat_mention_controller/v_chat_mention_controller.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/pdf_viewer.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';
import 'dart:ui' as ui;
import '../../../utils/components.dart';
import '../../widget/custom_thumbnail.dart';
import '../../widget/department_widget.dart';
import '../../widget/selected_action_departments_widget.dart';
import '../../widget/tags_widget.dart';

class NewArchivedLetterScreen extends StatelessWidget {
  NewArchivedLetterScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
        sl<ArchivedLettersCubit>()..initController()..getTags()..getSectors()..getAllDirections(),
        child: BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
          listener: (context, state) {
            if(state is ArchivedLettersSuccessCreateLetter){
              Navigator.pop(context);
              ReusableComponents.showMToast(context, AppStrings.letterSentSuccessful.tr(), TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
            }
            if(state is ArchivedLettersLoadingCreateLetter){
              showDialog(context: context, barrierDismissible: true, barrierLabel: '', builder: (context) => BlurryProgressDialog(title: AppStrings.loading.tr()));
            }
            if(state is ArchivedLettersErrorCreateLetter){
              ReusableComponents.showMToast(context, state.error, TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
            }
          },
          builder: (context, state) {
            var cubit = ArchivedLettersCubit.get(context);
            return FadeIn(
              duration: const Duration(milliseconds: 1500),
              child: Form(
                key: formKey,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    iconTheme: IconThemeData(color: Theme
                        .of(context)
                        .primaryColorDark),
                    title: Text(
                        AppStrings.archiveLetter.tr(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: AppSize.s18,
                            fontFamily: FontConstants.family,
                            fontWeight: FontWeightManager.regular)
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
                            Icons.archive_outlined,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          const SizedBox(width: AppSize.s8),
                          Text(
                            AppStrings.archiveLetter.tr(),
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
                    if (formKey.currentState!.validate()) {
                      //cubit.createLetter();
                      if(cubit.selectedOption != AppStrings.localLetter.tr()){
                        cubit.createArchivedLetter();
                      }else{
                        cubit.createForMeLetter();
                      }
                    }
                  },
                      borderRadius: BorderRadius.circular(AppSize.s8),
                      overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  body: Padding(
                    padding: const EdgeInsets.all(AppSize.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  context, "Archive Letter", cubit));
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
                                  tagsDialog(context, "Archive Letter", cubit));
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
                            if(cubit.selectedOption == AppStrings.sendToOutside.tr())
                            Row(
                              children: [
                                const SizedBox(width: AppSize.s8,),
                                Text(AppStrings.letterDirection.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark,fontSize: AppSize.s16,fontFamily: FontConstants.family),),
                                const SizedBox(width: AppSize.s8,),
                                SizedBox(height: AppSize.s35, child: SelectDirectionComponent(fromRoute: "Archive Letter", cubit: cubit)),
                              ],
                            ),
                            const Spacer(),
                            SizedBox(height: AppSize.s35 , child: SelectLetterTypeComponent(cubit: cubit)),
                            const SizedBox(width: AppSize.s8,),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSize.s6),
                                    border: Border.all(color: Theme.of(context).primaryColorDark.withOpacity(0.3)),
                                    color: Colors.transparent
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s8,
                                    vertical: AppSize.s8),
                                child: Text(
                                  cubit.formatDate(cubit.oldArchiveDate.toString()),
                                  style: TextStyle(color: Theme.of(context).primaryColorDark,
                                      fontSize: AppSize.s16,
                                      fontFamily: FontConstants.family),
                                )).ripple(() async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2010),
                                  lastDate: DateTime.now());
                              if (pickedDate != null) {
                                cubit.changeCalendarDate(pickedDate);
                              }
                            },
                                borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                                overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(0.15)))
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
                                borderColor: Theme
                                    .of(context)
                                    .primaryColorDark,
                                controller: cubit.letterAboutController,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return AppStrings.letterAboutRequired.tr();
                                  }
                                  if (value.length < 5) {
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
                                borderColor: Theme
                                    .of(context)
                                    .primaryColorDark,
                                controller: cubit.letterNumberController,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return AppStrings.letterNumberRequired.tr();
                                  }
                                  if (value.length < 5) {
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
                          controller: cubit.controller,
                          maxLines: 5,
                          contentPadding: const EdgeInsets.all(AppSize.s12),
                          validate: (value) {
                            if (value!.isEmpty) {
                              return AppStrings.letterContentRequired.tr();
                            }
                            if (value.length < 5) {
                              return AppStrings.lengthShorter.tr();
                            }
                          },
                          onChanged: (String? value) {},
                        ),
                        Visibility(
                          visible: cubit.isSearchCanView,
                          child: SizedBox(
                            height: 200,
                            child: ListView(
                              shrinkWrap: true,
                              children: cubit.filteredTags
                                  .map(
                                    (e) => ListTile(
                                  onTap: () {
                                    cubit.controller.addMention(
                                      MentionData(
                                        id: "id -> ${e.tagId}",
                                        display: e.tagName,
                                      ),
                                    );
                                  },
                                  title: Text(e.tagName,
                                    style: TextStyle(color: ColorManager.goldColor,
                                        fontFamily: FontConstants.family,
                                        fontSize: AppSize.s16,
                                        fontWeight: FontWeightManager.bold),),
                                ),
                              ).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSize.s16,),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (cubit.selectedActionDepartmentsList.isNotEmpty && cubit.isOldArchivedLetter) Expanded(
                                  child: selectedActionDepartmentsWidget(
                                      context, cubit)) else const SizedBox.shrink(),
                              SizedBox(width: (cubit.selectedKnowDepartmentsList.isNotEmpty && cubit.isOldArchivedLetter) ? AppSize.s16 : AppSize.s0,),
                              if (cubit.selectedKnowDepartmentsList.isNotEmpty && cubit.isOldArchivedLetter) Expanded(
                                  child: selectedKnowDepartmentsWidget(
                                      context, cubit)) else
                                const SizedBox.shrink(),
                              SizedBox(width: cubit.selectedTagsList.isNotEmpty
                                  ? AppSize.s16
                                  : AppSize.s0,),
                              cubit.selectedTagsList.isNotEmpty
                                  ? Expanded(child: tagsWidget(
                                  context, "Archive Letter", cubit))
                                  : const SizedBox.shrink(),
                              SizedBox(
                                width: cubit.pickedFiles.isNotEmpty ? AppSize
                                    .s16 : AppSize.s0,),
                              cubit.pickedFiles.isNotEmpty ? Expanded(
                                child: SizedBox(
                                  width: 350,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSize.s6),
                                      color: Theme
                                          .of(context)
                                          .splashColor,
                                    ),
                                    height: 160,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.s12),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: AppSize.s8,),
                                        Text(AppStrings.attachments.tr(),
                                          style: TextStyle(color: Theme
                                              .of(context)
                                              .primaryColorDark,
                                              fontFamily: FontConstants.family,
                                              fontSize: AppSize.s16,
                                              fontWeight: FontWeightManager
                                                  .bold),),
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
                                                          color: Colors
                                                              .transparent,
                                                          borderRadius: BorderRadius
                                                              .circular(
                                                              AppSize.s8),
                                                          border: Border.all(
                                                              color: ColorManager
                                                                  .goldColor,
                                                              width: 0.8),
                                                        ),
                                                        padding: const EdgeInsets
                                                            .all(AppSize.s4),
                                                        child: MPdfThumbnail
                                                            .fromFile(cubit
                                                            .pickedFiles[index]
                                                            .path!,
                                                          currentPage: 1,
                                                          key: Key(cubit
                                                              .pickedFiles[index]
                                                              .name),
                                                          height: 90,
                                                          loadingIndicator: Center(
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: AppSize
                                                                  .s0_8,
                                                              color: ColorManager
                                                                  .goldColor,),),
                                                          backgroundColor: Colors
                                                              .transparent,),
                                                      ).ripple(() {
                                                        scaleDialog(
                                                            context,
                                                            true,
                                                            alterPdfDialog(
                                                                context, cubit,
                                                                PlatformFile(
                                                                    path: cubit
                                                                        .pickedFiles[index]
                                                                        .path,
                                                                    name: cubit
                                                                        .pickedFiles[index]
                                                                        .name,
                                                                    size: cubit
                                                                        .pickedFiles[index]
                                                                        .size)));
                                                      },
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            AppSize.s8),
                                                        overlayColor: MaterialStateColor
                                                            .resolveWith((
                                                            states) =>
                                                            Theme
                                                                .of(context)
                                                                .primaryColorDark
                                                                .withOpacity(
                                                                AppSize.s0_2)),
                                                      ),
                                                      Positioned(
                                                        right: AppSize.s6,
                                                        top: AppSize.s6,
                                                        child: Container(
                                                            decoration: const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .red),
                                                            padding: const EdgeInsets
                                                                .all(
                                                                AppSize.s4),
                                                            child: Icon(Icons
                                                                .close_rounded,
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColorDark,
                                                              size: AppSize
                                                                  .s12,))
                                                            .ripple(() {
                                                          cubit.deleteFile(cubit
                                                              .pickedFiles[index]);
                                                        },
                                                            borderRadius: BorderRadius
                                                                .circular(
                                                                AppSize.s5),
                                                            overlayColor: MaterialStateColor
                                                                .resolveWith((
                                                                states) =>
                                                                Theme
                                                                    .of(context)
                                                                    .primaryColorDark
                                                                    .withOpacity(
                                                                    AppSize
                                                                        .s0_2))),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: AppSize.s8,)
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
                                ),
                              ) : const SizedBox.shrink(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget alterPdfDialog(BuildContext context, ArchivedLettersCubit cubit,
      PlatformFile file) {
    bool _isClosing = false;
    return Directionality(
      textDirection: AppConstants.isArabic() ? ui.TextDirection.rtl : ui
          .TextDirection.ltr,
      child: AlertDialog(
        // <-- SEE HERE
          title: Text(
            file.name,
            style: TextStyle(
                color: Theme
                    .of(context)
                    .primaryColorDark,
                fontSize: AppSize.s16,
                fontWeight: FontWeightManager.bold,
                fontFamily: FontConstants.family),
          ),
          backgroundColor: Theme
              .of(context)
              .primaryColorLight,
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
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) =>
                      ColorManager.goldColor.withOpacity(0.4))),
              child: Text(
                AppStrings.print.tr(),
                style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    fontWeight: FontWeightManager.heavy,
                    color: Theme
                        .of(context)
                        .primaryColorDark),
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
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) =>
                      ColorManager.goldColor.withOpacity(0.4))),
              child: Text(
                AppStrings.exit.tr(),
                style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    fontWeight: FontWeightManager.heavy,
                    color: Theme
                        .of(context)
                        .primaryColorDark),
                maxLines: AppSize.s1.toInt(),
              ),
            ),
          ],
          buttonPadding: const EdgeInsets.all(AppSize.s10)),
    );
  }

  void insertMention(String suggestion, ArchivedLettersCubit cubit) {
    final currentText = cubit.letterContentController.text;
    final mentionText = '@${suggestion
        .toLowerCase()} '; // Modify as per your requirement
    final mentionIndex = currentText.lastIndexOf('@');
    final cursorPosition = mentionIndex + mentionText.length;

    final modifiedText = StringBuffer()
      ..write(currentText.substring(0, mentionIndex))..write(
          mentionText)..write(currentText.substring(mentionIndex + 1));
    cubit.updateLetterContent(modifiedText.toString(), cursorPosition);
    cubit.changeShowSuggestions(false);
  }
}
