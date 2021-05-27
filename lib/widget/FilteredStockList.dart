import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:stockalerts/API/Config.dart';
import 'package:stockalerts/DB/DB.dart';
import 'package:stockalerts/Modules/Stock.dart';
import 'package:http/http.dart' as http;
import 'package:stockalerts/widget/News_Slider.dart';
import 'package:stockalerts/widget/StockList.dart';

class FilteredStockList extends StatefulWidget {
  var filter;

  FilteredStockList(int i) {
    this.filter = i;
  }

  @override
  _FilteredStockListState createState() => _FilteredStockListState();
}

class _FilteredStockListState extends State<FilteredStockList> {
  List symbol_filtered = [];
  List<Stock> _initial_stocks = [];
  List<Stock> _stocks_filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    debugPrint("Ran");
    get_symbols(widget.filter).then((value) => {
          getAllStocks().then((value) => {
                this._initial_stocks = value,
                debugPrint(
                  value.toString(),
                ),
                for (Stock stock in this._initial_stocks)
                  {
                    if (symbol_filtered.contains(stock.symbol.toString()))
                      {
                        _stocks_filtered.add(stock),
                      },
                  },
                debugPrint(this._stocks_filtered.toString()),
                setState(() => {this.loading = false})
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(
            color: Colors.white,
          ),
          if (this.loading) CircularProgressIndicator(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.36,
            child: StockList(
              stocks: this._stocks_filtered,
            ),
          ),
        ],
      ),
    );
  }

  Future<List> get_symbols(int filter) async {
    List l = [];
    await DB.is_user_exists(DB.email).then((value) => {
          if (value)
            {
              DB.filterSymbols(DB.email, filter).then(
                    (list) => {
                      debugPrint(list.toString()),
                      l.addAll(list),
                      setState(() => {
                            this.symbol_filtered = list,
                          })
                    },
                  ),
            }
        });

    return l;
  }

  Future<List<Stock>> getAllStocks() async {
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
}
