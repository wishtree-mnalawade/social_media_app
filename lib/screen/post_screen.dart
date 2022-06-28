import 'package:flutter/material.dart';

import '../Api/api_services.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Map _postsJson ={};

  // void fetchData() async {
  //   final response = await get(
  //       Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  //   final data = jsonDecode(response.body) as List;
  //   // print (data);
  //
  //   setState(() {
  //     _postsJson = data;
  //   });
  // }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    ApiServices.fetchData().then((value) {
      setState(() {
        _postsJson = value;
        print(_postsJson["data"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
          itemCount: _postsJson.length,
          itemBuilder: (context, index) {


            return Container(
              child: Text("FirstName: ${_postsJson["data"][index]["firstName"]} \n\n lastName: ${_postsJson["data"][index]["firstName"]}\n"),

            );
          }),
    );
  }
}