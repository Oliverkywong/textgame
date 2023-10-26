import 'package:flutter/material.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  int _selectedIndex = 1;
  final List<Widget> _widgetOptions = <Widget>[
    const Attributes(),
    const Game(),
    const Map()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.attribution),
            label: 'Attributes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_drop_down_circle),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class Attributes extends StatefulWidget {
  const Attributes({super.key});
  @override
  State<StatefulWidget> createState() {
    return AttributesState();
  }
}

class AttributesState extends State<Attributes> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Text('head: '),
            Container(
                margin: const EdgeInsets.all(10.0),
                width: 100,
                height: 65,
                child: const Column(children: <Widget>[
                  ListTile(
                    title: Text('item'),
                    subtitle: Text('HP +10'),
                  ),
                ])),
            const Text('body: '),
            Container(
                margin: const EdgeInsets.all(10.0),
                width: 100,
                height: 65,
                child: const Column(children: <Widget>[
                  ListTile(
                    title: Text('item2'),
                    subtitle: Text('HP +10'),
                  ),
                ])),
            const Text('weapon: '),
            Container(
                margin: const EdgeInsets.all(10.0),
                width: 100,
                height: 65,
                child: const Column(children: <Widget>[
                  ListTile(
                    title: Text('item'),
                    subtitle: Text('Attack +10'),
                  ),
                ])),
          ])));
}

class Game extends StatefulWidget {
  const Game({super.key});
  @override
  State<StatefulWidget> createState() {
    return GameState();
  }
}

class GameState extends State<Game> {
  var monster = Monster();
  var player = Player();
  bool fight = false;
  bool canPress = true;

  Duration timeDelay = const Duration(milliseconds: 3000);

  void monsterattack() {
    setState(() {
      player.hp = player.hp - monster.attack;
      canPress = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: fight
              ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(monster.name),
                  Text('Monster Lv: ${(monster.lv).toString()}'),
                  Text('Monster HP: ${(monster.hp).round().toDouble()}'),
                  Text(player.name),
                  Text('Player Lv: ${(player.lv).toString()}'),
                  Text('Player HP: ${(player.hp).round().toDouble()}'),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: canPress
                            ? () {
                          if (monster.hp <= 0) {
                            setState(() {
                              fight = false;
                              monster = Monster();
                            });
                          } else {
                            setState(() {
                              canPress = false;
                              monster.hp -= player.attack;
                            });
                            Timer(timeDelay, monsterattack);
                          }
                        }
                            : null,
                        child: const Text('Attack'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            fight = false;
                            monster = Monster();
                          });
                        },
                        child: const Text('Escape'),
                      ),
                    ],
                  )
                ],
              ))
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('welcome 1-1 round'),
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('left'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        fight = true;
                      });
                    },
                    child: const Text('forward'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('right'),
                  ),
                ],
              )
            ],
          )));
}

class Monster {
  String name = 'Monster';
  int lv = 21;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 8 * (1 + (lv - 1) / 10);
}

class Player {
  String name = 'Player';
  int lv = 21;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 10 * (1 + (lv - 1) / 10);
}

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('map'),
    );
  }
}

