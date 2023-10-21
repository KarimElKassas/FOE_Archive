import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_states.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_cubit.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_states.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_cubit.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_states.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_cubit.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_states.dart';
import 'package:foe_archive/resources/routes_manager.dart';

import '../../resources/color_manager.dart';
import '../../resources/constants_manager.dart';
import 'dart:ui' as ui;

import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';
import '../../utils/components.dart';
Widget departmentDialog(BuildContext context, String fromRoute, dynamic cubit) {
  bool isClosing = false;
  return Directionality(
    textDirection:
    AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
    child: AlertDialog(
      // <-- SEE HERE
        title: Text(AppStrings.addDepartments.tr(), style: TextStyle(color: Theme.of(context).primaryColorDark, fontFamily: FontConstants.family,fontSize: AppSize.s16,fontWeight: FontWeightManager.bold),),
        backgroundColor: Theme
            .of(context)
            .splashColor,
        titlePadding: const EdgeInsets.only(
            top: AppSize.s12, left: AppSize.s12, right: AppSize.s12),
        contentPadding: const EdgeInsets.all(AppSize.s12),
        content: departmentsWidget(context,fromRoute, cubit),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if (!isClosing) {
                isClosing = true;
                Navigator.of(context).pop();
              }
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
        ],
        buttonPadding: const EdgeInsets.all(AppSize.s10)),
  );
}
Widget departmentsWidget(BuildContext context, String fromRoute, dynamic cubit){
  switch (fromRoute){
    case "Letter Reply":
      cubit = cubit as LetterReplyCubit;
      return BlocConsumer<LetterReplyCubit, LetterReplyStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s6),
              color: Theme.of(context).splashColor,
            ),
            padding: const EdgeInsets.all(AppSize.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSize.s8,),
                SizedBox(height: AppSize.s40, child: GetSectorsComponent(fromRoute: "Letter Reply", cubit: cubit,)),
                const SizedBox(height: AppSize.s8,),
                //cubit.selectedSectorModel != null ? headerItem(context, cubit) : const SizedBox.shrink(),
                cubit.departmentsList.isNotEmpty ? SizedBox(
                  height: MediaQuery.sizeOf(context).height /  3,
                  width: double.infinity,
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.departmentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return letterItem(context, cubit, index);
                    },
                  ),
                ): const SizedBox.shrink()
              ],
            ),
          );
        },
      );
    case "Archive Letter":
      cubit = cubit as ArchivedLettersCubit;
      return BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s6),
              color: Theme.of(context).splashColor,
            ),
            padding: const EdgeInsets.all(AppSize.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSize.s8,),
                SizedBox(height: AppSize.s40, child: GetSectorsComponent(fromRoute: "Archive Letter", cubit: cubit,)),
                const SizedBox(height: AppSize.s8,),
                //cubit.selectedSectorModel != null ? headerItem(context, cubit) : const SizedBox.shrink(),
                cubit.departmentsList.isNotEmpty ? SizedBox(
                  height: MediaQuery.sizeOf(context).height /  3,
                  width: double.infinity,
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.departmentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return letterItem(context, cubit, index);
                    },
                  ),
                ): const SizedBox.shrink()
              ],
            ),
          );
        },
      );
    case "Update Letter":
      cubit = cubit as UpdateLetterCubit;
      return BlocConsumer<UpdateLetterCubit, UpdateLetterStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s6),
              color: Theme.of(context).splashColor,
            ),
            padding: const EdgeInsets.all(AppSize.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSize.s8,),
                SizedBox(height: AppSize.s40, child: GetSectorsComponent(fromRoute: "Update Letter", cubit: cubit,)),
                const SizedBox(height: AppSize.s8,),
                //cubit.selectedSectorModel != null ? headerItem(context, cubit) : const SizedBox.shrink(),
                cubit.departmentsList.isNotEmpty ? SizedBox(
                  height: MediaQuery.sizeOf(context).height /  3,
                  width: double.infinity,
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.departmentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return letterItem(context, cubit, index);
                    },
                  ),
                ): const SizedBox.shrink()
              ],
            ),
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
          return Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s6),
              color: Theme.of(context).splashColor,
            ),
            padding: const EdgeInsets.all(AppSize.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSize.s8,),
                SizedBox(height: AppSize.s40, child: GetSectorsComponent(fromRoute: "New Letter", cubit: cubit,)),
                const SizedBox(height: AppSize.s8,),
                //cubit.selectedSectorModel != null ? headerItem(context, cubit) : const SizedBox.shrink(),
                cubit.departmentsList.isNotEmpty ? SizedBox(
                  height: MediaQuery.sizeOf(context).height /  3,
                  width: double.infinity,
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.departmentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return letterItem(context, cubit, index);
                    },
                  ),
                ): const SizedBox.shrink()
              ],
            ),
          );
        },
      );
  }
}
Widget letterItem(BuildContext context, dynamic cubit, int index){

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

