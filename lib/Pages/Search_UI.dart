import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:stockalerts/API/Config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stockalerts/Modules/Stock.dart';
import 'package:stockalerts/widget/StockList.dart';

class Search_UI extends StatefulWidget {
  @override
  _Search_UI_State createState() => _Search_UI_State();
}

class _Search_UI_State extends State<Search_UI> {
  TextEditingController controller = new TextEditingController();

  List<Stock> _initial_stocks = [];
  List<Stock> _stocks_searched = [];
  bool loading = true;

  Future<List<Stock>> getStockDetails() async {
    List<Stock> fetched_stocks = [];
    Uri url = Uri.parse(Config.prefix_url + Config.basic_symbol_data);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      debugPrint(data.length.toString());
      for (var i = 0; i < data.length; i++) {
        var new_type = "-";
        if (data[i]['type'] != null) {
          new_type = data[i]['type'].toString();
        }
        fetched_stocks.add(
          Stock(
              symbol: data[i]['symbol'].toString(),
              name: data[i]['name'].toString(),
              exchange: data[i]['exchange'].toString(),
              type: new_type),
        );
      }
    } else {
      fetched_stocks.add(
          Stock(symbol: "Check Connection", name: "", exchange: "", type: ""));
    }
    return fetched_stocks;
  }

  @override
  void initState() {
    super.initState();

    getStockDetails().then((fetched_stocks) => setState(() {
          this._initial_stocks = fetched_stocks;
          this._stocks_searched = []..addAll(_initial_stocks);
          this.loading = false;
        }));
  }

  Future<void> _pullRefresh() async {
    setState(() {
      this.loading = true;
    });
    getStockDetails().then((fetched_stocks) => setState(() {
          this._initial_stocks = fetched_stocks;
          this._stocks_searched = []..addAll(_initial_stocks);
          this.loading = false;
        }));
  }

  onSearchTextChanged(String text) async {
    this._stocks_searched.clear();

    if (text.isEmpty) {
      setState(() {
        this._stocks_searched = []..addAll(_initial_stocks);
      });
      return;
    }

    this._initial_stocks.forEach((stock) {
      if (stock.symbol.toLowerCase().contains(text.toLowerCase()) ||
          stock.name.toLowerCase().contains(text.toLowerCase()))
        this._stocks_searched.add(stock);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    String formattedDate = DateFormat.yMMMMEEEEd().format(now);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
              child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "TradePick4U",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formattedDate.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 50,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  controller: controller,
                                  onChanged: onSearchTextChanged,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      hintText: "Search",
                                      fillColor: Colors.grey[800],
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none))),
                                )),
                          ),
                          if (loading) CircularProgressIndicator(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: StockList(
                              stocks: this._stocks_searched,
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: const Color(0xff010114)),
              ),
              onRefresh: _pullRefresh),
          // SlidingUpPanel(
          //   color: Color.fromRGBO(0, 0, 0, 70),
          //   minHeight: 40,
          //   maxHeight: MediaQuery.of(context).size.height * 0.66,
          //   borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(35.0),
          //       topRight: Radius.circular(35.0)),
          //   panel: News_Slider(),
          // )
        ],
      ),
    );
  }
}
