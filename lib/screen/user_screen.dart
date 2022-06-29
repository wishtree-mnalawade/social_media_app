import 'package:flutter/material.dart';

import '../Api/api_services.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map _postsJson = {};
  int itemLength =0;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    ApiServices.fetchUserData().then((value) {
      setState(() {
        _postsJson = value;
        itemLength = _postsJson['data'].length;
       // print(_postsJson);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(itemLength, (index) {
          return Container(
            decoration:  BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                bottom: BorderSide(width:1, color: Colors.lightBlue.shade900),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(_postsJson["data"][index]["picture"]),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// User First Name
                    Text(
                      "${_postsJson["data"][index]["firstName"]}",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),
                    ),
                    const SizedBox(width: 3),

                    /// User Last Name
                    Text(
                      "${_postsJson["data"][index]["lastName"]}",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15

                      ),
                    ),
                  ],
                )

              ],
            ),
          );
        }),
      ),
    );
  }
}
