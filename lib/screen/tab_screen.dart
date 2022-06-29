import 'package:flutter/material.dart';
import 'package:social_media_app/screen/post_screen.dart';
import 'package:social_media_app/screen/profile_screen.dart';
import 'package:social_media_app/screen/user_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  Color changeColor = Colors.red;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: Colors.blueGrey,
          padding: const EdgeInsets.all(2),
          height: 50,
          child: TabBar(
            indicator: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            controller: tabController,
            tabs: [
              tabColumn(imagePath: "assets/home.png"),
              tabColumn(imagePath: "assets/users.png"),
              tabColumn(imagePath: "assets/profile.png")
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                centerTitle: true,

                title: const Text('Post',style: TextStyle(fontSize: 23,fontStyle: FontStyle.italic),),

              ),
              body: const PostScreen(),
            ),
            Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  centerTitle: true,
                  elevation: 15,
                  title: const Text('Users',style: TextStyle(fontSize: 22,fontStyle: FontStyle.italic),),
              ),
              body: const UserScreen(),
            ),
            Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  centerTitle: true,
                  elevation: 15,
                  title: const Text('Profile',style: TextStyle(fontSize: 22,fontStyle: FontStyle.italic),),
              ),
              body: const ProfileScreen(),
            ),
          ],
        ));
  }
}

tabColumn({
  String imagePath = "",
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset(
          imagePath,
          width: 30,
          height: 30,
        ),
      ),
    ],
  );
}
