import 'package:flutter/material.dart';
import 'package:stockalerts/DB/DB.dart';
import 'package:stockalerts/DB/SQLITE.dart';

import 'package:stockalerts/Pages/Portfolio_Home.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  int state = 1;

// SignUp
  TextEditingController snameController = new TextEditingController();
  TextEditingController semailController = new TextEditingController();
  TextEditingController spassController = new TextEditingController();
  //Login

  TextEditingController lemailController = new TextEditingController();
  TextEditingController lpassController = new TextEditingController();
  var text = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010114),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "TradePick4U",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "WELCOME",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
              if (state == 1)
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: lemailController,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: lpassController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your password',
                          labelText: 'Password',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => {this.login()},
                        child: Text("Log In Now"),
                      ),
                    ],
                  ),
                ),
              if (state == 2)
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: snameController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your name',
                          labelText: 'Name',
                        ),
                      ),
                      TextFormField(
                        controller: semailController,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: spassController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Enter your password',
                          labelText: 'Password',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => {this.signup()},
                        child: Text("Sign Up Now"),
                      )
                    ],
                  ),
                ),
              MaterialButton(
                color: Colors.lightBlue,
                minWidth: MediaQuery.of(context).size.width * 0.5,
                onPressed: () => {
                  setState(() => {this.state = 1})
                },
                child: Column(
                  children: [Text("Log In")],
                ),
              ),
              MaterialButton(
                color: Colors.lightBlue,
                minWidth: MediaQuery.of(context).size.width * 0.5,
                onPressed: () => {
                  setState(() => {this.state = 2})
                },
                child: Column(
                  children: [Text("Sign Up")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  login() {
    var email = lemailController.text;
    var password = lpassController.text;
    print(email);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      showDialogs("Failed", "Invalid Email ");
      return false;
    }
    DB.login(email, password).then((val) => {
          if (val == true)
            {
              this.text = "success",
              DB.email = email,
              SQLITE.login(email).then((value) => {
                    Navigator.pop(context),
                  })
            }
          else
            {showDialogs("Failed", "Invalid Login ")}
        });
  }

  signup() {
    var name = snameController.text;
    var email = semailController.text;
    var password = spassController.text;
    print(name);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      showDialogs("Failed", "Invalid Email ");
      return false;
    }
    bool nameValid = name.length < 5 ? false : true;
    if (!nameValid) {
      showDialogs("Failed", "Name Min Length 5 ");
      return false;
    }
    bool passValid = password.length < 6 ? false : true;
    if (!passValid) {
      showDialogs("Failed", "Password Min Length 6 ");
      return false;
    }
    DB.signup(name, email, password).then((val) => {
          if (val == true)
            {showDialogs("Success", "Sign Up Success")}
          // {
          //   DB.email = email,
          //   this.text = "success",
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => Porfolio()),
          //   ),
          // }
          else
            {showDialogs("Failed", "Sign Up Failed")}
        });
  }

  showDialogs(String title, String body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title),
          subtitle: Text(body),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
