import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_states.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_states.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_cubit.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_states.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'dart:ui' as ui;
import '../../resources/color_manager.dart';
import '../../resources/constants_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../../utils/components.dart';
import '../letter_reply/bloc/letter_reply_cubit.dart';
import '../letter_reply/bloc/letter_reply_states.dart';
import '../new_letter/bloc/new_letter_cubit.dart';

Widget tagsDialog(BuildContext context, String fromRoute, dynamic cubit) {
  bool isClosing = false;
  switch(fromRoute){
    case "Letter Reply":
      cubit = cubit as LetterReplyCubit;
      return BlocConsumer<LetterReplyCubit, LetterReplyStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Directionality(
            textDirection:
            AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: AlertDialog(
              // <-- SEE HERE
                title: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: AppSize.s18,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: FontConstants.family),
                ),
                backgroundColor: Theme.of(context).splashColor,
                titlePadding: const EdgeInsets.only(top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
                contentPadding: const EdgeInsets.all(AppSize.s12),
                content: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 3,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SelectTagsComponent(fromRoute: "Letter Reply", cubit: cubit,)
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (!isClosing) {
                        isClosing = true;
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
                    child: Text(
                      AppStrings.ok.tr(),
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
        },
      );
    case "Archive Letter":
      cubit = cubit as ArchivedLettersCubit;
      return BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Directionality(
            textDirection:
            AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: AlertDialog(
              // <-- SEE HERE
                title: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: AppSize.s18,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: FontConstants.family),
                ),
                backgroundColor: Theme.of(context).splashColor,
                titlePadding: const EdgeInsets.only(top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
                contentPadding: const EdgeInsets.all(AppSize.s12),
                content: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 3,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SelectTagsComponent(fromRoute: "Archive Letter", cubit: cubit,)
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (!isClosing) {
                        isClosing = true;
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
                    child: Text(
                      AppStrings.ok.tr(),
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
        },
      );
    case "Update Letter":
      cubit = cubit as UpdateLetterCubit;
      return BlocConsumer<UpdateLetterCubit, UpdateLetterStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Directionality(
            textDirection:
            AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: AlertDialog(
              // <-- SEE HERE
                title: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: AppSize.s18,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: FontConstants.family),
                ),
                backgroundColor: Theme.of(context).splashColor,
                titlePadding: const EdgeInsets.only(top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
                contentPadding: const EdgeInsets.all(AppSize.s12),
                content: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 3,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SelectTagsComponent(fromRoute: "Update Letter", cubit: cubit,)
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (!isClosing) {
                        isClosing = true;
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
                    child: Text(
                      AppStrings.ok.tr(),
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
        },
      );
    case "New Letter":
    default:
      cubit = cubit as NewLetterCubit;
      return BlocConsumer<NewLetterCubit, NewLetterStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Directionality(
            textDirection:
            AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: AlertDialog(
              // <-- SEE HERE
                title: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: AppSize.s18,
                      fontWeight: FontWeightManager.bold,
                      fontFamily: FontConstants.family),
                ),
                backgroundColor: Theme.of(context).splashColor,
                titlePadding: const EdgeInsets.only(top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
                contentPadding: const EdgeInsets.all(AppSize.s12),
                content: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 3,
                  child: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        SelectTagsComponent(fromRoute: "New Letter", cubit: cubit,)
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      if (!isClosing) {
                        isClosing = true;
                        Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.4))),
                    child: Text(
                      AppStrings.ok.tr(),
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
        },
      );
  }

}
Widget tagsWidget(BuildContext context,String fromRoute, dynamic cubit){
  switch (fromRoute){
    case "Letter Reply":
      cubit = cubit as LetterReplyCubit;
    case "Archive Letter":
      cubit = cubit as ArchivedLettersCubit;
    case "Update Letter":
      cubit = cubit as UpdateLetterCubit;
    case "New Letter":
    default:
      cubit = cubit as NewLetterCubit;
  }

  return Container(
    width: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSize.s6),
      color: Theme.of(context).splashColor,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSize.s8,),
        Text(AppStrings.tags.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
        const SizedBox(height: AppSize.s4,),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index){
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s6),
                color: ColorManager.goldColor.withOpacity(0.2),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s8, vertical: AppSize.s8),
              margin: const EdgeInsets.all(AppSize.s6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cubit.selectedTagsList[index].tagName, style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s14,fontWeight: FontWeightManager.bold),),
                  const SizedBox(width: AppSize.s8,),
                  Icon(Icons.close_rounded, color: Theme.of(context).primaryColorDark, size: AppSize.s18,).ripple((){cubit.addOrRemoveTag(cubit.selectedTagsList[index]);}, borderRadius: BorderRadius.circular(AppSize.s8),
                      overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
                ],
              ),
            );
          },
          itemCount: cubit.selectedTagsList.length,
        ),
      ],
    ),
  );
}