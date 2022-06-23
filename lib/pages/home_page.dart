import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicine/components/colors.dart';
import 'package:medicine/components/constant.dart';
import 'package:medicine/pages/add/add_medicine.dart';
import 'package:medicine/pages/history/history_page.dart';
import 'package:medicine/pages/today_page/today_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final _pageList = [
     TodayPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: SafeArea(child: _pageList[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMedicine,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        elevation: 1.0,
        child: Container(
          color: Colors.white,
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: currentIndex == 1
                        ? Colors.grey[500]
                        : DoryColors.primaryColor,
                  ),
                  onPressed: ()=> _onCurrentPage(0)),
              CupertinoButton(
                  child: Icon(
                    CupertinoIcons.text_badge_checkmark,
                    color: currentIndex == 0
                        ? Colors.grey[500]
                        : DoryColors.primaryColor,
                  ),
                  onPressed: () => _onCurrentPage(1)),
            ],
          ),
        ),
      );
  }

  void _onCurrentPage(int pageIndex) {
                    setState(() {
                      currentIndex = pageIndex;
                    });
                  }

  void _onAddMedicine() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) =>  const AddPage()));
  }
}
