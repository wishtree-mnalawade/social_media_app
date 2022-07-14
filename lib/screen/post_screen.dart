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
  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMore);
    _firstLoad();
  }

  late ScrollController _controller;
  final _baseUrl = 'https://dummyapi.io/data/v1/post';

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
                    child: ListView.builder(
                        controller: _controller,
                        itemCount: itemLength,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 2, 5, 5),
                            child: Container(
                              width: 100,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    /// post image set as background for container.
                                    _posts["data"][index]["image"],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.white.withOpacity(0.2),
                                    ],
                                    stops: const [0.1,1],
                                    begin: Alignment.centerLeft


                                  )
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 167, 5, 5),
                                      child: Row(
                                        children: [
                                          /// profile image
                                          CircleAvatar(
                                            radius: 15.0,
                                            backgroundImage: NetworkImage(
                                                _posts["data"][index]["owner"]
                                                    ["picture"]),
                                            backgroundColor: Colors.transparent,
                                          ),
                                          const SizedBox(width: 5),

                                          /// User First Name
                                          Text(
                                            "${_posts["data"][index]["owner"]["firstName"]}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          const SizedBox(width: 3),

                                          /// User Last Name
                                          Text(
                                            "${_posts["data"][index]["owner"]["lastName"]}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Row(
                                        /// User Member Like
                                        children: [
                                          Image.asset(
                                            "assets/like1.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            "${_posts["data"][index]["likes"]} ",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //  child: Text("FirstName: ${_postsJson["data"][index]["firstName"]} \n\n lastName: ${_postsJson["data"][index]["firstName"]}\n"),
                            ),
                          );
                        }),
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
