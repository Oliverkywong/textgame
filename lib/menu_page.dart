import 'package:flutter/material.dart';
import 'dart:io';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return MenuPageState();
  }
}

class MenuPageState extends State<MenuPage> {
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
    minimumSize: const Size(150, 40),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                style: style,
                onPressed: () {},
                child: const Text('New Gmae'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: style,
                onPressed: () {},
                child: const Text('Load Game'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: style,
                onPressed: () {},
                child: const Text('Help'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: style,
                onPressed: () {},
                child: const Text('About Game'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: style,
                onPressed: () {
                  exit(0);
                },
                child: const Text('Exit Game'),
              ),
            ],
          ),
        ),
      );
}
