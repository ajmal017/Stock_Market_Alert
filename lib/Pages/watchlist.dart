import 'package:flutter/material.dart';
import 'package:stockalerts/widget/AlertCard.dart';
import 'package:stockalerts/widget/FilteredStockList.dart';

class watchlist extends StatefulWidget {
  @override
  _watchlistState createState() => _watchlistState();
}

class _watchlistState extends State<watchlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: const Color(0xff010114),
                  child: Column(
                    children: [
                      Text(
                        "WATCH LIST",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: FilteredStockList(2),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: AlertCard(),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Container(
                        color: const Color(0xff010114),
                        child: IconButton(
                          icon: Icon(Icons.refresh_sharp),
                          iconSize: 50,
                          color: Colors.white,
                          tooltip: 'Refresh',
                          onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        super.widget))
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
