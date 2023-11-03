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
    List<double> lastpo = [];
    List<double> map = [];
    final file = await _localFile;
    final contents = await file.readAsString();
    var raw = XmlDocument.parse(contents);
    final data = raw.findElements('data').first;
    final lastpoList = data.findElements('lastpo').first.innerText;
    var lastpoData = lastpoList.split(',');
    final mapList = data.findElements('map').first.innerText;
    var mapData = mapList.split(',');
    final value = data.findElements('curPosition').first.innerText;
    curPosition = double.parse(value);
    for (var x in mapData) {
      if (x == '') break;
      map.add(double.parse(x));
    }
    for (var x in lastpoData) {
      if (x == '') break;
      lastpo.add(double.parse(x));
    }
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
  late List<dynamic> lastpo;
  late List<dynamic> map;

  @override
  void initState() {
    super.initState();
    widget.storage.readData().then((data) {
      setState(() {
        if (loadData) {
          genMap.curPosition = data['curPosition'];
          genMap.map = data['map'];
          genMap.lastpo = data['lastpo'];
        } else {
          genMap.gen();
        }
        widget.storage.readJson().then((data) {
          if (loadData) {
            player.name = data['name'];
            player.lv = data['lv'];
            player.hp = data['hp'];
            player.attack = data['attack'];
            player.exp = data['exp'];
            player.hasHead = data['hasHead'];
            player.hasBody = data['hasBody'];
            player.hasWeap = data['hasWeap'];
          } else {
            player =
                Player();
          }
        });
      });
    });
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
                        late String mapXml = '';
                        for (var x in genMap.map) {
                          mapXml += '$x,';
                        }
                        late String lastpoXml = '';
                        for (var x in genMap.lastpo) {
                          lastpoXml += '$x,';
                        }
                        builder.element('data', nest: () {
                          builder.element('map', nest: mapXml);
                          builder.element('lastpo', nest: lastpoXml);
                          builder.element('curPosition',
                              nest: genMap.curPosition);
                        });
                        final document = builder.buildDocument();
                        widget.storage.writeData(document.toString());
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
