/*
 * Coded By El Qassas
 */

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/presentation/secretary/incoming_internal_letters/bloc/incoming_internal_letters_cubit.dart';
import 'package:foe_archive/presentation/secretary/incoming_internal_letters/bloc/incoming_internal_letters_state.dart';
import 'package:foe_archive/presentation/widget/loading_indicator.dart';
import 'package:foe_archive/resources/extensions.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/service/service_locator.dart';
import '../../../../resources/color_manager.dart';
import '../../../../resources/font_manager.dart';
import '../../../../resources/routes_manager.dart';
import '../../../../resources/strings_manager.dart';
import '../../../../resources/values_manager.dart';
import '../../../../utils/components.dart';
import '../../../letter_details/helper/letter_details_args.dart';

class IncomingInternalLettersScreen extends StatelessWidget {
  const IncomingInternalLettersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IncomingInternalLettersCubit>()..getIncomingLetters(),
      child: BlocConsumer<IncomingInternalLettersCubit,IncomingInternalLettersStates>(
        listener: (context, state){},
        builder: (context, state){
          var cubit = IncomingInternalLettersCubit.get(context);
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
            body: FadeIn(
              duration: const Duration(milliseconds: 1500),
              child: Column(
                children: [
                  searchAndFilterWidget(context, cubit),
                  const SizedBox(height:  AppSize.s16,),
                  cubit.filteredLettersList.isNotEmpty ? headerItem(context, cubit) : const SizedBox.shrink(),
                  state is IncomingInternalLettersLoadingLetters ?  Expanded(child: Center(child: loadingIndicator(),)) :
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
            ),
          );
        },
      ),
    );
  }
  Widget searchAndFilterWidget(BuildContext context, IncomingInternalLettersCubit cubit){
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
                  //scaleDialog(context, false, filterDialog(context, cubit));
                },
                    borderRadius: BorderRadius.circular(AppSize.s8),
                    overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_2))),
              ],
            ),
          ),
          const SizedBox(height: AppSize.s12,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s12),
            //child:
          ),

        ],
      ),
    );
  }
  Widget headerItem(BuildContext context, IncomingInternalLettersCubit cubit){
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
  Widget letterItem(BuildContext context, IncomingInternalLettersCubit cubit, int index){
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
}
