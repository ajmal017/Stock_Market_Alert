import 'package:flutter/material.dart';
import 'package:stockalerts/Modules/News.dart';
import 'package:url_launcher/url_launcher.dart';

class News_Card extends StatelessWidget {
  News news;

  News_Card({required this.news});

  @override
  Widget build(BuildContext context) {
    var datetime = DateTime.fromMillisecondsSinceEpoch(news.datetime);
    return Card(
      elevation: 10,
      color: Colors.black54,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        height: 120,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://picsum.photos/250?image=9"),
                  ),
                ),
              ),
              flex: 2,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${news.headline.toString()}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Date : " +
                            "${datetime.year}-${datetime.month}-${datetime.day}",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.lightBlue),
                      ),
                      Text(
                        "Provider : " + "${news.provider.toString()}",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      Text(
                        "Source : " + "${news.source.toString()}",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: Container(
                color: Colors.black54,
                child: IconButton(
                  icon: Icon(Icons.collections_bookmark_outlined),
                  iconSize: 50,
                  color: Colors.white,
                  tooltip: 'Refresh',
                  onPressed: () async {
                    var url = "https:www.google.com"; // news.qmUrl.toString();
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
              ),
              // child: Container(
              //   color: Colors.white,
              //   child: FittedBox(
              //     fit: BoxFit.fill,
              //     child: TextButton(
              //       onPressed: () async {
              //         var url =
              //             "https:www.google.com"; // news.qmUrl.toString();
              //         if (await canLaunch(url)) {
              //           await launch(url);
              //         }
              //       },
              //       child: Container(child: Icon(Icons.collections_bookmark,color: Colors.white,)),
              //     ),
              //   ),
              // ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
