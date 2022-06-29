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
        //itemLength = _postsJson.length;
        print(_postsJson);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: itemLength,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    NetworkImage(_postsJson["picture"]),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      /// User First Name
                      Text(
                        "${_postsJson["firstName"]}",
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                      const SizedBox(width: 3),

                      /// User Last Name
                      Text(
                        "${_postsJson["lastName"]}",
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
    );
  }
}
