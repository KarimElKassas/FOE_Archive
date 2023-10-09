import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foe_archive/data/models/tag_model.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_cubit.dart';
import 'package:foe_archive/presentation/archived_letter/bloc/archived_letter_states.dart';
import 'package:popover/popover.dart';

import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';

class MentionAutocompleteOptions extends StatelessWidget {
  const MentionAutocompleteOptions({
    Key? key,
    required this.cubit,
    required this.query,
    required this.onMentionUserTap,
  }) : super(key: key);
  final ArchivedLettersCubit cubit;
  final String query;
  final ValueSetter<TagModel> onMentionUserTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArchivedLettersCubit, ArchivedLettersStates>(
      bloc: cubit,
      listener: (context, state){},
      builder: (context,state){
        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: cubit.filteredTags.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final tag = cubit.filteredTags.elementAt(i);
                    return ListTile(
                      dense: true,
                      title: Text(tag.tagName),
                      onTap: () => onMentionUserTap(tag),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class MultiStyleTextEditingController extends TextEditingController {

  ArchivedLettersCubit cubit;
  BuildContext parentContext;
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
        TextStyle? style,
        required bool withComposing}) {
    // Let's break our text into blocks divided by spaces
    final words = text.split(' ');
    final textSpanChildren = <TextSpan>[];

    // Add your text styling rules
    for (final word in words) {
      TextStyle wordStyle;
      if (word == 'blue') {
        wordStyle = TextStyle(color: Colors.blue);
      } else if (word == 'italic') {
        wordStyle = TextStyle(color: Colors.black, fontStyle: FontStyle.italic);
      }else if(word.startsWith('@')){
        final int atSymbolIndex = text.lastIndexOf('@');
        if (atSymbolIndex != -1) {
          final int spaceIndex = text.indexOf(' ', atSymbolIndex);
          final int endIndex = spaceIndex != -1 ? spaceIndex : text.length;
          final String mention = text.substring(atSymbolIndex, endIndex);
          //cubit.di

          print(mention);
          wordStyle = TextStyle(color: Colors.amber);
        }else{
          wordStyle = TextStyle(color: Colors.white);

        }
      } else {
        wordStyle = TextStyle(color: Colors.white);
      }
      final child = TextSpan(text: word, style: wordStyle);
      textSpanChildren.add(child);
      // Add the space back in
      textSpanChildren.add(TextSpan(text: ' '));
    }
    return TextSpan(children: textSpanChildren);
  }

  MultiStyleTextEditingController(this.parentContext,this.cubit);
}