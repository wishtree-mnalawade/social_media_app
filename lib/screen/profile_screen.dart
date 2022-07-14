import 'package:flutter/material.dart';

import '../Api/api_services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map _postsJson = {};
  int itemLength = 1;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    ApiServices.fetchProfileData().then((value) {
      setState(() {
        _postsJson = value;
      //  itemLength = _postsJson.length;
        print(_postsJson);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      )
    );
  }
}
