import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/defaultlayout.dart';
import 'package:actual/product/view/product_screen.dart';
import 'package:flutter/material.dart';

import '../../restaurant/view/restaurant_screen.dart';
class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  int index = 0 ;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }
   @override
  void dispose() {
    // TODO: implement dispose
    controller.removeListener(tabListener);
     super.dispose();
  }
    void tabListener(){
      setState(() {
        index= controller.index;
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
        child: TabBarView(

          // 탭 안에서 움직이지 않게하기위해서
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              RestaurantScreen(),
              ProductScreen(),
              Center(child: Container(child: Text('주문'))),
              Center(child: Container(child: Text('프로필'))),
        ]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize:10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.shifting,
        onTap: (int index){
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
          label: '홈')  ,
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined),
              label: '음식')  ,
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: '주문')  ,
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: '프로필')  ,
        ],
      ),
    );
  }
}
