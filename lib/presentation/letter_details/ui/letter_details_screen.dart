import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:foe_archive/presentation/letter_details/bloc/letter_details_cubit.dart';
import 'package:foe_archive/presentation/letter_details/bloc/letter_details_states.dart';
import 'package:foe_archive/presentation/letter_details/helper/letter_details_args.dart';
import 'package:foe_archive/presentation/widget/custom_thumbnail.dart';
import 'package:foe_archive/presentation/widget/loading_indicator.dart';
import 'package:foe_archive/resources/color_manager.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'package:foe_archive/resources/font_manager.dart';
import 'package:foe_archive/resources/values_manager.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:ui' as ui;
import '../../../core/service/service_locator.dart';
import '../../../resources/constants_manager.dart';
import '../../../resources/pdf_viewer.dart';
import '../../../resources/routes_manager.dart';
import '../../../resources/strings_manager.dart';
import '../../../utils/components.dart';

class LetterDetailsScreen extends StatelessWidget {
  LetterDetailsScreen(
      {Key? key, required this.letterModel, required this.letterType, required this.fromReplyScreen}) : super(key: key);
  LetterModel letterModel;
  int letterType;
  bool fromReplyScreen;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LetterDetailsCubit>()..getData(letterModel.letterId),
      child: BlocConsumer<LetterDetailsCubit, LetterDetailsStates>(
        listener: (context, state) {
          if(state is LetterDetailsSuccessfulDeleteLetter){
            Navigator.pop(context);
            Navigator.pop(context);
          }
          if(state is LetterDetailsErrorDeleteLetter){
            Navigator.pop(context);
            ReusableComponents.showMToast(context, AppStrings.cannotDeleteLetterHasReply.tr(), TextStyle(color: Theme.of(context).primaryColorDark,fontFamily: FontConstants.family,fontSize: AppSize.s16), ColorManager.goldColor.withOpacity(0.3));
          }

        },
        builder: (context, state) {
          var cubit = LetterDetailsCubit.get(context);
          if (cubit.letterModel == null) {
            return Scaffold(
              appBar: fromReplyScreen
                  ? AppBar(toolbarHeight: 0)
                  : AppBar(
                      automaticallyImplyLeading: true,
                      centerTitle: true,
                      iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
                      title: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: AppStrings.letterDetails.tr(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: AppSize.s18,
                                  fontFamily: FontConstants.family,
                                  fontWeight: FontWeightManager.regular)),
                          TextSpan(
                              text: cubit.letterModel?.letterNumber,
                              style: TextStyle(
                                  color: ColorManager.goldColor,
                                  fontSize: AppSize.s18,
                                  fontFamily: FontConstants.family,
                                  fontWeight: FontWeightManager.bold)),
                        ]),
                      ),
                    ),
              backgroundColor: Theme.of(context).primaryColorLight,
              body: Center(
                child: loadingIndicator(),
              ),
            );
          } else {
            return Scaffold(
              appBar: fromReplyScreen
                  ? AppBar(toolbarHeight: 0)
                  : AppBar(
                      automaticallyImplyLeading: true,
                      iconTheme: IconThemeData(
                          color: Theme.of(context).primaryColorDark),
                      title: Row(
                        children: [
                          RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: AppStrings.letterDetails.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: AppSize.s18,
                                      fontFamily: FontConstants.family,
                                      fontWeight: FontWeightManager.regular)),
                              TextSpan(
                                  text: cubit.letterModel?.letterNumber,
                                  style: TextStyle(
                                      color: ColorManager.goldColor,
                                      fontSize: AppSize.s18,
                                      fontFamily: FontConstants.family,
                                      fontWeight: FontWeightManager.bold)),
                            ]),
                          ),
                          const Spacer(),
                          if(cubit.isLetterMine(letterModel))
                            PopupMenuButton<int>(
                            color: Theme.of(context).splashColor,
                            icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).primaryColorDark,),
                            onSelected: (item){
                              if(item == 0){
                               Navigator.pushNamed(
                                   context, RoutesManager.updateLetterRoute,
                                   arguments: UpdateLetterArgs(cubit.letterModel!, cubit.pickedFiles, cubit.selectedActionDepartmentsList, cubit.selectedKnowDepartmentsList)).then((value){
                                 cubit.getLetter(letterModel.letterId);
                               });
                              }else{
                                scaleDialog(context, true, alterDeleteDialog(context, cubit));
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<int>(value: 0, child: Text(AppStrings.updateLetter.tr(), style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: FontConstants.family,
                                  fontSize: AppSize.s14,
                                  fontWeight: FontWeightManager.bold))),
                              PopupMenuItem<int>(value: 1, child: Text(AppStrings.deleteLetter.tr(), style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontFamily: FontConstants.family,
                                  fontSize: AppSize.s14,
                                  fontWeight: FontWeightManager.bold))),
                            ],
                          ),
                        ],
                      ),
                    ),
              backgroundColor: Theme.of(context).primaryColorLight,
              floatingActionButton:
                  fromReplyScreen || !cubit.canReply(cubit.letterModel!)
                      ? const SizedBox.shrink()
                      : MouseRegion(
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
                                  Ionicons.caret_forward,
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
                          if (cubit.canReply(cubit.letterModel!)) {
                            Navigator.pushNamed(
                                context, RoutesManager.letterReplyRoute,
                                arguments: cubit.letterModel!);
                          } else {}
                        },
                          borderRadius: BorderRadius.circular(AppSize.s8),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(AppSize.s0_2))),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).splashColor,
                              borderRadius: BorderRadius.circular(AppSize.s8)),
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppStrings.letterDirection.tr(),
                                style: TextStyle(
                                    color: ColorManager.goldColor,
                                    fontSize: AppSize.s18,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(
                                height: AppSize.s12,
                              ),
                              Text(
                                cubit.letterModel!.directionName,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: AppSize.s16,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.regular),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSize.s16,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).splashColor,
                              borderRadius: BorderRadius.circular(AppSize.s8)),
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppStrings.letterDate.tr(),
                                style: TextStyle(
                                    color: ColorManager.goldColor,
                                    fontSize: AppSize.s18,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(
                                height: AppSize.s12,
                              ),
                              Text(
                                cubit.formatDate(
                                    cubit.letterModel!.letterDate ??
                                        cubit.letterModel!.updatedAt!),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: AppSize.s16,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.regular),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSize.s16,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).splashColor,
                              borderRadius: BorderRadius.circular(AppSize.s8)),
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppStrings.attachments.tr(),
                                style: TextStyle(
                                    color: ColorManager.goldColor,
                                    fontSize: AppSize.s18,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(
                                height: AppSize.s12,
                              ),
                              Text(
                                cubit.letterAttachmentsToString(
                                    cubit.letterModel!),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: AppSize.s16,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.regular),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).splashColor,
                              borderRadius: BorderRadius.circular(AppSize.s8)),
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppStrings.letterAbout.tr(),
                                style: TextStyle(
                                    color: ColorManager.goldColor,
                                    fontSize: AppSize.s18,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(
                                height: AppSize.s12,
                              ),
                              Text(
                                cubit.letterModel!.letterAbout,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: AppSize.s16,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.regular),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSize.s16,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).splashColor,
                              borderRadius: BorderRadius.circular(AppSize.s8)),
                          margin: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s12, horizontal: AppSize.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppStrings.letterContent.tr(),
                                style: TextStyle(
                                    color: ColorManager.goldColor,
                                    fontSize: AppSize.s18,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(
                                height: AppSize.s12,
                              ),
                              Text(
                                cubit.letterModel!.letterContent,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark,
                                    fontSize: AppSize.s16,
                                    fontFamily: FontConstants.family,
                                    fontWeight: FontWeightManager.regular),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSize.s12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: AppSize.s16,
                      ),
                      cubit.selectedActionDepartmentsList.isNotEmpty
                          ? selectedActionDepartmentsWidget(context, cubit)
                          : const SizedBox.shrink(),
                      SizedBox(
                        width: cubit.selectedKnowDepartmentsList.isNotEmpty
                            ? AppSize.s16
                            : AppSize.s0,
                      ),
                      cubit.selectedKnowDepartmentsList.isNotEmpty
                          ? selectedKnowDepartmentsWidget(context, cubit)
                          : const SizedBox.shrink(),
                      SizedBox(
                        width: cubit.letterModel!.filesList != null &&
                                cubit.letterModel!.filesList!.isNotEmpty
                            ? AppSize.s16
                            : AppSize.s0,
                      ),
                      cubit.letterModel!.filesList != null && cubit.letterModel!.filesList!.isNotEmpty
                          ? SizedBox(
                              width: 350,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.s6),
                                  color: Theme.of(context).splashColor,
                                ),
                                height: 160,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.s12),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: AppSize.s8,
                                    ),
                                    Text(
                                      AppStrings.attachments.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontFamily: FontConstants.family,
                                          fontSize: AppSize.s16,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s8,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppSize.s8),
                                              border: Border.all(
                                                  color: ColorManager.goldColor,
                                                  width: 0.8),
                                            ),
                                            padding: const EdgeInsets.all(
                                                AppSize.s4),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: AppSize.s4),
                                            child: MPdfThumbnail.fromFile(
                                              cubit.letterModel!
                                                  .filesList![index].filePath,
                                              currentPage: 1,
                                              key: Key(cubit.letterModel!
                                                  .filesList![index].fileName),
                                              height: 90,
                                              loadingIndicator: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: AppSize.s0_8,
                                                  color: ColorManager.goldColor,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ).ripple(
                                            () {
                                              scaleDialog(
                                                  context,
                                                  true,
                                                  alterPdfDialog(
                                                      context,
                                                      cubit,
                                                      PlatformFile(
                                                          path: cubit
                                                              .letterModel!
                                                              .filesList![index]
                                                              .filePath,
                                                          name: cubit
                                                              .letterModel!
                                                              .filesList![index]
                                                              .fileName,
                                                          size: 0)));
                                            },
                                            borderRadius: BorderRadius.circular(
                                                AppSize.s8),
                                            overlayColor:
                                                MaterialStateColor.resolveWith(
                                                    (states) =>
                                                        Theme.of(context)
                                                            .primaryColorDark
                                                            .withOpacity(
                                                                AppSize.s0_2)),
                                          );
                                        },
                                        itemCount: cubit
                                            .letterModel!.filesList!.length,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSize.s8,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  if (cubit.letterModel!.repliesLetters != null) const Spacer(),
                  cubit.letterModel!.repliesLetters != null && cubit.letterModel!.repliesLetters!.isNotEmpty
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).splashColor,
                                borderRadius:
                                    BorderRadius.circular(AppSize.s8)),
                            margin: const EdgeInsets.symmetric(
                                vertical: AppSize.s12, horizontal: AppSize.s16),
                            padding: const EdgeInsets.symmetric(
                                vertical: AppSize.s12, horizontal: AppSize.s16),
                            child: Column(
                              children: [
                                Text(
                                  AppStrings.letterReplies.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark,
                                      fontSize: AppSize.s18,
                                      fontFamily: FontConstants.family,
                                      fontWeight: FontWeightManager.bold),
                                ),
                                const SizedBox(
                                  height: AppSize.s12,
                                ),
                                MouseRegion(
                                  cursor: MaterialStateMouseCursor.clickable,
                                  onEnter: (_) => cubit
                                      .changeLetterNumberColor(Colors.blue),
                                  onExit: (_) => cubit.changeLetterNumberColor(
                                      ColorManager.goldColor),
                                  child: GestureDetector(
                                    onTap: () => scaleDialog(context, true,
                                        alterLetterDialog(context, cubit)),
                                    child: Text(
                                      cubit.letterModel!.repliesLetters![0]
                                          .letterNumber
                                          .toString(),
                                      style: TextStyle(
                                          color: cubit.letterNumberColor,
                                          fontSize: AppSize.s18,
                                          fontFamily: FontConstants.family,
                                          fontWeight: FontWeightManager.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget alterLetterDialog(BuildContext context, LetterDetailsCubit cubit) {
    bool _isClosing = false;
    return Directionality(
      textDirection:
          AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
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
              child: LetterDetailsScreen(
                letterModel: cubit.letterModel!.repliesLetters![0],
                letterType: letterType,
                fromReplyScreen: true,
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
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ColorManager.goldColor.withOpacity(0.4))),
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
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ColorManager.goldColor.withOpacity(0.4))),
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

  Widget selectedKnowDepartmentsWidget(BuildContext context, LetterDetailsCubit cubit) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s6),
        color: Theme.of(context).splashColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppSize.s8,
          ),
          Text(
            AppStrings.requiredKnowFromDepartments.tr(),
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontFamily: FontConstants.family,
                fontSize: AppSize.s16,
                fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(
            height: AppSize.s4,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s6),
                    color: ColorManager.goldColor.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.s8, vertical: AppSize.s8),
                  margin: const EdgeInsets.all(AppSize.s6),
                  child: Text(
                    '${cubit.selectedKnowDepartmentsList[index]!.sectorName} - ${cubit.selectedKnowDepartmentsList[index]!.departmentName}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontFamily: FontConstants.family,
                        fontSize: AppSize.s14,
                        fontWeight: FontWeightManager.bold),
                  ),
                );
              },
              itemCount: cubit.selectedKnowDepartmentsList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget selectedActionDepartmentsWidget(
      BuildContext context, LetterDetailsCubit cubit) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s6),
        color: Theme.of(context).splashColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: AppSize.s8,
          ),
          Text(
            AppStrings.requiredActionFromDepartments.tr(),
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontFamily: FontConstants.family,
                fontSize: AppSize.s16,
                fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(
            height: AppSize.s4,
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s6),
                  color: ColorManager.goldColor.withOpacity(0.2),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.s8, vertical: AppSize.s8),
                margin: const EdgeInsets.all(AppSize.s6),
                child: Text(
                  '${cubit.selectedActionDepartmentsList[index]!.sectorName} - ${cubit.selectedActionDepartmentsList[index]!.departmentName}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s14,
                      fontWeight: FontWeightManager.bold),
                ),
              );
            },
            itemCount: cubit.selectedActionDepartmentsList.length,
          ),
        ],
      ),
    );
  }

  Widget alterPdfDialog(
      BuildContext context, LetterDetailsCubit cubit, PlatformFile file) {
    bool _isClosing = false;
    return Directionality(
      textDirection:
          AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
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
                cubit.openFileInBrowser(file.path!);
                if (!_isClosing) {
                  _isClosing = true;
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ColorManager.goldColor.withOpacity(0.4))),
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
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ColorManager.goldColor.withOpacity(0.4))),
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
  Widget alterDeleteDialog(BuildContext context, LetterDetailsCubit cubit) {
    bool isClosing = false;

    return Directionality(
      textDirection:
      AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: AlertDialog(
        // <-- SEE HERE
          title: Text(
            AppStrings.warning.tr(),
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
              .splashColor,
          titlePadding: const EdgeInsets.only(
              top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
          contentPadding: const EdgeInsets.all(AppSize.s12),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppStrings.areYouSureDeleteThisLetter.tr(),
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .primaryColorDark,
                      fontSize: AppSize.s14,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: FontConstants.family),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                cubit.deleteLetter(letterModel,letterType);
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                          (states) => ColorManager.goldColor.withOpacity(0.4))),
              child: Text(
                AppStrings.ok.tr(),
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
                if (!isClosing) {
                  isClosing = true;
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                          (states) => ColorManager.goldColor.withOpacity(0.4))),
              child: Text(
                AppStrings.cancel.tr(),
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

}
