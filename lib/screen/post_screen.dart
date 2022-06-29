import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Api/api_services.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map _postsJson = {};
  int itemLength = 0;

  @override

  /// get data from API post data
  initState() {
    // TODO: implement initState
    super.initState();
    ApiServices.fetchPostData().then((value) {
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
      body: ListView.builder(
          itemCount: itemLength,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                width: 100,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(
                        /// post image set as background for container.
                        _postsJson["data"][index]["image"],
                      ),
                      fit: BoxFit.cover,
                      opacity: 50),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          /// profile image
                          CircleAvatar(
                            radius: 15.0,
                            backgroundImage: NetworkImage(
                                _postsJson["data"][index]["owner"]["picture"]),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 5),

                          /// User First Name
                          Text(
                            "${_postsJson["data"][index]["owner"]["firstName"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 3),

                          /// User Last Name
                          Text(
                            "${_postsJson["data"][index]["owner"]["lastName"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 85,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Row(
                        children: [
                          Flexible(
                            /// User Post Name
                            child: Text(
                              "${_postsJson["data"][index]["text"]}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: Colors.white),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                      child: Row(
                        /// User Member Like
                        children: [
                          Image.asset(
                            "assets/like1.png",
                            width: 30,
                            height: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${_postsJson["data"][index]["likes"]} Member likes",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                //  child: Text("FirstName: ${_postsJson["data"][index]["firstName"]} \n\n lastName: ${_postsJson["data"][index]["firstName"]}\n"),
              ),
            );
          }),
    );
  }
}
