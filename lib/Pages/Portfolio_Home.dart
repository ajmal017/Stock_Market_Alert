import 'package:flutter/material.dart';
import 'package:stockalerts/Pages/AboutUs.dart';
import 'package:stockalerts/Pages/Search_UI.dart';
import 'package:stockalerts/Pages/watchlist.dart';
import 'package:stockalerts/widget/FilteredStockList.dart';

class Porfolio extends StatefulWidget {
  @override
  _PorfolioState createState() => _PorfolioState();
}

class _PorfolioState extends State<Porfolio> {
  int filter = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010114),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: const Color(0xff010114),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Divider(
                        color: Colors.white,
                      ),
                      Text(
                        "TradePick4U",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: const Color(0xff010114),
                              child: Column(
                                children: [
                                  Container(
                                    color: const Color(0xff010114),
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      iconSize: 50,
                                      color: Colors.white,
                                      tooltip: 'Add to Portfolio',
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Search_UI()),
                                        )
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Add to Portfolio",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: const Color(0xff010114),
                              child: Column(
                                children: [
                                  Container(
                                    color: const Color(0xff010114),
                                    child: IconButton(
                                      icon: Icon(Icons.analytics_outlined),
                                      iconSize: 50,
                                      color: Colors.white,
                                      tooltip: 'Watch List',
                                      onPressed: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  watchlist()),
                                        )
                                      },
                                    ),
                                  ),
                                  Text(
                                    "Watchlist",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: const Color(0xff010114),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    color: const Color(0xff010114),
                                    child: Image.network(
                                        'https://cdn.pixabay.com/photo/2013/07/12/14/07/bag-147782_960_720.png'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Text(
                        "MY PORTFOLIO",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      FilteredStockList(this.filter),
                      Divider(
                        color: Colors.white,
                      ),
                      Text(
                        "Source : We use IEX Cloud to Fetch Data",
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
