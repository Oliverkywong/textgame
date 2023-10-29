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

  void checkLVup(){
    if(exp>=lvUp){
      lv++;
    }
  }
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
  Head head = Head();
  Body body = Body();
  Weapon weapon = Weapon();
  GenMap genMap = GenMap();
  Player player = Player();

  late final List<Widget> _widgetOptions = <Widget>[
    Attributes(head, body, weapon),
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
  dynamic genMap;
  dynamic player;
  Game(this.head, this.body, this.weapon, this.genMap, this.player, {super.key});
  @override
  State<StatefulWidget> createState() {
    return GameState(head, body, weapon, genMap, player);
  }
}

class GameState extends State<Game> {
  dynamic head;
  dynamic body;
  dynamic weapon;
  dynamic genMap;
  dynamic player;
  GameState(this.head, this.body, this.weapon, this.genMap, this.player);

  dynamic monster = Monster();
  bool fight = false;
  bool canPress = true;

  String msg = 'welcome to play';

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

  void getItem() {
    setState(() {
      switch (Random().nextInt(4) + 1) {
        case 1:
          head.getitem();
          msg = 'get head';
          break;
        case 2:
          body.getitem();
          msg = 'get body';
          break;
        case 3:
          weapon.getitem();
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
              Text(msg),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if ((genMap.map)
                        .contains(genMap.curPosition - genMap.row)) {
                      genMap.curPosition -= genMap.row;
                      if(!(genMap.lastpo).contains(genMap.curPosition)){
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
                        if ((genMap.map)
                            .contains(genMap.curPosition - 1)) {
                          genMap.curPosition--;
                          if(!(genMap.lastpo).contains(genMap.curPosition)){
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
                        if ((genMap.map)
                            .contains(genMap.curPosition + 1)) {
                          genMap.curPosition++;
                          if(!(genMap.lastpo).contains(genMap.curPosition)){
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
//                               if((genMap.map).sort()==(genMap.lastpo).sort()){
//                                 msg = 'next leve';
//                                 genMap = GenMap();
//                                 Game(head, body, weapon, genMap, player);
//                               }
                    if ((genMap.map)
                        .contains(genMap.curPosition + genMap.row)) {
                      genMap.curPosition += genMap.row;
                      if(!(genMap.lastpo).contains(genMap.curPosition)){
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
  dynamic genMap;
  Map(this.genMap, {super.key});
  @override
  State<StatefulWidget> createState() => MapState(genMap);
}

class MapState extends State<Map> {
  dynamic genMap;
  MapState(this.genMap);

  @override
  void initState() {
    super.initState();
    genMap.gen();
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
