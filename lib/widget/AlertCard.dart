import 'package:flutter/material.dart';
import 'package:stockalerts/DB/DB.dart';

class AlertCard extends StatefulWidget {
  @override
  _AlertCardState createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  List msg = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init");
    DB.is_user_exists(DB.email).then((value) => {
          DB.getnews(DB.email).then((val) => {
                print(val),
                setState(() => {
                      this.msg = val,
                      this.loading = false,
                    })
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    // List msg = [
    //   {
    //     "title": "ASD",
    //     "body":
    //         "wbn sjdnvjw wegw wefwef wegwg qwfqe ere qwfq wrg qfqeg wrh ef qg wr qw fqeg rw ",
    //     "time": 011201413403
    //   },
    //   {
    //     "title": "Azz",
    //     "body":
    //         "wbsn sjdnvjw wegw wefwef wegwg qwfqe ere qwfq wrg qfqeg wrh ef qg wr qw fqeg rw ",
    //     "time": 012201413403
    //   }
    // ];
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: msg.length,
      itemBuilder: (context, index) {
        var title = '-';
        var body = '-';
        if (msg[index]['title'] != null && msg[index]['body'] != null) {
          title = msg[index]['title'];
          body = msg[index]['body'];
          return Card(
            color: Colors.blue[900],
            child: Column(children: [
              if (loading) CircularProgressIndicator(),
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                msg[index]['time'].toString(),
                style: TextStyle(fontSize: 8, color: Colors.white),
              ),
              Divider(
                color: Colors.black,
              ),
              Text(
                body,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              SizedBox(
                height: 10,
              )
            ]),
          );
        }
        return SizedBox(
          height: 0,
        );
      },
    );
  }
}
