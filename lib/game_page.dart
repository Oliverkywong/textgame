import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => GamePageState();
}

class Monster {
  String name = 'Monster';
  late int lv = 1;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 8 * (1 + (lv - 1) / 10);
  late double giveExp = 100 * (1 + (lv - 1) / 10);
}

class Player {
  String name = 'Player';
  late int lv = 1;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 10 * (1 + (lv - 1) / 10);
  late double exp = 0;
  late double lvUp = 100 * ((lv - 1) * 5);

  void checkLVup() {
    if (exp >= lvUp) {
      lv++;
    }
  }

  bool hasHead = false;
  void getHead() {
    hasHead = true;
  }

  bool hasBody = false;
  void getBody() {
    hasBody = true;
  }

  bool hasWeap = false;
  void getWeap() {
    hasWeap = true;
  }
}

class Head {
  String name = 'item1';
  String des = 'HP + 50';
  int abt = 50;
}

class Body {
  String name = 'item2';
  String des = 'Def + 5';
  int abt = 5;
}

class Weapon {
  String name = 'item2';
  String des = 'Atk + 10';
  int abt = 10;
}

class GamePageState extends State<GamePage> {
  int _selectedIndex = 1;
  Head head = Head();
  Body body = Body();
  Weapon weapon = Weapon();
  GenMap genMap = GenMap();
  Player player = Player();

  late final List<Widget> _widgetOptions = <Widget>[
    Attributes(head, body, weapon, player),
    Game(head, body, weapon, genMap, player),
    Map(genMap)
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
  Head head;
  Body body;
  Weapon weapon;
  Player player;
  Attributes(this.head, this.body, this.weapon, this.player, {super.key});
  @override
  State<StatefulWidget> createState() {
    return AttributesState(head, body, weapon, player);
  }
}

class AttributesState extends State<Attributes> {
  Head head;
  Body body;
  Weapon weapon;
  Player player;
  AttributesState(this.head, this.body, this.weapon, this.player);

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
              child: player.hasHead
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
              child: player.hasBody
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
              child: player.hasWeap
                  ? ListTile(
                      title: Text(weapon.name),
                      subtitle: Text(weapon.des),
                    )
                  : const Center(child: Text('No weapon')))
        ]),
      ])));
}

class Game extends StatefulWidget {
  Head head;
  Body body;
  Weapon weapon;
  GenMap genMap;
  Player player;
  Game(this.head, this.body, this.weapon, this.genMap, this.player,
      {super.key});
  @override
  State<StatefulWidget> createState() {
    return GameState(head, body, weapon, genMap, player);
  }
}

class GameState extends State<Game> {
  Head head;
  Body body;
  Weapon weapon;
  GenMap genMap;
  Player player;
  GameState(this.head, this.body, this.weapon, this.genMap, this.player);

  Monster monster = Monster();
  bool fight = false;
  bool canPress = true;

  String msg = 'welcome to play';

  late double playerHP = player.hasHead ? player.hp + head.abt : player.hp;

  Duration timeDelay = const Duration(milliseconds: 1000);

  void monsterattack() {
    setState(() {
      player.hasBody
          ? playerHP = playerHP - (monster.attack - body.abt)
          : playerHP = playerHP - monster.attack;
      canPress = true;
    });
  }

  void getItem() {
    setState(() {
      switch (Random().nextInt(4) + 1) {
        case 1:
          player.getHead();
          msg = 'get head';
          break;
        case 2:
          player.getBody();
          msg = 'get body';
          break;
        case 3:
          player.getWeap();
          msg = 'get weapon';
          break;
        case 4:
          msg = 'empty box';
          break;
      }
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
                                      player.exp += monster.giveExp;
                                      player.checkLVup();
                                      monster = Monster();
                                    });
                                  } else {
                                    setState(() {
                                      canPress = false;
                                      player.hasWeap
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
                    Text(msg),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if ((genMap.map).length == (genMap.lastpo).length) {
                            msg = 'next leve';
                            genMap.map = [genMap.position];
                            genMap.lastpo = [genMap.position];
                            genMap.curPosition = genMap.position;
                            genMap.gen();
                          }
                          if ((genMap.map)
                              .contains(genMap.curPosition - genMap.row)) {
                            genMap.curPosition -= genMap.row;
                            if (!(genMap.lastpo).contains(genMap.curPosition)) {
                              (genMap.lastpo).add(genMap.curPosition);
                            }
                            switch (Random().nextInt(3) + 1) {
                              case 1:
                                msg = 'item room';
                                getItem();
                                break;
                              case 2:
                                fight = true;
                                break;
                              case 3:
                                msg = 'empty room';
                                break;
                            }
                          } else {
                            msg = 'no forward room';
                          }
                        });
                      },
                      child: const Text('forward'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if ((genMap.map).length ==
                                  (genMap.lastpo).length) {
                                msg = 'next leve';
                                genMap.map = [genMap.position];
                                genMap.lastpo = [genMap.position];
                                genMap.curPosition = genMap.position;
                                genMap.gen();
                              }
                              if ((genMap.map)
                                  .contains(genMap.curPosition - 1)) {
                                genMap.curPosition--;
                                if (!(genMap.lastpo)
                                    .contains(genMap.curPosition)) {
                                  (genMap.lastpo).add(genMap.curPosition);
                                }
                                switch (Random().nextInt(3) + 1) {
                                  case 1:
                                    msg = 'item room';
                                    getItem();
                                    break;
                                  case 2:
                                    fight = true;
                                    break;
                                  case 3:
                                    msg = 'empty room';
                                    break;
                                }
                              } else {
                                msg = 'no left room';
                              }
                            });
                          },
                          child: const Text('left'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if ((genMap.map).length ==
                                  (genMap.lastpo).length) {
                                msg = 'next leve';
                                genMap.map = [genMap.position];
                                genMap.lastpo = [genMap.position];
                                genMap.curPosition = genMap.position;
                                genMap.gen();
                              }
                              if ((genMap.map)
                                  .contains(genMap.curPosition + 1)) {
                                genMap.curPosition++;
                                if (!(genMap.lastpo)
                                    .contains(genMap.curPosition)) {
                                  (genMap.lastpo).add(genMap.curPosition);
                                }
                                switch (Random().nextInt(3) + 1) {
                                  case 1:
                                    msg = 'item room';
                                    getItem();
                                    break;
                                  case 2:
                                    fight = true;
                                    break;
                                  case 3:
                                    msg = 'empty room';
                                    break;
                                }
                              } else {
                                msg = 'no right room';
                              }
                            });
                          },
                          child: const Text('right'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if ((genMap.map).length == (genMap.lastpo).length) {
                            msg = 'next leve';
                            genMap.map = [genMap.position];
                            genMap.lastpo = [genMap.position];
                            genMap.curPosition = genMap.position;
                            genMap.gen();
                          }
                          if ((genMap.map)
                              .contains(genMap.curPosition + genMap.row)) {
                            genMap.curPosition += genMap.row;
                            if (!(genMap.lastpo).contains(genMap.curPosition)) {
                              (genMap.lastpo).add(genMap.curPosition);
                            }
                            switch (Random().nextInt(3) + 1) {
                              case 1:
                                msg = 'item room';
                                getItem();
                                break;
                              case 2:
                                fight = true;
                                break;
                              case 3:
                                msg = 'empty room';
                                break;
                            }
                          } else {
                            msg = 'no backward room';
                          }
                        });
                      },
                      child: const Text('backward'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('save game'),
                    )
                  ],
                )));
}

class GenMap {
  int row = 11;
  int col = 11;
  int roomCount = Random().nextInt(5) + 16;
  late double position = (row * col - 1) / 2;
  late double curPosition = position;
  late List<double> lastpo = [position];
  late double room = position;
  late List<double> map = [position];
  List gen() {
    while (map.length < roomCount) {
      switch (Random().nextInt(4) + 1) {
        case 1:
          room = room + 1;
          if (map.contains(room) || room < 0 || room > 120) {
            continue;
          } else {
            map.add(room);
          }
          break;
        case 2:
          room = room - 1;
          if (map.contains(room) || room < 0 || room > 120) {
            continue;
          } else {
            map.add(room);
          }
          break;
        case 3:
          room = room + row;
          if (map.contains(room) || room < 0 || room > 120) {
            continue;
          } else {
            map.add(room);
          }
          break;
        case 4:
          room = room - row;
          if (map.contains(room) || room < 0 || room > 120) {
            continue;
          } else {
            map.add(room);
          }
          break;
      }
    }
    return map;
  }
}

class Map extends StatefulWidget {
  GenMap genMap;
  Map(this.genMap, {super.key});
  @override
  State<StatefulWidget> createState() => MapState(genMap);
}

class MapState extends State<Map> {
  GenMap genMap;
  MapState(this.genMap);

  @override
  void initState() {
    super.initState();
    genMap.gen();
  }

  Container mapBox(color, icon) {
    Color? color;
    Icon? icon;
    return Container(
        margin: const EdgeInsets.all(1),
        color: color,
        height: 30,
        width: 30,
        child: icon);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: genMap.row,
        ),
        itemCount: genMap.row * genMap.col,
        itemBuilder: (BuildContext context, int index) {
          if (index == genMap.curPosition) {
            return Container(
                margin: const EdgeInsets.all(1),
                color: Colors.red,
                height: 30,
                width: 30,
                child: const Icon(Icons.adjust));
          }
          if ((genMap.lastpo).contains(index)) {
            return Container(
              margin: const EdgeInsets.all(1),
              color: Colors.green,
              height: 30,
              width: 30,
            );
          }
          return (genMap.map).contains(index)
              ? Container(
                  margin: const EdgeInsets.all(1),
                  color: Colors.red,
                  height: 30,
                  width: 30,
                )
              : Container(
                  margin: const EdgeInsets.all(1),
                  color: Colors.blue,
                  height: 30,
                  width: 30,
                );
        });
  }
}
