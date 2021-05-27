import 'package:flutter/material.dart';
import 'package:stockalerts/Modules/Stock.dart';
import 'package:stockalerts/Pages/Analysis.dart';

class StockList extends StatelessWidget {
  List<Stock> stocks;

  StockList({required this.stocks});

  @override
  Widget build(BuildContext context) {
    var len = stocks.length > 100 ? 100 : stocks.length;
    return ListView.separated(
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Stock_Analytics_(stock.symbol)),
              );
            },
            contentPadding: EdgeInsets.all(10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${stock.symbol}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${stock.name}",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${stock.type}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${stock.exchange}",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
          );
        },
        itemCount: len);
  }
}
