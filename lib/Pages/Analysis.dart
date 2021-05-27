import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockalerts/API/Config.dart';
import 'package:http/http.dart' as http;
import 'package:stockalerts/DB/DB.dart';
import 'package:stockalerts/widget/Graph.dart';
import 'package:stockalerts/widget/News_Slider.dart';

class Stock_Analytics_ extends StatefulWidget {
  final String symbol;

  Stock_Analytics_(this.symbol);

  @override
  _Stock_Analytics_State createState() => _Stock_Analytics_State();
}

class _Stock_Analytics_State extends State<Stock_Analytics_> {
  var date = "-";
  var _news;
  Map<String, dynamic> _quotes = json.decode('{"latesttPrice":"-"}');
  var _charts = [];
  bool _loading = true;
  bool _show_add_to_portfolio = false;
  bool _show_add_to_watchlist = false;
  bool _show_remove_to_portfolio = false;
  bool _show_remove_to_watchlist = false;

  List<String> label = [];
  List<double> value = [];

  List<double> volume = [];

  @override
  void initState() {
    super.initState();

    _show_add_to_portfolio = true;
    _show_add_to_watchlist = false;
    _show_remove_to_portfolio = false;
    _show_remove_to_watchlist = false;
    update_button();
    getDetails().then((list) => setState(() {
          this._news = list[0];
          this._quotes = list[1];
          this._charts = list[2];
          this.date = DateFormat.yMMMMEEEEd().format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(this._quotes["latestUpdate"].toString())));

          this._loading = false;
        }));
  }

  void createdb() {}

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < this._charts.length; i++) {
      var single_data = this._charts.elementAt(i);
      //debugPrint(single_data.toString());
      label.add(single_data["date"].toString());
      value.add(double.parse(single_data["close"].toString()));
    }
    for (var i = 0; i < this._charts.length; i++) {
      var single_data = this._charts.elementAt(i);
      //debugPrint(single_data.toString());
      //label.add(single_data["date"].toString());
      volume.add(double.parse(single_data["volume"].toString()));
    }
    //debugPrint(label.toString());

    var color_perc = Colors.green;
    var perc = this._quotes["changePercent"];
    if (perc != null) {
      double value = double.parse(perc.toString());
      if (value < 0) {
        color_perc = Colors.red;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff010114),
      body: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.symbol,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    this._quotes["companyName"].toString(),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                if (_show_add_to_portfolio)
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => {update_symbol(1)},
                    color: Colors.white,
                    child: Text(
                      "Add To Portfolio",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                if (_show_add_to_watchlist)
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => {update_symbol(2)},
                    color: Colors.white,
                    child: Text(
                      "Add To Watchlist",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                if (_show_remove_to_watchlist)
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => {update_symbol(1)},
                    color: Colors.white,
                    child: Text(
                      "Remove From Watchlist",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                if (_show_remove_to_portfolio)
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () => {update_symbol(0)},
                    color: Colors.white,
                    child: Text(
                      "Remove From Portfolio",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                SizedBox(height: 50),
                Text(
                  "Latest Price  :  " + this._quotes["latestPrice"].toString(),
                  style: TextStyle(color: Colors.lightBlueAccent, fontSize: 25),
                ),
                Text(
                  this.date,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Card(
                  color: Colors.grey[850],
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(this._quotes["open"].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text("Open",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(color: Colors.white70)),
                                Column(
                                  children: [
                                    Text(this._quotes["close"].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text("close",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(color: Colors.white70)),
                                Column(
                                  children: [
                                    Text(
                                        this
                                            ._quotes["changePercent"]
                                            .toString(),
                                        style: TextStyle(
                                            color: color_perc, fontSize: 20)),
                                    Text("Change %",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                                height: 100,
                                child: VerticalDivider(color: Colors.white70)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(this._quotes[""].toString(),
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 20)),
                                    Text("Volume",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(color: Colors.white70)),
                                Column(
                                  children: [
                                    Text(this._quotes["marketCap"].toString(),
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 20)),
                                    Text("Market Cap.",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(color: Colors.white70)),
                                Column(
                                  children: [
                                    Text(this._quotes["week52Low"].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text("Week Low",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                                height: 100,
                                child: VerticalDivider(color: Colors.white70)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(this._quotes["high"].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text("High",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(color: Colors.white70)),
                                Column(
                                  children: [
                                    Text(this._quotes["low"].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text("Low",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                                Container(
                                    width: 60,
                                    child: Divider(color: Colors.white70)),
                                Column(
                                  children: [
                                    Text(this._quotes["week52High"].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                    Text("Week High",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                SizedBox(
                  height: 20,
                  child: Text(
                    "VALUE ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (!this._loading)
                  SizedBox(
                    height: 300,
                    child: Graph(label, value),
                  ),
                Text(
                  "VOLUME",
                  style: TextStyle(color: Colors.white),
                ),
                if (!this._loading)
                  SizedBox(
                    height: 300,
                    child: Graph(label, volume),
                  ),
                News_Slider(widget.symbol),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List> getDetails() async {
    List fetched = [[], {}, []];
    Uri url_all = Uri.parse(
        Config.prefix_url + "stock/" + widget.symbol + "/" + Config.analytics);
    var response_all = await http.get(url_all);
    //debugPrint(response_all.body);
    if (response_all.statusCode == 200) {
      var data = json.decode(response_all.body);
      //fetched[0] = data['news'];
      fetched[1] = data["quote"];
      fetched[2] = data["chart"];
    }

    return fetched;
  }

  Future<void> update_button() async {
    DB.is_user_exists(DB.email).then((value) => {
          if (value)
            {
              DB.hasSymbol(DB.email, widget.symbol).then((value2) => {
                    if (value2)
                      {
                        DB
                            .symbol_val(DB.email, widget.symbol)
                            .then((value3) => {
                                  if (value3 == 0)
                                    {
                                      _show_add_to_portfolio = true,
                                      _show_add_to_watchlist = false,
                                      _show_remove_to_portfolio = false,
                                      _show_remove_to_watchlist = false,
                                    }
                                  else if (value3 == 1)
                                    {
                                      _show_add_to_portfolio = false,
                                      _show_add_to_watchlist = true,
                                      _show_remove_to_portfolio = true,
                                      _show_remove_to_watchlist = false,
                                    }
                                  else if (value3 == 2)
                                    {
                                      _show_add_to_portfolio = false,
                                      _show_add_to_watchlist = false,
                                      _show_remove_to_portfolio = false,
                                      _show_remove_to_watchlist = true,
                                    }
                                  else
                                    {
                                      _show_add_to_portfolio = false,
                                      _show_add_to_watchlist = false,
                                      _show_remove_to_portfolio = false,
                                      _show_remove_to_watchlist = false,
                                    },
                                  setState(
                                    () => {debugPrint("State Changed")},
                                  ),
                                })
                      }
                  })
            }
        });
  }

  Future<void> update_symbol(int to) async {
    DB.is_user_exists(DB.email).then((value) => {
          if (value)
            {
              DB.change_symbol_to(DB.email, widget.symbol, to),
              update_button(),
            }
        });
  }
}
