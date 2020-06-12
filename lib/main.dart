import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter local auth test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = LocalAuthentication();

  int _counter = 0;
  bool _isAuthenticated = false;
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometricsTypes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildCanCheckBiometrics(),
            SizedBox(
              height: 20,
            ),
            _buildLisOfAvailableBiometrics(),
            SizedBox(
              height: 20,
            ),
            _buildAuthenticate(),
          ],
        ),
      ),
    );
  }

  Widget _buildCanCheckBiometrics() {
    return Column(
      children: <Widget>[
        Text('Can Check biometrics $_canCheckBiometrics'),
        RaisedButton(
            child: Text('Check can check biometrics'),
            onPressed: () async {
              final canCcheckBiometrics = await _auth.canCheckBiometrics;
              setState(() {
                _canCheckBiometrics = canCcheckBiometrics;
              });
            }),
      ],
    );
  }

  Widget _buildLisOfAvailableBiometrics() {
    return Column(
      children: <Widget>[
        Text('List of available biometrics'),
        ..._availableBiometricsTypes.map((e) => Text('*${e.toString()}')),
        RaisedButton(
            child: Text('Get availble biometrics'),
            onPressed: () async {
              final availableBio = await _auth.getAvailableBiometrics();
              setState(() {
                _availableBiometricsTypes = availableBio;
              });
            }),
      ],
    );
  }

  Widget _buildAuthenticate() {
    return Column(
      children: <Widget>[
        Text(
          _isAuthenticated ? 'Ok' : 'Please login',
        ),
        RaisedButton(
          child: Text('Authenticate'),
          onPressed: () async {
            try {
              bool isAuthenticated = await _auth.authenticateWithBiometrics(
                localizedReason: 'authenticate to access',
                useErrorDialogs: true,
                stickyAuth: true,
              );

              setState(() {
                _isAuthenticated = isAuthenticated;
              });
            } on PlatformException catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }
}
