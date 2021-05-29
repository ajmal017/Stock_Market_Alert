import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockalerts/DB/DB.dart';
import 'package:url_launcher/url_launcher.dart';

class Signals extends StatefulWidget {
  @override
  _SignalsState createState() => _SignalsState();
}

class _SignalsState extends State<Signals> {
  var _type = [
    ["spac", "SPAC PICKS"],
    ["lmcapick", "LARGECAP/MIDCAPS SWING PICKS"],
    ["longterm", "LONG TERM PICKS"],
    ["options", "OPTIONS PICKS"],
    ["daytrade", "DAYTRADE PICKS"],
    ["smallcaps", "SMALLCAPS SWING TRADE PICKS"],
  ];
  var _selected = "spac";

  var text = "";
  List dataList = [];
  List currentDataList = [];
  var MainList = [];
  int page = 1;
  int pageCount = 5;
  int startAt = 0;
  int endAt = 0;
  int totalPages = 0;

  void SetTo(var value) {
    currentDataList = [];
    for (var i = 0; i < MainList.length; i++) {
      if (MainList[i][1]['type'] == value) {
        print(MainList[i][1]['type']);
        currentDataList.add(MainList[i]);
      }
    }
    setState(() => {});

    print('MainList');
    print(currentDataList);
    print(currentDataList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DB.getsignals().then((value) => {
          print(value.toString()),
          this.MainList = value,
          this.MainList.sort((a, b) => a[0].compareTo(b[0])),
          this.MainList = this.MainList.reversed.toList(),
          SetTo("spac"),
        });
  }

  void loadPreviousPage() {
    if (page > 1) {
      setState(() {
        startAt = startAt - pageCount;
        endAt = page == totalPages
            ? endAt - currentDataList.length
            : endAt - pageCount;
        currentDataList = dataList.getRange(startAt, endAt).toList();
        page = page - 1;
      });
    }
  }

  void loadNextPage() {
    if (page < totalPages) {
      setState(() {
        startAt = startAt + pageCount;
        endAt = dataList.length > endAt + pageCount
            ? endAt + pageCount
            : dataList.length;
        currentDataList = dataList.getRange(startAt, endAt).toList();
        page = page + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("---------");
    print(currentDataList);
    return Scaffold(
      backgroundColor: Color(0xff010114),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButton(
                      value: _selected,
                      onChanged: (String? newValue) {
                        print(newValue);
                        setState(() {
                          _selected = newValue!;
                        });
                        SetTo(newValue);
                      },
                      items: _type.map((value) {
                        return DropdownMenuItem(
                          child: new Text(
                            value[1],
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                          value: value[0],
                        );
                      }).toList(),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     IconButton(
                    //       onPressed: page > 1 ? loadPreviousPage : null,
                    //       icon: Icon(Icons.arrow_back_ios,
                    //           size: 35, color: Colors.white),
                    //     ),
                    //     Text(
                    //       "$page / $totalPages",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     IconButton(
                    //       onPressed: page < totalPages ? loadNextPage : null,
                    //       icon: Icon(
                    //         Icons.arrow_forward_ios,
                    //         size: 35,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: currentDataList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: new Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    currentDataList[index][1]["company_name"],
                                    style: TextStyle(
                                        color: Colors.blue[900], fontSize: 19),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.engineering),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                          'Entry Price :' +
                                              currentDataList[index][1]
                                                  ["entry_price"],
                                          style: new TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.lock_clock),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                            'Entry Time : ' +
                                                currentDataList[index][1]
                                                    ["entry_date"],
                                            style:
                                                new TextStyle(fontSize: 12.0)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.exit_to_app),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                          'Exit Price : ' +
                                              currentDataList[index][1]
                                                  ["exit_price"],
                                          style: new TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.lock_clock_sharp),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                            'Exit Time : ' +
                                                currentDataList[index][1]
                                                    ["exit_date"],
                                            style:
                                                new TextStyle(fontSize: 12.0)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.money),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                          'Price taget : ' +
                                              currentDataList[index][1]
                                                  ["price_target"],
                                          style: new TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.stop),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                            'Stop Loss : ' +
                                                currentDataList[index][1]
                                                    ["stop_loss"],
                                            style:
                                                new TextStyle(fontSize: 12.0)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.accessibility),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                          'Confidence Index : ' +
                                              currentDataList[index][1]
                                                  ["confidence_index"],
                                          style: new TextStyle(fontSize: 12.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child:
                                            new Icon(Icons.insert_drive_file),
                                      ),
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Text(
                                            'Posted On : ' +
                                                DateTime.fromMillisecondsSinceEpoch(
                                                        int.parse(
                                                            currentDataList[
                                                                index][0]))
                                                    .toString(),
                                            style:
                                                new TextStyle(fontSize: 12.0)),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.all(7.0),
                                        child: new Icon(Icons.link),
                                      ),
                                      new Padding(
                                          padding: new EdgeInsets.all(7.0),
                                          child: RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .greenAccent[700]),
                                                  text: 'Resource',
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          var url = currentDataList[
                                                                  index][1][
                                                              'resource']; // news.qmUrl.toString();
                                                          if (await canLaunch(
                                                              url)) {
                                                            await launch(url);
                                                          }
                                                        },
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      new Container(
                                        padding: const EdgeInsets.all(16.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: new Column(
                                          children: <Widget>[
                                            new Text(
                                              "Comment",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                            ),
                                            new Text(
                                              currentDataList[index][1]
                                                  ['comment'],
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
