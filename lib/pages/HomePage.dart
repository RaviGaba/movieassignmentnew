import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movieassignmentnew/utils/Toast.dart';
import 'package:movieassignmentnew/utils/custom_progress_dialog.dart';
import 'package:movieassignmentnew/podo/movies_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movieassignmentnew/utils/Constants.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageState();
  }
}

class HomePageState extends State<Homepage> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  TextEditingController searchQuery;
  Timer searchOnStoppedTyping;
  String searchQueryString = "Search query";
  String initialMessage = "Tap on 🔎 \nto search movies";
  BuildContext buildContext;
  var movieModelList = List<MovieModel>();

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? BackButton() : null,
        title: _isSearching ? buildSearchField() : Text("Home Page"),
        centerTitle: true,
        actions: buildActions(),
      ),
      body: movieModelList.length > 0
          ? StaggeredGridView.countBuilder(// used external staggered grid view lib
        crossAxisCount: 4,
        itemCount: movieModelList.length,
        itemBuilder: (BuildContext context, int index) => Container(
            color: Colors.white,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                movieModelList[index].posterUrl.compareTo("N/A") == 0
                    ? Container(
                  color: Colors.white,
                  height: 300,
                  child: Center(
                    child: Text("Poster\nNot\nAvailable",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 22.0,
                            letterSpacing: 2.0),
                        textAlign: TextAlign.center),
                  ),
                )
                    : Image.network(movieModelList[index].posterUrl),
                Container(
                  color: Colors.black.withOpacity(0.7),
                  height: 50,
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Text(
                        movieModelList[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        movieModelList[index].year,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
        staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      )
          : Container(
        color: Colors.white,
        child: Center(
          child: Text(initialMessage, style: TextStyle(color: Colors.grey,fontSize: 22.0,letterSpacing: 1.5,height: 2.0),textAlign: TextAlign.center,),
        ),
      ),
    );
  }


  List<Widget> buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (searchQuery == null || searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: startSearch,
      ),
    ];
  }

  Widget buildSearchField() {
    return new TextField(
      controller: searchQuery,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }


  void updateSearchQuery(String newQuery) {
    // here we will implement search movie api
    const duration = Duration(milliseconds:2000); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }

    setState(() {
      searchOnStoppedTyping = new Timer(duration, (){
        searchMovie(newQuery); // search movie method
      });
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchQuery.clear();
    });
  }

  void startSearch() {
    print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchQuery = new TextEditingController();
  }

  void Function() searchMovie(String newQuery) {
    searchQueryString = newQuery;
    if (newQuery.trim().length == 0) {
      initialMessage = "Tap on 🔎 \nto search movies";
      movieModelList.clear();
    } else {
      var dialog = CustomProgressDialog(
        message: "Searching Movies",
      );
      showDialog(
          barrierDismissible: false,
          context: buildContext,
          builder: (BuildContext context) => dialog);
      getMovieList(newQuery);
    }
  }

  Future<List<MovieModel>> getMovieList(String query) async {
    String url = "${API_URL}type=movie&s=${query}";
    var res = await http.get(url);

    final responseJson = json.decode(res.body);
    String responseData = responseJson['Response'] as String;

    Navigator.pop(buildContext); // dismiss progress dialog

    if (responseData.compareTo("True") == 0) {
      // success case
      var search = responseJson['Search'] as List;
      movieModelList =
          search.map<MovieModel>((json) => MovieModel.fromJson(json)).toList();
    } else {
      // error case
      initialMessage = responseJson['Error'] as String;
      showToast(responseJson['Error'] as String);
      movieModelList.clear();
      setState(() {
      });
    }
    setState(() {});
  }
}