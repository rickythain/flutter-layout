import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _threads = [];
  var _listCap = 20;
  var _listViewController = ScrollController();

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      _threads = data;
    });
  }

  @override
  void initState() {
    super.initState();

    _listViewController.addListener(() {
      if (_listViewController.position.atEdge) {
        if (_listViewController.position.pixels == 0) {
        } else {
          setState(() {
            _listCap += 10;
          });
          // print("reach end " + _listCap.toString());
        }
      }
    });

    readJson();
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SafeArea(
          child: _threads.isNotEmpty
              ? ListView.builder(
                  controller: _listViewController,
                  itemCount: _listCap,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey))),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 40,
                                backgroundImage: NetworkImage(_threads[index]
                                        ['avatar'] ??
                                    "http://cdn.onlinewebfonts.com/svg/img_364496.png"),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(_threads[index]['first_name'] +
                                      " " +
                                      _threads[index]['last_name']),
                                  Text(_threads[index]['username']),
                                  Text(_threads[index]['status'] ?? "status",
                                      style: TextStyle(color: Colors.grey))
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Text(_threads[index]
                                            ['last_seen_time'] ??
                                        "none"),
                                  ),
                                  Container(
                                    child: _threads[index]['messages'] != null
                                        ? CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            child: Text((_threads[index]
                                                        ['messages'] ??
                                                    "")
                                                .toString()),
                                          )
                                        : Container(),
                                  )
                                ],
                              ),
                              flex: 2,
                            )
                          ],
                        ));
                  })
              : Container()),
    );
  }
}
