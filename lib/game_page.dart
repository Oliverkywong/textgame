import 'package:flutter/material.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => GamePageState();
}

class Monster {
  String name = 'Monster';
  int lv = 1;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 8 * (1 + (lv - 1) / 10);
}

class Player {
  String name = 'Player';
  int lv = 1;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 10 * (1 + (lv - 1) / 10);
}

class Head {
  String name = 'item1';
  String des = 'HP + 50';
  int abt = 50;
  bool hasHead = false;

  void getitem() {
    hasHead = true;
  }
}

class Body {
  String name = 'item2';
  String des = 'Def + 5';
  int abt = 5;
  bool hasBody = false;

  void getitem() {
    hasBody = true;
  }
}

class Weapon {
  String name = 'item2';
  String des = 'Atk + 10';
  int abt = 10;
  bool hasWeap = false;

  void getitem() {
    hasWeap = true;
  }
}

class GamePageState extends State<GamePage> {
  int _selectedIndex = 1;
  dynamic head = Head();
  dynamic body = Body();
  dynamic weapon = Weapon();

  late final List<Widget> _widgetOptions = <Widget>[
    Attributes(head, body, weapon),
    Game(head, body, weapon),
    Map()
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
        selectedItemColor: const Color.fromARGB(255, 0, 204, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}

class Attributes extends StatefulWidget {
  dynamic head;
  dynamic body;
  dynamic weapon;
  Attributes(this.head, this.body, this.weapon, {super.key});
  @override
  State<StatefulWidget> createState() {
    return AttributesState(head, body, weapon);
  }
}

class AttributesState extends State<Attributes> {
  dynamic head;
  dynamic body;
  dynamic weapon;
  AttributesState(this.head, this.body, this.weapon);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('    head: '),
          Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              width: 100,
              height: 70,
              child: head.hasHead
                  ? ListTile(
                      title: Text(head.name),
                      subtitle: Text(head.des),
                    )
                  : const Center(child: Text('No head')))
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('    body: '),
          Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              width: 100,
              height: 70,
              child: body.hasBody
                  ? ListTile(
                      title: Text(body.name),
                      subtitle: Text(body.des),
                    )
                  : const Center(child: Text('No body')))
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [
          const Text('weapon: '),
          Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              width: 100,
              height: 70,
              child: weapon.hasWeap
                  ? ListTile(
                      title: Text(weapon.name),
                      subtitle: Text(weapon.des),
                    )
                  : const Center(child: Text('No weapon')))
        ]),
      ])));
}

class Game extends StatefulWidget {
  dynamic head;
  dynamic body;
  dynamic weapon;
  Game(this.head, this.body, this.weapon, {super.key});
  @override
  State<StatefulWidget> createState() {
    return GameState(head, this.body, this.weapon);
  }
}

class GameState extends State<Game> {
  dynamic head;
  dynamic body;
  dynamic weapon;
  GameState(this.head, this.body, this.weapon);

  dynamic monster = Monster();
  dynamic player = Player();
  bool fight = false;
  bool canPress = true;

  late double playerHP = head.hasHead ? player.hp + head.abt : player.hp;

  Duration timeDelay = const Duration(milliseconds: 1000);

  void monsterattack() {
    setState(() {
      body.hasBody
          ? playerHP = playerHP - (monster.attack - body.abt)
          : playerHP = playerHP - monster.attack;
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
                    Text('Player HP: ${(playerHP).round().toDouble()}'),
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
                                      weapon.hasWeap
                                          ? monster.hp -=
                                              player.attack + weapon.abt
                                          : monster.hp -= player.attack;
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
                          onPressed: () {
                            setState(() {
                              head.getitem();
                              body.getitem();
                              weapon.getitem();
                            });
                          },
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

class Map extends StatelessWidget {
  const Map({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('map'),
    );
  }
}
