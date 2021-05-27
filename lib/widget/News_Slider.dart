import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockalerts/API/Config.dart';
import 'package:stockalerts/Modules/News.dart';
import 'package:stockalerts/widget/Card.dart';

import 'package:http/http.dart' as http;

class News_Slider extends StatefulWidget {
  String symbol;

  News_Slider(this.symbol);

  @override
  _News_Slider_State createState() => _News_Slider_State();
}

class _News_Slider_State extends State<News_Slider> {
  TextEditingController controller = new TextEditingController();

  List<News> _news_fetched = [];
  bool loading = true;

  Future<List<News>> getNewsDetails() async {
    List<News> fetched_news = [];
    Uri url = Uri.parse(Config.prefix_url +
        "stock/" +
        widget.symbol.toString().toLowerCase() +
        "/news?token=Tpk_ed17789aa23448839382da6aa7e173b9");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);

      for (var i = 0; i < data.length; i++) {
        // var new_type = "-";
        // if (data[i]['type'] != null) {
        //   new_type = data[i]['type'].toString();
        // }
        debugPrint(data.length.toString());
        fetched_news.add(News(
            datetime: int.parse(data[i]['datetime'].toString()),
            headline: data[i]['headline'].toString(),
            imageUrl: data[i]['image'].toString(),
            provider: data[i]['provider'].toString(),
            qmUrl: data[i]['url'].toString(),
            source: data[i]['source'].toString()));
      }
    } else {
      fetched_news.add(
        News(
            datetime: 0,
            headline: "Check Connection",
            imageUrl: "",
            provider: "",
            qmUrl: "",
            source: ""),
      );
    }
    return fetched_news;
  }

  @override
  void initState() {
    super.initState();

    getNewsDetails().then((fetched_news) => setState(() {
          this._news_fetched = []..addAll(fetched_news);
          this.loading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 45),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.separated(
              itemBuilder: (context, index) {
                final news = _news_fetched[index];
                return News_Card(
                  news: news,
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey,
                );
              },
              itemCount: _news_fetched.length),
        )
      ],
    );
  }
}
