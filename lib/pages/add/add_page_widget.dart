import 'package:flutter/material.dart';
import 'package:medicine/components/constant.dart';

class AddPageBody extends StatelessWidget {
  const AddPageBody({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: pagePadding,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: children),
        ));
  }
}

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton({Key? key,required this.onPressed,required this.text}) : super(key: key);

  final VoidCallback? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: submitButtonSpace,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1),
              child:  Text(text),
              onPressed: onPressed,
            ),
          )),
    );
  }
}
