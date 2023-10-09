import 'package:flutter/material.dart';
import 'package:foe_archive/resources/color_manager.dart';

import '../../resources/values_manager.dart';

Widget loadingIndicator(){
  return CircularProgressIndicator(color: ColorManager.goldColor, strokeWidth: AppSize.s0_8,);
}