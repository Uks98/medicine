import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine/components/constant.dart';

class TodayPage extends StatelessWidget {
   TodayPage({Key? key}) : super(key: key);
  final list = [
    "sdaada",
    "sdaada",
    "sdaada",
    "sdaada",
    "sdaada",
    "sdaada",
    "sdaada",
    "sdaada",
    "sdaada",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "오늘 복용할 약은?",
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(
          height: regularSpace,
        ),
        Divider(
          height: 1,
          thickness:2.0,
        ),
        Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: regularSpace),
              separatorBuilder: (context,index){
                return const Divider(
                  thickness: 1,
                  height: regularSpace,
                );
              },
              itemBuilder: (context,index){
                return MedicineListTile(name: list[index]);
              }, itemCount: list.length,
        ))
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      child: Row(
        children: [
          CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: CircleAvatar(
                radius: 40,
              )),
          SizedBox(
            width: smallSpace,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "08:30",
                    style: textStyle,
                  ),
                  SizedBox(height: 6,),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "$name,",
                        style: textStyle,
                      ),
                      TileActionButton(
                        title: '지금',
                        onTap: () {},
                      ),
                      Text(
                        "|",
                        style: textStyle,
                      ),
                      TileActionButton(
                        title: '아까',
                        onTap: () {},
                      ),
                      Text(
                        "먹었어요",
                        style: textStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          CupertinoButton(
              onPressed: () {}, child: Icon(CupertinoIcons.ellipsis_vertical))
        ],
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    this.textStyle,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final TextStyle? textStyle;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.bold);
    return GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("$title", style: buttonTextStyle),
        ));
  }
}
