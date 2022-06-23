import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constant.dart';

class BottomSheetBody extends StatelessWidget {
   BottomSheetBody({Key? key,required this.children}) : super(key: key);
   List<Widget> children = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
        padding: pagePadding,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children)));
    }
}

void showPermissionDenied(BuildContext context,{required String permission}){
   //1. 알람추가
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text("$permission 권한이 없습니다"),
            const TextButton(
              onPressed: openAppSettings, //알람 권한 설정창으로 이동
              child: Text("설정창으로 이동"),
            ),
          ],
        ),
      ),
    );
}