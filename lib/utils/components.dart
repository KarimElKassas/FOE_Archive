import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foe_archive/data/models/direction_model.dart';
import 'package:foe_archive/data/models/sector_model.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_states.dart';
import 'package:foe_archive/presentation/home/bloc/home_cubit.dart';
import 'package:foe_archive/presentation/home/bloc/home_states.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_cubit.dart';
import 'package:foe_archive/presentation/letter_reply/bloc/letter_reply_states.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_cubit.dart';
import 'package:foe_archive/presentation/new_letter/bloc/new_letter_states.dart';
import 'package:foe_archive/presentation/secretary/home/bloc/secretary_home_cubit.dart';
import 'package:foe_archive/presentation/secretary/home/bloc/secretary_home_states.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_cubit.dart';
import 'package:foe_archive/presentation/update_letter/bloc/update_letter_states.dart';
import 'package:foe_archive/resources/routes_manager.dart';
import 'package:iconly/iconly.dart';
import 'dart:ui' as ui;
import '../resources/asset_manager.dart';
import '../resources/color_manager.dart';
import '../resources/constants_manager.dart';
import '../resources/font_manager.dart';
import '../resources/language_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';
import 'constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class FilterByDirectionComponent extends StatelessWidget {
  FilterByDirectionComponent({Key? key, required this.cubit}) : super(key: key);
  final HomeCubit cubit;
  DirectionModel? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      bloc: cubit,
      listener: (context, state){},
      builder: (context, state){
        return DropdownButtonHideUnderline(
          child: DropdownButton2<DirectionModel>(
            isExpanded: true,
            hint: Text(
              AppStrings.filterByDirection.tr(),
              style: TextStyle(
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: cubit.directionsList
                .map((item) => DropdownMenuItem(
              enabled: false,
              value: item,
              child: StatefulBuilder(
                builder: (context, menuSetState){
                  return InkWell(
                    onTap: (){
                      cubit.addOrRemoveFilteredDirection(item);
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          if (cubit.selectedDirectionsList.contains(item))
                            const Icon(Icons.check_box_outlined)
                          else
                            const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: AppSize.s16),
                          Expanded(
                            child: Text(
                              item.directionName,
                              style: const TextStyle(
                                fontSize: AppSize.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )).toList(),
            value: cubit.selectedDirectionsList.isEmpty ? null : cubit.selectedDirectionsList.last,
            onChanged: (value) {},
            selectedItemBuilder: (context) {
              return cubit.directionsList.map(
                    (item) {
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      cubit.selectedDirectionsList.map((model) => model.directionName).join(', '),
                      style: const TextStyle(
                        fontSize: AppSize.s14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  );
                },
              ).toList();
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 220,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                )
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
              )
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            style: TextStyle(color: ColorManager.darkSecondColor),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: ReusableComponents.registerTextField(
                    context: context,
                    background: Colors.transparent,
                    borderColor: ColorManager.darkSecondColor,
                    cursorColor: ColorManager.darkSecondColor,
                    textInputType: TextInputType.text,
                    hintText: AppStrings.searchForDirection.tr(),
                    textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                    hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                    textInputAction: TextInputAction.next,
                    suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                    controller: textEditingController,
                    validate: (value) {}, onChanged: (String? value) {}),
              ),
              searchMatchFn: (item, searchValue) {
                return (item.value.toString().contains(searchValue));
              },
            ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        );
      },
    );
  }
}
class SecretaryFilterByDirectionComponent extends StatelessWidget {
  SecretaryFilterByDirectionComponent({Key? key, required this.cubit}) : super(key: key);
  final SecretaryHomeCubit cubit;
  DirectionModel? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecretaryHomeCubit, SecretaryHomeStates>(
      bloc: cubit,
      listener: (context, state){},
      builder: (context, state){
        return DropdownButtonHideUnderline(
          child: DropdownButton2<DirectionModel>(
            isExpanded: true,
            hint: Text(
              AppStrings.filterByDirection.tr(),
              style: TextStyle(
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: cubit.directionsList
                .map((item) => DropdownMenuItem(
              enabled: false,
              value: item,
              child: StatefulBuilder(
                builder: (context, menuSetState){
                  return InkWell(
                    onTap: (){
                      cubit.addOrRemoveFilteredDirection(item);
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          if (cubit.selectedDirectionsList.contains(item))
                            const Icon(Icons.check_box_outlined)
                          else
                            const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: AppSize.s16),
                          Expanded(
                            child: Text(
                              item.directionName,
                              style: const TextStyle(
                                fontSize: AppSize.s14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )).toList(),
            value: cubit.selectedDirectionsList.isEmpty ? null : cubit.selectedDirectionsList.last,
            onChanged: (value) {},
            selectedItemBuilder: (context) {
              return cubit.directionsList.map(
                    (item) {
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      cubit.selectedDirectionsList.map((model) => model.directionName).join(', '),
                      style: const TextStyle(
                        fontSize: AppSize.s14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                  );
                },
              ).toList();
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 220,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                )
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
              )
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            style: TextStyle(color: ColorManager.darkSecondColor),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: ReusableComponents.registerTextField(
                    context: context,
                    background: Colors.transparent,
                    borderColor: ColorManager.darkSecondColor,
                    cursorColor: ColorManager.darkSecondColor,
                    textInputType: TextInputType.text,
                    hintText: AppStrings.searchForDirection.tr(),
                    textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                    hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                    textInputAction: TextInputAction.next,
                    suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                    controller: textEditingController,
                    validate: (value) {}, onChanged: (String? value) {}),
              ),
              searchMatchFn: (item, searchValue) {
                return (item.value.toString().contains(searchValue));
              },
            ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        );
      },
    );
  }
}
class SelectTagsComponent extends StatelessWidget {
  SelectTagsComponent({Key? key,required this.fromRoute,  required this.cubit}) : super(key: key);
  final String fromRoute;
  dynamic cubit;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch(fromRoute){
      case "Letter Reply":
        return BlocConsumer<LetterReplyCubit, LetterReplyStates>(
          bloc: (cubit as LetterReplyCubit),
          listener: (context, state){},
          builder: (context, state){
            return DropdownButtonHideUnderline(
              child: DropdownButton2<TagModel>(
                isExpanded: true,
                hint: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as LetterReplyCubit).tagsList
                    .map((item) => DropdownMenuItem(
                  enabled: false,
                  value: item,
                  child: StatefulBuilder(
                    builder: (context, menuSetState){
                      return InkWell(
                        onTap: (){
                          (cubit as LetterReplyCubit).addOrRemoveTag(item);
                          menuSetState(() {});
                        },
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if ((cubit as LetterReplyCubit).selectedTagsList.contains(item))
                                const Icon(Icons.check_box_outlined)
                              else
                                const Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: AppSize.s16),
                              Expanded(
                                child: Text(
                                  item.tagName,
                                  style: const TextStyle(
                                    fontSize: AppSize.s14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )).toList(),
                value: (cubit as LetterReplyCubit).selectedTagsList.isEmpty ? null : (cubit as LetterReplyCubit).selectedTagsList.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return (cubit as LetterReplyCubit).tagsList.map(
                        (item) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          (cubit as LetterReplyCubit).selectedTagsList.map((model) => model.tagName).join(', '),
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ).toList();
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        cursorColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                        hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "Archive Letter":
        return BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
          bloc: (cubit as ArchivedLettersCubit),
          listener: (context, state){},
          builder: (context, state){
            return DropdownButtonHideUnderline(
              child: DropdownButton2<TagModel>(
                isExpanded: true,
                hint: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as ArchivedLettersCubit).tagsList
                    .map((item) => DropdownMenuItem(
                  enabled: false,
                  value: item,
                  child: StatefulBuilder(
                    builder: (context, menuSetState){
                      return InkWell(
                        onTap: (){
                          (cubit as ArchivedLettersCubit).addOrRemoveTag(item);
                          menuSetState(() {});
                        },
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if ((cubit as ArchivedLettersCubit).selectedTagsList.contains(item))
                                const Icon(Icons.check_box_outlined)
                              else
                                const Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: AppSize.s16),
                              Expanded(
                                child: Text(
                                  item.tagName,
                                  style: const TextStyle(
                                    fontSize: AppSize.s14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )).toList(),
                value: (cubit as ArchivedLettersCubit).selectedTagsList.isEmpty ? null : (cubit as ArchivedLettersCubit).selectedTagsList.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return (cubit as ArchivedLettersCubit).tagsList.map(
                        (item) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          (cubit as ArchivedLettersCubit).selectedTagsList.map((model) => model.tagName).join(', '),
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ).toList();
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        cursorColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                        hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "Update Letter":
        return BlocConsumer<UpdateLetterCubit, UpdateLetterStates>(
          bloc: (cubit as UpdateLetterCubit),
          listener: (context, state){},
          builder: (context, state){
            return DropdownButtonHideUnderline(
              child: DropdownButton2<TagModel>(
                isExpanded: true,
                hint: Text(
                  AppStrings.selectTags.tr(),
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as UpdateLetterCubit).tagsList
                    .map((item) => DropdownMenuItem(
                  enabled: false,
                  value: item,
                  child: StatefulBuilder(
                    builder: (context, menuSetState){
                      return InkWell(
                        onTap: (){
                          (cubit as UpdateLetterCubit).addOrRemoveTag(item);
                          menuSetState(() {});
                        },
                        child: Container(
                          height: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              if ((cubit as UpdateLetterCubit).selectedTagsList.contains(item))
                                const Icon(Icons.check_box_outlined)
                              else
                                const Icon(Icons.check_box_outline_blank),
                              const SizedBox(width: AppSize.s16),
                              Expanded(
                                child: Text(
                                  item.tagName,
                                  style: const TextStyle(
                                    fontSize: AppSize.s14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )).toList(),
                value: (cubit as UpdateLetterCubit).selectedTagsList.isEmpty ? null : (cubit as UpdateLetterCubit).selectedTagsList.last,
                onChanged: (value) {},
                selectedItemBuilder: (context) {
                  return (cubit as UpdateLetterCubit).tagsList.map(
                        (item) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        child: Text(
                          (cubit as UpdateLetterCubit).selectedTagsList.map((model) => model.tagName).join(', '),
                          style: const TextStyle(
                            fontSize: AppSize.s14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      );
                    },
                  ).toList();
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        cursorColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                        hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "New Letter":
      default:
      return BlocConsumer<NewLetterCubit, NewLetterStates>(
        bloc: cubit,
        listener: (context, state){},
        builder: (context, state){
          return DropdownButtonHideUnderline(
            child: DropdownButton2<TagModel>(
              isExpanded: true,
              hint: Text(
                AppStrings.selectTags.tr(),
                style: TextStyle(
                  fontSize: AppSize.s14,
                  fontFamily: FontConstants.family,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: (cubit as NewLetterCubit).tagsList
                  .map((item) => DropdownMenuItem(
                enabled: false,
                value: item,
                child: StatefulBuilder(
                  builder: (context, menuSetState){
                    return InkWell(
                      onTap: (){
                        (cubit as NewLetterCubit).addOrRemoveTag(item);
                        menuSetState(() {});
                      },
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            if ((cubit as NewLetterCubit).selectedTagsList.contains(item))
                              const Icon(Icons.check_box_outlined)
                            else
                              const Icon(Icons.check_box_outline_blank),
                            const SizedBox(width: AppSize.s16),
                            Expanded(
                              child: Text(
                                item.tagName,
                                style: const TextStyle(
                                  fontSize: AppSize.s14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )).toList(),
              value: (cubit as NewLetterCubit).selectedTagsList.isEmpty ? null : (cubit as NewLetterCubit).selectedTagsList.last,
              onChanged: (value) {},
              selectedItemBuilder: (context) {
                return (cubit as NewLetterCubit).tagsList.map(
                      (item) {
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        (cubit as NewLetterCubit).selectedTagsList.map((model) => model.tagName).join(', '),
                        style: const TextStyle(
                          fontSize: AppSize.s14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    );
                  },
                ).toList();
              },
              buttonStyleData: ButtonStyleData(
                  height: 40,
                  width: 220,
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                  )
              ),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: 300,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                  )
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              style: TextStyle(color: ColorManager.darkSecondColor),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: ReusableComponents.registerTextField(
                      context: context,
                      background: Colors.transparent,
                      borderColor: ColorManager.darkSecondColor,
                      cursorColor: ColorManager.darkSecondColor,
                      textInputType: TextInputType.text,
                      hintText: AppStrings.searchForDirection.tr(),
                      textStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                      hintStyle: const TextStyle(color: Colors.black54,fontSize: AppSize.s14, fontFamily: FontConstants.family),
                      textInputAction: TextInputAction.next,
                      suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                      controller: textEditingController,
                      validate: (value) {}, onChanged: (String? value) {}),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value.toString().contains(searchValue));
                },
              ),
              //This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
            ),
          );
        },
      );
    }
  }
}

class SortByComponent extends StatelessWidget {
  SortByComponent({Key? key}) : super(key: key);

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = HomeCubit.get(context);
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              cubit.selectedSortMethod!,
              style: TextStyle(
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: cubit.sortMethods
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: AppSize.s14,
                ),
              ),
            )).toList(),
            value: cubit.selectedSortMethod,
            onChanged: (value) {
              cubit.changeSortMethod(value!);
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 220,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                )
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
              )
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            style: TextStyle(color: ColorManager.darkSecondColor),
          ),
        );
      },
    );
  }
}
class SecretarySortByComponent extends StatelessWidget {
  SecretarySortByComponent({Key? key}) : super(key: key);

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecretaryHomeCubit, SecretaryHomeStates>(
      listener: (context, state){},
      builder: (context, state){
        var cubit = HomeCubit.get(context);
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              cubit.selectedSortMethod!,
              style: TextStyle(
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: cubit.sortMethods
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: AppSize.s14,
                ),
              ),
            )).toList(),
            value: cubit.selectedSortMethod,
            onChanged: (value) {
              cubit.changeSortMethod(value!);
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              width: 220,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                    borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                )
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
              )
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            style: TextStyle(color: ColorManager.darkSecondColor),
          ),
        );
      },
    );
  }
}
class GetSectorsComponent extends StatelessWidget {
  GetSectorsComponent({Key? key,required this.fromRoute,  required this.cubit}) : super(key: key);
  final String fromRoute;
  dynamic cubit;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch(fromRoute){
      case "Letter Reply":
        cubit = cubit as LetterReplyCubit;
        return BlocConsumer<LetterReplyCubit, LetterReplyStates>(
          bloc: cubit,
          listener: (context, state){},
          builder: (context, state){
            return DropdownButtonHideUnderline(
              child: DropdownButton2<SectorModel>(
                isExpanded: true,
                hint: Text(
                  (cubit as LetterReplyCubit).selectedSectorModel == null ? AppStrings.selectSector.tr() : (cubit as LetterReplyCubit).selectedSectorModel!.sectorName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as LetterReplyCubit).sectorsList
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.sectorName,
                    style: const TextStyle(
                      fontSize: AppSize.s14,
                    ),
                  ),
                ))
                    .toList(),
                value: (cubit as LetterReplyCubit).selectedSectorModel,
                onChanged: (value) {
                  (cubit as LetterReplyCubit).changeSelectedSector(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForSector.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
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
            return DropdownButtonHideUnderline(
              child: DropdownButton2<SectorModel>(
                isExpanded: true,
                hint: Text(
                  (cubit as ArchivedLettersCubit).selectedSectorModel == null ? AppStrings.selectSector.tr() : (cubit as ArchivedLettersCubit).selectedSectorModel!.sectorName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as ArchivedLettersCubit).sectorsList
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.sectorName,
                    style: const TextStyle(
                      fontSize: AppSize.s14,
                    ),
                  ),
                ))
                    .toList(),
                value: (cubit as ArchivedLettersCubit).selectedSectorModel,
                onChanged: (value) {
                  (cubit as ArchivedLettersCubit).changeSelectedSector(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForSector.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
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
            return DropdownButtonHideUnderline(
              child: DropdownButton2<SectorModel>(
                isExpanded: true,
                hint: Text(
                  (cubit as UpdateLetterCubit).selectedSectorModel == null ? AppStrings.selectSector.tr() : (cubit as UpdateLetterCubit).selectedSectorModel!.sectorName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as UpdateLetterCubit).sectorsList
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.sectorName,
                    style: const TextStyle(
                      fontSize: AppSize.s14,
                    ),
                  ),
                ))
                    .toList(),
                value: (cubit as UpdateLetterCubit).selectedSectorModel,
                onChanged: (value) {
                  (cubit as UpdateLetterCubit).changeSelectedSector(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForSector.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "New Letter":
      default :
        cubit = cubit as NewLetterCubit;
        return BlocConsumer<NewLetterCubit, NewLetterStates>(
          bloc: cubit as NewLetterCubit,
          listener: (context, state){},
          builder: (context, state){
            return DropdownButtonHideUnderline(
              child: DropdownButton2<SectorModel>(
                isExpanded: true,
                hint: Text(
                  (cubit as NewLetterCubit).selectedSectorModel == null ? AppStrings.selectSector.tr() : (cubit as NewLetterCubit).selectedSectorModel!.sectorName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: (cubit as NewLetterCubit).sectorsList
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.sectorName,
                    style: const TextStyle(
                      fontSize: AppSize.s14,
                    ),
                  ),
                ))
                    .toList(),
                value: (cubit as NewLetterCubit).selectedSectorModel,
                onChanged: (value) {
                  (cubit as NewLetterCubit).changeSelectedSector(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForSector.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
    }
  }
}
class SelectDirectionComponent extends StatelessWidget {
  SelectDirectionComponent({Key? key, required this.fromRoute, required this.cubit}) : super(key: key);
  dynamic cubit;
  final String fromRoute;

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    switch (fromRoute){

      case "Archive Letter":
        return BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
          bloc: cubit as ArchivedLettersCubit,
          listener: (context, state){},
          builder: (context, state){
            var mCubit = cubit as ArchivedLettersCubit;
            return DropdownButtonHideUnderline(
              child: DropdownButton2<DirectionModel>(
                isExpanded: true,
                hint: Text(
                  mCubit.selectedDirection == null ? AppStrings.selectDirection.tr() : mCubit.selectedDirection!.directionName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: mCubit.directionsList.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.directionName,
                    style: const TextStyle(
                        fontSize: AppSize.s14,
                        fontFamily: FontConstants.family
                    ),
                  ),
                ))
                    .toList(),
                value: mCubit.selectedDirection,
                onChanged: (value) {
                  mCubit.changeSelectedDirection(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "Update Letter":
        return BlocConsumer<UpdateLetterCubit, UpdateLetterStates>(
          bloc: cubit as UpdateLetterCubit,
          listener: (context, state){},
          builder: (context, state){
            var mCubit = cubit as UpdateLetterCubit;
            return DropdownButtonHideUnderline(
              child: DropdownButton2<DirectionModel>(
                isExpanded: true,
                hint: Text(
                  mCubit.selectedDirection == null ? AppStrings.selectDirection.tr() : mCubit.selectedDirection!.directionName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: mCubit.directionsList.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.directionName,
                    style: const TextStyle(
                        fontSize: AppSize.s14,
                        fontFamily: FontConstants.family
                    ),
                  ),
                ))
                    .toList(),
                value: mCubit.selectedDirection,
                onChanged: (value) {
                  mCubit.changeSelectedDirection(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "Letter Reply":
        return BlocConsumer<LetterReplyCubit, LetterReplyStates>(
          bloc: cubit as LetterReplyCubit,
          listener: (context, state){},
          builder: (context, state){
            var mCubit = cubit as LetterReplyCubit;
            return DropdownButtonHideUnderline(
              child: DropdownButton2<DirectionModel>(
                isExpanded: true,
                hint: Text(
                  mCubit.selectedDirection == null ? AppStrings.selectDirection.tr() : mCubit.selectedDirection!.directionName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: mCubit.directionsList.map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.directionName,
                    style: const TextStyle(
                        fontSize: AppSize.s14,
                        fontFamily: FontConstants.family
                    ),
                  ),
                ))
                    .toList(),
                value: mCubit.selectedDirection,
                onChanged: (value) {
                  mCubit.changeSelectedDirection(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
      case "New Letter":
      default:
        return BlocConsumer<NewLetterCubit, NewLetterStates>(
          bloc: cubit as NewLetterCubit,
          listener: (context, state){},
          builder: (context, state){
            var mCubit = cubit as NewLetterCubit;
            return DropdownButtonHideUnderline(
              child: DropdownButton2<DirectionModel>(
                isExpanded: true,
                hint: Text(
                  mCubit.selectedDirection == null ? AppStrings.selectDirection.tr() : mCubit.selectedDirection!.directionName,
                  style: TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: mCubit.directionsList
                    .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.directionName,
                    style: const TextStyle(
                        fontSize: AppSize.s14,
                        fontFamily: FontConstants.family
                    ),
                  ),
                ))
                    .toList(),
                value: mCubit.selectedDirection,
                onChanged: (value) {
                  mCubit.changeSelectedDirection(value!);
                },
                buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: 220,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                      borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                    )
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                    )
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
                style: TextStyle(color: ColorManager.darkSecondColor),
                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: ReusableComponents.registerTextField(
                        context: context,
                        background: Colors.transparent,
                        borderColor: ColorManager.darkSecondColor,
                        textInputType: TextInputType.text,
                        hintText: AppStrings.searchForDirection.tr(),
                        textStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        hintStyle: TextStyle(color: ColorManager.darkSecondColor, fontSize: 14, fontFamily: FontConstants.family),
                        textInputAction: TextInputAction.next,
                        suffixIcon: Icon(IconlyBroken.search, color: Theme.of(context).primaryColorLight),
                        controller: textEditingController,
                        validate: (value) {}, onChanged: (String? value) {}),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    textEditingController.clear();
                  }
                },
              ),
            );
          },
        );
    }
  }
}
class SelectLetterTypeComponent extends StatelessWidget {
  SelectLetterTypeComponent({Key? key,required this.cubit}) : super(key: key);
  final ArchivedLettersCubit cubit;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
      bloc: cubit,
      listener: (context, state){},
      builder: (context, state){
        var mCubit = cubit;
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              AppStrings.localLetter.tr(),
              style: TextStyle(
                fontSize: AppSize.s14,
                fontFamily: FontConstants.family,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: mCubit.letterOption.map((item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                    fontSize: AppSize.s14,
                    fontFamily: FontConstants.family
                ),
              ),
            ))
                .toList(),
            value: mCubit.selectedOption,
            onChanged: (value) {
              mCubit.changeLetterOption(value!);
            },
            buttonStyleData: ButtonStyleData(
                height: 40,
                width: 220,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.s6, vertical: AppSize.s2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  border: Border.all(color: Theme.of(context).primaryColorDark, width: AppSize.s1),
                  borderRadius: const BorderRadius.all(Radius.circular(AppSize.s6)),
                )
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(AppSize.s6), bottomRight: Radius.circular(AppSize.s6))
                )
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            style: TextStyle(color: ColorManager.darkSecondColor),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        );
      },
    );
  }
}

void scaleDialog(BuildContext context, bool dismissible, Widget content) {
  showGeneralDialog(
    barrierLabel: '',
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withOpacity(0.2),
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: Directionality(
          textDirection: !AppConstants.isArabic()
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: content,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

class ReusableComponents {
  static Widget registerTextField(
      {required BuildContext context,
      required TextInputType textInputType,
      required String hintText,
      required TextInputAction textInputAction,
      required Function(String? value) validate,
      required Function(String? value) onChanged,
        List<TextInputFormatter>? inputFormatter,
        FocusNode? focusNode,
        TextStyle? textStyle,
        TextStyle? hintStyle,
        String? labelText,
        Widget? suffixIcon,
        Widget? prefixIcon,
        bool? isPassword,
        bool showLabel = false,
        Color? background,
        Color? borderColor,
        Color? cursorColor,
        BorderStyle? borderStyle,
        EdgeInsetsGeometry? contentPadding,
        double? borderRadius,
        int? maxLines,
        TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      inputFormatters: inputFormatter,
      cursorWidth: AppSize.s1,
      maxLines: maxLines ?? 1,
      cursorColor: cursorColor ?? Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
      textDirection: Constants.currentLocale ==
          LanguageType.ARABIC.getValue()
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      obscureText: isPassword ?? false,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start, //Constants.currentLocale == LanguageType.ARABIC.getValue() ? ,
      validator: (value) => validate(value),
      onChanged: (value) => onChanged(value),
      decoration: InputDecoration(
          filled: true,
          fillColor: background ?? ColorManager.white.withOpacity(AppSize.s0_8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
            borderSide: BorderSide(
                width: AppSize.s0_2,
                style: borderStyle ?? BorderStyle.solid,
                color: borderColor ?? Theme.of(context).primaryColorDark),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
            borderSide: BorderSide(
              width: AppSize.s0_2,
              style: borderStyle ?? BorderStyle.solid,
              color: ColorManager.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
            borderSide: BorderSide(
                width: AppSize.s0_2,
                style: borderStyle ?? BorderStyle.solid,
                color: ColorManager.error),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
            borderSide: BorderSide(
                width: AppSize.s0_2,
                style: borderStyle ?? BorderStyle.solid,
                color: borderColor ?? Theme.of(context).primaryColorDark),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? AppSize.s8)),
            borderSide: BorderSide(
                width: AppSize.s0_2,
                style: borderStyle ?? BorderStyle.solid,
                color: borderColor ?? Theme.of(context).primaryColorDark),
          ),
          labelText: showLabel ? labelText : hintText,
          labelStyle: hintStyle ?? TextStyle(
              fontSize: AppSize.s14,
              backgroundColor: Colors.transparent,
              color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
              fontFamily: FontConstants.family,
              fontWeight: FontWeightManager.bold),
          floatingLabelStyle: TextStyle(fontSize: AppSize.s14, color: Theme.of(context).primaryColorDark),
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(
              fontSize: AppSize.s14,
              backgroundColor: Colors.transparent,
              color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
              fontFamily: FontConstants.family,
              fontWeight: FontWeightManager.bold),
          //alignLabelWithHint: true,
          errorStyle: TextStyle(
              fontSize: AppSize.s12,
              color: ColorManager.error,
              fontFamily: FontConstants.family,
              fontWeight: FontWeightManager.bold),
          floatingLabelBehavior: showLabel ? FloatingLabelBehavior.always : FloatingLabelBehavior.never,

          hintTextDirection: Constants.currentLocale ==
              LanguageType.ARABIC.getValue()
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          border: OutlineInputBorder(
              borderSide: BorderSide(
                width: AppSize.s0_2,
                color: borderColor ?? Theme.of(context).primaryColorDark,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(borderRadius ?? AppSize.s8))),
          prefixIcon: prefixIcon,
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: AppSize.s12),
          suffixIcon: suffixIcon,
          errorMaxLines: 2),
      style: textStyle ??
          TextStyle(
              fontSize: AppSize.s14,
              color: Theme.of(context).primaryColorDark.withOpacity(AppSize.s0_8),
              fontFamily: FontConstants.family,
              fontWeight: FontWeightManager.bold),
    );
  }
  static void showMToast(
      BuildContext context, String message,TextStyle textStyle, Color background) {
    showToast(
      message,
      textStyle: textStyle,
      backgroundColor: background,
      context: context,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 2500),
      animationBuilder: (
          BuildContext context,
          AnimationController controller,
          Duration duration,
          Widget child,
          ) {
        return SlideTransition(
          position: getAnimation<Offset>(
              const Offset(0.0, 3.0), const Offset(0, 0), controller,
              curve: Curves.bounceInOut),
          child: child,
        );
      },
      reverseAnimBuilder: (
          BuildContext context,
          AnimationController controller,
          Duration duration,
          Widget child,
          ) {
        return SlideTransition(
          position: AppConstants.isArabic()
              ? (getAnimation<Offset>(
              const Offset(0.0, 0.0), const Offset(-3.0, 0), controller,
              curve: Curves.easeInOut))
              : (getAnimation<Offset>(
              const Offset(0.0, 0.0), const Offset(3.0, 0), controller,
              curve: Curves.easeInOut)),
          child: child,
        );
      },
    );
  }

  static AppBar appBar({
    Color? statusBarColor,
    Color? backgroundColor,
    Brightness? statusBarIconBrightness,
    Brightness? statusBarBrightness,
    double? toolBarHeight,
    double? elevation,
    Widget? flexibleSpace
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        // For Android (dark icons)
        statusBarBrightness: statusBarBrightness, // For iOS (dark icons)
      ),
      toolbarHeight: toolBarHeight,
      elevation: elevation ?? AppSize.s0,
      backgroundColor: backgroundColor,
      flexibleSpace: flexibleSpace,
    );
  }

  static Widget defaultButton({
    double? width,
    double height = AppSize.s50,
    Color background = Colors.deepPurple,
    Color textColor = Colors.white,
    Color borderColor = Colors.white,
    TextStyle? textStyle,
    double radius = AppSize.s8,
    bool isUpperCase = false,
    bool outline = false,
    required VoidCallback function,
    required String text,
  }) =>
      Container(
        padding: EdgeInsets.zero,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color: outline ? Colors.transparent : background,
            border: Border.all(
              color: borderColor,
              width: AppSize.s0_8,
            )),
        child: MaterialButton(
          onPressed: function,
          height: height,
          child: Text(
            isUpperCase ? text.toUpperCase() : text,
            textAlign: TextAlign.center,
            style: textStyle ??
                TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 2,
                    color: textColor),
          ),
        ),
      );

  static Widget cachedImage(
      {required String url,
        required BorderRadius borderRadius,
        BoxFit? fit,
        double? height, double? width}) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => ClipRRect(
        borderRadius: borderRadius,
        child: FadeInImage(
          height: height,
          width: width,
          fit: fit??BoxFit.fill,
          image: imageProvider,
          placeholder: const AssetImage(ImageAsset.placeholder),
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              ImageAsset.error,
              fit: BoxFit.fill,
              height: height,
              width: width,
            );
          },
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(
        color: ColorManager.lightGreen,
        strokeWidth: AppSize.s0_8,
      ),
      errorWidget: (context, url, error) => FadeInImage(
        height: height,
        width: width,
        fit: BoxFit.fill,
        image: const AssetImage(ImageAsset.error),
        placeholder: const AssetImage(ImageAsset.placeholder),
      ),
    );
  }
}

class BlurryProgressDialog extends StatelessWidget {
  final String title;
  TextStyle? titleStyle;
  double? titleMinSize, titleMaxSize, blurValue;
  int? titleMaxLines;

  BlurryProgressDialog(
      {Key? key,
        required this.title,
        this.titleStyle,
        this.titleMaxLines,
        this.titleMaxSize,
        this.titleMinSize,
        this.blurValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
      AppConstants.isArabic() ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurValue ?? 4, sigmaY: blurValue ?? 4),
          child: AlertDialog(
            backgroundColor: Theme.of(context).splashColor,
            scrollable: true,
            content: Column(
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColorDark,
                  strokeWidth: AppSize.s0_8,
                ),
                const SizedBox(
                  height: AppSize.s36,
                ),
                Text(
                  title,
                  style: titleStyle ??
                      TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: AppSize.s12,),
                  maxLines: titleMaxLines ?? AppSize.s2.toInt(),
                ),
                const SizedBox(
                  height: AppSize.s8,
                ),
              ],
            ),
          )),
    );
  }
}
