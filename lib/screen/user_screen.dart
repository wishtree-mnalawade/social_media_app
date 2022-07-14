import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Api/api_services.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMore);
    _firstLoad();
  }

  late ScrollController _controller;
  final _baseUrl = 'https://dummyapi.io/data/v1/user';

  int _page = 0;
  final int _limit = 20;
  int itemLength = 0;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  Map _posts = {};

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
      print('is working');
    });

    final res = await get(Uri.parse("$_baseUrl?page=$_page&limit=$_limit"),
        headers: {"app-id": "62b96b8063ae73811019d4f7"});

    setState(() {
      _posts = json.decode(res.body);
      print(_posts);
      itemLength = _posts['data'].length;
    });
    setState(() {
      _isFirstLoadRunning = false;
      print('first scroll');
      // _isLoadMoreRunning == false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      print('Second Scroll');
      _page = _page + 1; // Increase _page by 1

      try {
        final res = await get(Uri.parse("$_baseUrl?page=$_page&limit=$_limit"),
            headers: {"app-id": "62b96b8063ae73811019d4f7"});

        final fetchedPosts = json.decode(res.body);
        itemLength = _posts['data'].length;

        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts["data"].addAll(fetchedPosts["data"]);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          if (mounted) {
            setState(() {
              _hasNextPage = false;
            });
          }
        }
      } catch (err) {
        print('Something wrong');
        print(err);
      }
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.count(

                      controller: _controller,
                      crossAxisCount: 2,


            children: List.generate(itemLength, (index) {


                        //         child:  ListView.builder(
                        //               controller: _controller,
                        //               itemCount: itemLength,
                        //               itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            // Navigator.push(context, route)
                          },
                          child: Container(

                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.lightBlue.shade900),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blueGrey, spreadRadius: 5)],
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        _posts["data"][index]["picture"]),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// User First Name
                                    Text(
                                      "${_posts["data"][index]["firstName"]}",
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(width: 3),

                                    /// User Last Name
                                    Text(
                                      "${_posts["data"][index]["lastName"]}",
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),

                  // When nothing else to load
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Colors.amber,
                      child: const Center(
                        child: Text('You have fetched all of the content'),
                      ),
                    ),
                ],
              ));
  }
}
