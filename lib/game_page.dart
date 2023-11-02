import 'package:flutter/material.dart';
import 'package:textgame/module.dart';
import 'package:textgame/map_page.dart';
import 'package:textgame/attr_page.dart';
import 'dart:async';
import 'dart:math';
import 'package:xml/xml.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class GamePage extends StatefulWidget {
  bool loadData;
  GamePage(this.loadData, {super.key});

  get storage => Storage();

  @override
  State<GamePage> createState() => GamePageState(this.loadData);
}

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/mapdata.xml');
  }

  Future<dynamic> readData() async {
    late double curPosition;
    late List<double> lastpo = [];
    late List<double> map = [];
    final file = await _localFile;
    final contents = await file.readAsString();
    var raw = XmlDocument.parse(contents);
    final data = raw.findElements('data').first;
    final lastpoList = data.findElements('lastpoList');
    final mapList = data.findElements('mapList');
    for (final lastpodata in lastpoList) {
      final value = lastpodata.findElements('lastpo').first.text;
      lastpo.add(double.parse(value));
    }
    for (final mapdata in mapList) {
      final value = mapdata.findElements('map').first.text;
      map.add(double.parse(value));
    }
    final value = data.findElements('Position').first.text;
    curPosition = double.parse(value);
    // curPosition = raw
    //         .findAllElements('curPosition')
    //         .map<String>((e) => e.findElements('Position').first.innerText).toString();
    // lastpo = raw
    //     .findAllElements('lastpoList')
    //     .map<String>((e) => e.findElements('lastpo').first.text)
    //     .toList();
    // map = raw
    //     .findAllElements('mapList')
    //     .map<String>((e) => e.findElements('map').first.text)
    //     .toList();
    print(curPosition);
    print(lastpo);
    print(map);
    return {'curPosition': curPosition, 'lastpo': lastpo, 'map': map};
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  Future<File> get _jsonFile async {
    final path = await _localPath;
    return File('$path/playerdata.json');
  }

  Future<dynamic> readJson() async {
    final file = await _jsonFile;
    final contents = await file.readAsString();
    var json = jsonDecode(contents);
    return json;
  }

  void writeJson(Object data) async {
    final file = await _jsonFile;
    file.writeAsStringSync(json.encode(data));
  }
}

class GamePageState extends State<GamePage> {
  int _selectedIndex = 1;
  bool loadData;

  GamePageState(this.loadData);

  Head head = Head();
  Body body = Body();
  Weapon weapon = Weapon();
  GenMap genMap = GenMap();
  Player player = Player();

  late double curPosition;
  late List<double> lastpo;
  late List<double> map;

  @override
  void initState() {
    super.initState();
    // Future<String> readData() async {
    //   final file = await _localFile;
    //   final contents = await file.readAsString();
    //   return XmlDocument.parse(contents);
    // }
    widget.storage.readData().then((data) {
      setState(() {
        print(loadData);
        print(data);
        if (loadData) {
          curPosition = double.parse(data.curPosition);
          lastpo = (data.lastpo).map(double.parse).toList();
          map = (data.map).map(double.parse).toList();
          // curPosition = raw
          //   .findAllElements('curPosition')
          //   .map<Text>((e) => Text(e.findElements('Position').first.text))
          //   .cast<double>();
          // lastpo = raw
          //     .findAllElements('lastpoList')
          //     .map<Text>((e) => Text(e.findElements('lastpo').first.text))
          //     .cast<double>()
          //     .toList();
          // map = raw
          //     .findAllElements('mapList')
          //     .map<Text>((e) => Text(e.findElements('map').first.text))
          //     .cast<double>()
          //     .toList();
          // print(lastpo);
          // print(map);
        } else {
          genMap.gen();
          curPosition = genMap.curPosition;
          lastpo = genMap.lastpo;
          map = genMap.map;
        }
        widget.storage.readJson().then((data) {
          print(data);
        });
      });
    });
    // final directory = await getApplicationDocumentsDirectory();
    // final path = directory.path;
    // final file = File('$path/mapdata.xml');
    // final contents = await file.readAsString();
    // final raw = XmlDocument.parse(contents);
    // setState(() {
    //   print(loadData);
    //   print(raw);
    //   if (loadData) {
    //     curPosition = raw.findElements('curPosition') as double;
    //     lastpo = raw
    //         .findAllElements('lastpoList')
    //         .map<Text>((e) => Text(e.findElements('lastpo').first.text))
    //         .cast<double>()
    //         .toList();
    //     map = raw
    //         .findAllElements('mapList')
    //         .map<Text>((e) => Text(e.findElements('map').first.text))
    //         .cast<double>()
    //         .toList();
    //     print(lastpo);
    //     print(map);
    //   } else {
    //     curPosition = genMap.curPosition;
    //     lastpo = genMap.lastpo;
    //     map = genMap.map;
    //   }
    // });
  }

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

class Game extends StatefulWidget {
  Head head;
  Body body;
  Weapon weapon;
  GenMap genMap;
  Player player;
  Game(this.head, this.body, this.weapon, this.genMap, this.player,
      {super.key});

  get storage => Storage();
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

  late Monster monster = Monster(player.lv);
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
                                      monster = Monster(player.lv);
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
                              monster = Monster(player.lv);
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
                      onPressed: () async {
                        final builder = XmlBuilder();
                        // builder.processing('xml', 'version="1.0"');
                        builder.element('data', nest: () {
                          builder.element('mapList', nest: () {
                            for (var x in genMap.map) {
                              builder.element('map', nest: x);
                            }
                          });
                          builder.element('lastpoList', nest: () {
                            for (var y in genMap.lastpo) {
                              builder.element('lastpo', nest: y);
                            }
                          });
                          builder.element('curPosition', nest: () {
                            for (var z = 0; z < 1; z++) {
                              builder.element('Position',
                                  nest: genMap.curPosition);
                            }
                          });
                        });
                        final document = builder.buildDocument();
                        // print('save data');
                        // print(document);
                        widget.storage.writeData(document.toString());
                        // final file = await _localFile;
                        // file.writeAsString(document as String);
                        var playerdata = {
                          'name': player.name,
                          'lv': player.lv,
                          'hp': player.hp,
                          'attack': player.attack,
                          'exp': player.exp,
                          'hasHead': player.hasHead,
                          'hasBody': player.hasBody,
                          'hasWeap': player.hasWeap,
                        };
                        widget.storage.writeJson(playerdata);
                      },
                      child: const Text('save game'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('back to menu'),
                    ),
                  ],
                )));
}
