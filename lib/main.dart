import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(storage: Save()),
    ),
  );
}

class Save {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/save.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.storage}) : super(key: key);

  final Save storage;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int localCounter = 0;
  int prefCounter = 0;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        localCounter = value;
      });
    });
    start();
  }

  void start() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefCounter = (prefs.getInt('counter2') ?? 0);
    });
  }

  void sharedPrefereces() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefCounter = (prefs.getInt('counter2') ?? 0) + 4;
      prefs.setInt('counter2', prefCounter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Мой кейс - мои правила!',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: Text('Нажать чтобы прибавить $localCounter - локально'),
                onPressed: () {
                  setState(() {
                    local();

                    start;
                  });
                }),
            ElevatedButton(
                child: Text(
                    'Нажать чтобы прибавить $prefCounter - Shared Preferences'),
                onPressed: () {
                  setState(() {
                    sharedPrefereces();
                    start;
                  });
                }),
          ],
        ),
      ),
    );
  }

  Future<File> local() {
    setState(() {
      localCounter += 2;
    });

    return widget.storage.writeCounter(localCounter);
  }

  sum() {
    var total = localCounter + prefCounter;
    return total;
  }
}
