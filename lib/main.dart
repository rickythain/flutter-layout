import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
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

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    setState(() {
      _threads = data;
    });

    print(_threads.length);
    print(_threads[0]['id']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readJson();
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
                                backgroundColor: Colors.white,
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
                                children: [
                                  Container(
                                    child: Text(_threads[index]
                                            ['last_seen_time'] ??
                                        "none"),
                                  ),
                                  Container(
                                    child: Text(_threads[index]['messages']
                                            .toString() ??
                                        "0"),
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
