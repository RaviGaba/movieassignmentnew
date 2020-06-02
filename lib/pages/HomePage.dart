import 'dart:io';

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? BackButton() : null,
        title: _isSearching ? buildSearchField() : Text("Home Page"),
        centerTitle: true,
        actions: buildActions(),
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

}