import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Conference>> fetchConferences() async {
  final response = await http.get(
      "https://raw.githubusercontent.com/tech-conferences/conference-data/master/conferences/2019/android.json");
  if (response.statusCode == 200) {
    return json
        .decode(response.body)
        .map<Conference>((conf) => Conference.fromJson(conf))
        .toList();
  } else {
    throw Exception("bad response");
  }
}

class Conference {
  final String name;
  final String url;
  final String startDate;
  final String endDate;
  final String city;
  final String country;
  final String cpfUrl;
  final String cpfEndDate;

  Conference(
      {this.name,
      this.url,
      this.city,
      this.country,
      this.startDate,
      this.endDate,
      this.cpfUrl,
      this.cpfEndDate});

  factory Conference.fromJson(Map<String, dynamic> json) {
    return Conference(
        name: json['name'],
        url: json['url'],
        city: json['city'],
        country: json['country'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        cpfUrl: json['cpfUrl'],
        cpfEndDate: json['cpfEndDate']);
  }
}

void main() => runApp(ConfistadorApp());

class ConfistadorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Confistador',
      theme: ThemeData(
        fontFamily: 'Raleway',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
          subtitle: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        ),
        primarySwatch: Colors.blue,
      ),
      home: ConferencesListScreen(
        title: 'Flutter Demo Home Page  Hot Reload',
        conferences: fetchConferences(),
      ),
    );
  }
}

class ConferencesListScreen extends StatelessWidget {
  final String title;
  final Future<List<Conference>> conferences;

  ConferencesListScreen({Key key, this.title, this.conferences})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Conference>>(
          future: conferences,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Conf clicked: ${snapshot.data[index].name}',
                        )));
                      },
                      title: Text("${snapshot.data[index].name}",
                      style:  TextStyle(fontSize: 18.0)),
                      subtitle: Text(
                        "${snapshot.data[index].city} | ${snapshot.data[index].country}",
                        style: TextStyle(
                            fontSize: 15.0, fontStyle: FontStyle.italic),
                      ),
                      leading: Icon(Icons.account_balance),
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("Fetch error");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text('Add conf')));
            },
            tooltip: 'Click me',
            child: Icon(Icons.add),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
