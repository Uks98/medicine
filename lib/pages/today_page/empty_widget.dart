import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine/components/constant.dart';


class TodayEmpty extends StatelessWidget {
  const TodayEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Center(child: Text("추가된 약이 없습니다.")),
          Text("약을 추가해주세요",style: Theme.of(context).textTheme.subtitle1,),
          const Icon(CupertinoIcons.arrow_down),
          const SizedBox(
            height: largeSpace,
          )
        ],
      ),
    );
  }
}
