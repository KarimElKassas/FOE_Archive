/*
 * Coded By El Qassas
 */

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foe_archive/presentation/letter_details/helper/letter_details_args.dart';
import 'package:foe_archive/presentation/new_letter/ui/new_letter_screen.dart';
import 'package:foe_archive/presentation/secretary/home/bloc/secretary_home_cubit.dart';
import 'package:foe_archive/presentation/secretary/home/bloc/secretary_home_states.dart';
import 'package:foe_archive/presentation/secretary/incoming_external_letters/ui/incoming_external_letters_screen.dart';
import 'package:foe_archive/presentation/secretary/incoming_internal_letters/ui/incoming_internal_letters_screen.dart';
import 'package:foe_archive/presentation/secretary/outgoing_external_letters/ui/outgoing_external_letters_screen.dart';
import 'package:foe_archive/presentation/secretary/outgoing_internal_letters/ui/outgoing_internal_letters_screen.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/service/service_locator.dart';
import '../../../../resources/asset_manager.dart';
import '../../../../resources/color_manager.dart';
import '../../../../resources/constants_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/routes_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../../../utils/components.dart';
import '../../../incoming_letters/ui/incoming_letters_screen.dart';
import '../../../widget/loading_indicator.dart';
import 'dart:ui' as ui;

class SecretaryHomeScreen extends StatelessWidget {
  const SecretaryHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SecretaryHomeCubit>()..getAllLetters()..initSortMethod(),
      child: BlocConsumer<SecretaryHomeCubit, SecretaryHomeStates>(
        listener: (context, state) {
          if(state is SecretaryHomeGetDirectionsError){
            print("ERROR STATE : ${state.error}");
          }
          if(state is SecretaryHomeGetLettersError){
            print("ERROR Letters STATE : ${state.error}");
          }
        },
        builder: (context, state) {
          var cubit = SecretaryHomeCubit.get(context);
          return Scaffold(
            backgroundColor: Theme
                .of(context)
                .primaryColorLight,
            body: FadeIn(
              duration: const Duration(seconds: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme
                        .of(context)
                        .splashColor,
                    height: MediaQuery
                        .sizeOf(context)
                        .height,
                    width: 250,
                    padding: const EdgeInsets.symmetric(vertical: AppSize.s16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset(
                          height: 100,
                          width: MediaQuery
                              .sizeOf(context)
                              .width / 2,
                          ImageAsset.registerLogo,
                          alignment: Alignment.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s16, horizontal: AppSize.s8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${AppStrings.archiveApp.tr()} -> سكرتارية ',
                              style: TextStyle(
                                  color: Theme
                                      .of(context)
                                      .primaryColorDark,
                                  fontSize: AppSize.s16,
                                  fontFamily: FontConstants.family,
                                  fontWeight: FontWeightManager.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: AppSize.s24, top: AppSize.s16),
                          color: Theme
                              .of(context)
                              .primaryColorDark
                              .withOpacity(AppSize.s0_6),
                          width: AppSize.sFullWidth,
                          height: AppSize.s1,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                sideMenuItem(context, cubit, 0,
                                    AppStrings.newLetter.tr(),
                                    Icons.new_label_outlined, () {
                                      cubit.changeSelectedBox(0);
                                    }),
                                sideMenuItem(context, cubit, 1,
                                    AppStrings.allLetters.tr(),
                                    Icons.all_inclusive_outlined, () {
                                      cubit.getAllLetters();
                                      cubit.changeSelectedBox(1);
                                    }),

                                sideMenuItem(context, cubit, 2,
                                    AppStrings.incomeInternalLetters.tr(),
                                    Icons.call_missed_outgoing_outlined, () {
                                      cubit.changeSelectedBox(2);
                                    }),

                                sideMenuItem(context, cubit, 3,
                                    AppStrings.outgoingInternalLetters.tr(),
                                    Icons.reply_rounded, () {
                                      cubit.changeSelectedBox(3);
                                    }),
                                sideMenuItem(context, cubit, 4,
                                    AppStrings.incomeExternalLetters.tr(),
                                    Icons.call_missed_outgoing_outlined, () {
                                      cubit.changeSelectedBox(4);
                                    }),
                                sideMenuItem(context, cubit, 5,
                                    AppStrings.outgoingExternalLetters.tr(),
                                    Icons.reply_rounded, () {
                                      cubit.changeSelectedBox(5);
                                    }),
                                sideMenuItem(context, cubit, 5,
                                    AppStrings.archivedLetters.tr(),
                                    Icons.archive_outlined, () {
                                      cubit.changeSelectedBox(5);
                                    }),
                                sideMenuItem(context, cubit, 6,
                                    AppStrings.localLetters.tr(),
                                    Icons.local_offer_outlined, () {
                                      cubit.changeSelectedBox(6);
                                    })
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: sideMenuItem(
                              context, cubit, 6, AppStrings.logout.tr(),
                              Icons.logout, () {
                            scaleDialog(context, true, alterExitDialog(context, cubit));
                          }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: cubit.elPageController,
                      children: [
                        NewLetterScreen(),
                        allLetters(context, cubit,state),
                        const IncomingInternalLettersScreen(),
                        const OutgoingInternalLettersScreen(),
                        const IncomingExternalLettersScreen(),
                        const OutgoingExternalLettersScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget allLetters(BuildContext context, SecretaryHomeCubit cubit, SecretaryHomeStates state){
    return FadeIn(
      duration: const Duration(milliseconds: 1500),
      child: Column(
        children: [
          searchAndFilterWidget(context, cubit),
          const SizedBox(height:  AppSize.s16,),
          headerItem(context, cubit),
          state is SecretaryHomeLoadingLetters ?  Expanded(child: Center(child: loadingIndicator(),)) :
          cubit.filteredLettersList.isNotEmpty ? Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thickness: MaterialStateProperty.all(6)),
              child: Scrollbar(
                controller: cubit.scrollController,
                trackVisibility: true,
                thumbVisibility: true,
                thickness: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.filteredLettersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return letterItem(context, cubit, index);
                    },
                  ),
                ),
              ),
            ),
          ) : Expanded(child: Center(child: Text(AppStrings.noData.tr(), style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontFamily: FontConstants.family,
              fontSize: AppSize.s24,
              fontWeight: FontWeightManager.bold),),)),
        ],
      ),
    );
  }
  Widget sideMenuItem(BuildContext context, SecretaryHomeCubit cubit,
      int pageNumber, String label, IconData icon, Function onPressed) {
    return Container(
      height: AppSize.s40,
      decoration: cubit.selectedMenuBox == pageNumber
          ? BoxDecoration(
        color: ColorManager.goldColor.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(AppSize.s24),
            bottomRight: Radius.circular(AppSize.s24)),
      )
          : const BoxDecoration(color: Colors.transparent),
      margin: const EdgeInsets.only(top: AppSize.s12, right: AppSize.s12),
      padding: const EdgeInsets.only(
        right: AppSize.s12,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSize.s20,
            color: cubit.selectedMenuBox == pageNumber
                ? ColorManager.goldColor
                : Theme
                .of(context)
                .primaryColorDark,
          ),
          const SizedBox(
            width: AppSize.s12,
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColorDark,
                  fontSize: AppSize.s16,
                  fontFamily: FontConstants.family,
                  fontWeight: FontWeightManager.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: AppSize.s6,
          ),
          Container(
            decoration: BoxDecoration(
                color: cubit.selectedMenuBox == pageNumber
                    ? ColorManager.goldColor
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(AppSize.s4),
                    bottomRight: Radius.circular(AppSize.s4))),
            width: AppSize.s4,
            height: AppSize.s40,
          ),
        ],
      ),
    ).ripple(() {
      onPressed();
    },
        paddingTop: AppSize.s12,
        paddingRight: AppSize.s12,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(AppSize.s24),
            bottomRight: Radius.circular(AppSize.s24)),
        overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.1)));
  }

  Widget alterExitDialog(BuildContext context, SecretaryHomeCubit cubit) {
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
                  AppStrings.areYouSureExit.tr(),
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
                cubit.logOut();
                Navigator.pushNamedAndRemoveUntil(context, RoutesManager.loginRoute,(route)=> false);
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
  Widget filterDialog(BuildContext context, SecretaryHomeCubit cubit) {
    bool isClosing = false;

    return BlocConsumer<SecretaryHomeCubit, SecretaryHomeStates>(
      bloc: cubit,
      listener: (context, state){},
      builder: (context, state){
        return Directionality(
          textDirection:
          AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: AlertDialog(
            // <-- SEE HERE
              title: Text(
                AppStrings.filterBy.tr(),
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
                      Row(
                        children: [
                          Text(
                            AppStrings.filterByDirection.tr(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: AppSize.s16,
                                fontWeight: FontWeightManager.bold,
                                fontFamily: FontConstants.family),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: cubit.isFilterByDirection,
                            activeColor: Theme.of(context).primaryColorDark,
                            checkColor: ColorManager.goldColor,
                            onChanged: (bool? value) {
                              cubit.changeDirectionFilter(value!);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s8,),
                      cubit.isFilterByDirection ?
                      SecretaryFilterByDirectionComponent(cubit: cubit,) : const SizedBox.shrink(),
                      Container(
                        margin: const EdgeInsets.only(bottom: AppSize.s8, top: AppSize.s8),
                        color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_6),
                        width: AppSize.sFullWidth,
                        height: AppSize.s1,
                      ),

                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    cubit.prepareListAfterFilter();
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
      },
    );
  }

  Widget searchAndFilterWidget(BuildContext context, SecretaryHomeCubit cubit){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        border: Border.all(color: Theme.of(context).primaryColorDark, width: 0.1),
        borderRadius: BorderRadius.circular(AppSize.s16)
      ),
      margin: const EdgeInsets.all(AppSize.s8),
      padding: const EdgeInsets.all(AppSize.s12),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: ReusableComponents.registerTextField(
                    context: context,
                    background: Colors.transparent,
                    borderStyle: BorderStyle.none,
                    textInputType: TextInputType.text,
                    hintText: AppStrings.searchLetters.tr(),
                    textInputAction: TextInputAction.next,
                    suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorDark,),
                    borderColor: Theme.of(context).primaryColorDark,
                    validate: (value) {},
                    onChanged: (String? value) {
                      cubit.searchLetters(value!);
                    },
                  ),
                ),
                const SizedBox(width: AppSize.s8,),
                MouseRegion(
                  cursor: MaterialStateMouseCursor.clickable,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSize.s8, horizontal: AppSize.s8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s8),
                      color: Colors.transparent,
                      border: Border.all(
                          color: Theme.of(context).primaryColorDark,
                          width: AppSize.s1),
                    ),
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ).ripple((){
                  scaleDialog(context, false, filterDialog(context, cubit));
                },
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
              ],
            ),
          ),
          const SizedBox(height: AppSize.s12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.s12),
            //child:
          ),

        ],
      ),
    );
  }
  Widget headerItem(BuildContext context, SecretaryHomeCubit cubit){
    return Padding(
      padding: const EdgeInsets.all(AppSize.s8),
      child: Material(
        color: Theme.of(context).splashColor,
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
              color: Theme.of(context).splashColor
          ),
          padding: const EdgeInsets.all(AppSize.s12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  AppStrings.letterAbout.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s32,),
              Expanded(
                child: Text(
                  AppStrings.letterNumber.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s32,),
              Expanded(
                child: Text(
                  AppStrings.letterDate.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s32,),
              Expanded(
                child: Text(
                  AppStrings.letterDirection.tr(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget letterItem(BuildContext context, SecretaryHomeCubit cubit, int index){
    return Padding(
      padding: const EdgeInsets.all(AppSize.s8),
      child: Material(
        color: Theme.of(context).splashColor,
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
              color: Theme.of(context).splashColor
          ),
          padding: const EdgeInsets.all(AppSize.s12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  cubit.filteredLettersList[index].letterContent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s32,),
              Expanded(
                child: Text(
                  cubit.filteredLettersList[index].letterNumber,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s32,),
              Expanded(
                child: Text(
                  cubit.formatDate(cubit.filteredLettersList[index].letterDate??cubit.filteredLettersList[index].updatedAt!),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
              const SizedBox(width: AppSize.s32,),
              Expanded(
                child: Text(
                  cubit.filteredLettersList[index].directionName.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontFamily: FontConstants.family,
                      fontSize: AppSize.s16,
                      fontWeight: FontWeightManager.bold),
                ),
              ),
            ],
          ),
        ).ripple((){
          Navigator.pushNamed(
              context, RoutesManager.letterDetailsRoute,
              arguments: LetterDetailsArgs(cubit.filteredLettersList[index], 1,false));
        },
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s10)),
            overlayColor: MaterialStateColor.resolveWith((states) => ColorManager.goldColor.withOpacity(0.15))),
      ),
    );
  }
  Widget filterItem(BuildContext context, SecretaryHomeCubit cubit, String label){
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSize.s8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSize.s4,vertical: AppSize.s6),
      child: Row(
        children: [

        ],
      ),
    );
  }
}
