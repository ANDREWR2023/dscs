import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

var client;
var _selectedIndex = 0;
var usernameText = '';
var passwordText = '';
var nameText = '';
var advisorText = '';
var devText = '';
var dayText = '';
var presText = '';
int strikesText = 0;
TextField x = new TextField(
    decoration: InputDecoration(labelText: 'Username'),
    onChanged: (text) {
      usernameText = text;
    });
TextField y = new TextField(
  decoration: InputDecoration(labelText: 'Password'),
  onChanged: (text) {
    passwordText = text;
  },
  obscureText: true,
);
TextField namm = new TextField(
    decoration: InputDecoration(labelText: 'App Name'),
    onChanged: (text) {
      nameText = text;
    });
TextField advis = new TextField(
    decoration: InputDecoration(labelText: 'App Category'),
    onChanged: (text) {
      advisorText = text;
    });
TextField pres = new TextField(
    decoration: InputDecoration(labelText: 'Developer'),
    onChanged: (text) {
      presText = text;
    });

final _controller = TextEditingController();
TextField strikes = new TextField(
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    controller: _controller,
    decoration: InputDecoration(
      labelText: '# of Strikes',
    ),
    onChanged: (text) {
      strikesText = int.parse(_controller.text);
    });

Future<PostgreSQLResult> entries() async {
  var client = PostgreSQLConnection("localhost", 5432, "postgres",
      username: "postgres", password: "123", useSSL: false);
  await client.open();
  PostgreSQLResult a = (await client.query("SELECT * FROM apps"));
  await client.close();
  return a;
}

Future<List<dynamic>> convertPostgreSQLResultToList(entries) async {
  List<List<dynamic>> rows = await entries.toList();
  return rows.map((row) => row.map((value) => value).toList()).toList();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        // This is the theme of your application.

        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();
  final title = 'a';
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final"
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          children: [
            Card(
                color: Color.fromARGB(255, 170, 131, 177),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        x,
                        y,
                      ],
                    ))),
            Row(children: [
              TextButton(
                onPressed: () async {
                  var username = usernameText;
                  var password = passwordText;
                  var type = _selectedIndex;

                  // Connect to the database
                  var client = PostgreSQLConnection(
                      "localhost", 5432, "postgres",
                      username: "postgres", password: "123", useSSL: false);
                  await client.open();
                  PostgreSQLResult a = (await client.query(
                      "SELECT userType FROM users WHERE username = '$username' AND pass = '$password'"));
                  // Close the connection
                  await client.close();

                  // Check the user role
                  if (a.any((row) => row.contains(2))) {
                    print('success');
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminScreen()));
                  } else if (a.any((row) => row.contains(1))) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NormalScreen()));
                  } else if (a.any((row) => row.contains(0))) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NormalScreen()));
                  } else {
                    print('fail');
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Screenfail()));
                  }
                },
                child: Text('Log In'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Screen2()));
                  },
                  child: Text('Create New Account'))
            ])
          ],
        ),
      ),
    ));
  }
}

class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.square),
            label: 'Client',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.square),
            label: 'Developer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.square),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: Center(
        child: Column(
          children: [
            Card(
                color: Color.fromARGB(255, 170, 131, 177),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        x,
                        y,
                      ],
                    ))),
            Row(children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text('Log In To Existing Account')),
              TextButton(
                onPressed: () async {
                  var username = usernameText;
                  var password = passwordText;
                  var type = _selectedIndex;

                  // Connect to the database
                  var client = PostgreSQLConnection(
                      "localhost", 5432, "postgres",
                      username: "postgres", password: "123", useSSL: false);
                  await client.open();
                  await client.query(
                      "INSERT INTO users (username, pass, userType) VALUES ('$username', '$password', $type)");
                  // Close the connection
                  await client.close();

                  // Check the user role
                  if (_selectedIndex == 2) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminScreen()));
                  } else if (_selectedIndex == 1) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NormalScreen()));
                  } else if (_selectedIndex == 0) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NormalScreen()));
                  } else {
                    MaterialPageRoute(builder: (context) => Screenfail());
                  }
                },
                child: Text('Create New Account'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class Screenfail extends StatefulWidget {
  @override
  _ScreenfailState createState() => _ScreenfailState();
}

class _ScreenfailState extends State<Screenfail> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(
          children: [
            Card(
                color: Color.fromARGB(255, 170, 131, 177),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        x,
                        y,
                      ],
                    ))),
            Row(children: [
              TextButton(
                onPressed: () async {
                  var username = usernameText;
                  var password = passwordText;
                  var type = 1;

                  // Connect to the database
                  var client = PostgreSQLConnection(
                      "localhost", 5432, "postgres",
                      username: "postgres", password: "123", useSSL: false);
                  await client.open();
                  PostgreSQLResult a = (await client.query(
                      "SELECT userType FROM users WHERE username = '$username' AND pass = '$password'"));
                  PostgreSQLResult b =
                      (await client.query("SELECT * FROM apps"));
                  // Close the connection
                  await client.close();
                  // Check the user role
                  if (a.any((row) => row.contains(2))) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AdminScreen()));
                    print('success');
                  } else if (a.any((row) => row.contains(1))) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddingScreen()));
                  } else if (a.any((row) => row.contains(0))) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NormalScreen()));
                  } else {
                    print('fail');
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Screenfail()));
                  }
                },
                child: Text('Log In'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Screenfail()));
                  },
                  child: Text('Create New Account'))
            ]),
            Text('Unable to perform requested action - please try again later.')
          ],
        ),
      ),
    ));
  }
}

//this variable has the results in it, but I'm getting an error any time I try to create a list from it

class DevScreen extends StatefulWidget {
  @override
  _DevScreenState createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  void _onItemTapped() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddingScreen()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Card(
          child: FloatingActionButton.large(
            onPressed: _onItemTapped,
            hoverColor: Colors.purple,
            child: Icon(Icons.add),
          ),
        ),
        Container(
            height: MediaQuery.of(context).size.height - 50,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<dynamic>>(
              future: entries(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var row = snapshot.data![index];
                      return ListTile(
                        title: new Center(
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.lightBlueAccent,
                                child: TextButton(
                                    child: Text(
                                      row[0].toString(),
                                      textScaleFactor: 2,
                                    ),
                                    onPressed: () async {
                                      client = PostgreSQLConnection(
                                          "localhost", 5432, "postgres",
                                          username: "postgres",
                                          password: "123",
                                          useSSL: false);
                                      await client.open();
                                      int x = row[4];
                                      PostgreSQLResult a = (await client.query(
                                          "UPDATE apps SET downloads = $x"));
                                      // Close the connection
                                      await client.close();
                                      launchUrl(Uri.parse(row[3].toString()));
                                    }))),
                        subtitle: Text(
                          (row[1].toString() +
                              ', ' +
                              row[2].toString() +
                              ', ' +
                              row[4].toString() +
                              ' Downloads'),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Center(child: CircularProgressIndicator());
              },
            )),
      ],
    ));
  }
}

class NormalScreen extends StatefulWidget {
  @override
  _NormalScreenState createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<dynamic>>(
        future: entries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var row = snapshot.data![index];
                return ListTile(
                  title: new Center(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Colors.lightBlueAccent,
                          child: TextButton(
                              child: Text(
                                row[0].toString(),
                                textScaleFactor: 2,
                              ),
                              onPressed: () async {
                                client = PostgreSQLConnection(
                                    "localhost", 5432, "postgres",
                                    username: "postgres",
                                    password: "123",
                                    useSSL: false);
                                await client.open();
                                int x = row[4];
                                PostgreSQLResult a = (await client
                                    .query("UPDATE apps SET downloads = $x"));
                                // Close the connection
                                await client.close();
                                launchUrl(Uri.parse(row[3].toString()));
                              }))),
                  subtitle: Text(
                    (row[1].toString() +
                        ', ' +
                        row[2].toString() +
                        ', ' +
                        row[4].toString() +
                        ' Downloads'),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<dynamic>>(
        future: entries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var row = snapshot.data![index];
                return ListTile(
                  title: new Center(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          color: Colors.lightBlueAccent,
                          child: TextButton(
                              child: Text(
                                row[0].toString(),
                                textScaleFactor: 2,
                              ),
                              onPressed: () async {
                                client = PostgreSQLConnection(
                                    "localhost", 5432, "postgres",
                                    username: "postgres",
                                    password: "123",
                                    useSSL: false);
                                await client.open();
                                int x = row[4];
                                PostgreSQLResult a = (await client
                                    .query("UPDATE apps SET downloads = $x"));
                                // Close the connection
                                await client.close();
                                launchUrl(Uri.parse(row[3].toString()));
                              }))),
                  subtitle: Text(
                    (row[1].toString() +
                        ', ' +
                        row[2].toString() +
                        ', ' +
                        row[4].toString() +
                        ' Downloads'),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ));
  }
}

class AddingScreen extends StatefulWidget {
  @override
  _AddingScreenState createState() => _AddingScreenState();
}

class _AddingScreenState extends State<AddingScreen> {
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Card(
              color: Color.fromARGB(255, 170, 131, 177),
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [namm, advis, pres, strikes],
                  ))),
          TextButton(
              onPressed: () async {
                var client = PostgreSQLConnection("localhost", 5432, "postgres",
                    username: "postgres", password: "123", useSSL: false);
                await client.open();
                await client.query(
                    "INSERT INTO apps VALUES ('$nameText', '$advisorText', '$presText', '$dayText', '$strikesText')");
                // Close the connection
                await client.close();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => DevScreen()));
              },
              child: Text('Upload App'))
        ],
      ),
    ));
  }
}
