import 'dart:math';

class Monster {
  String name = 'Monster';
  late int lv;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 8 * (1 + (lv - 1) / 10);
  late double giveExp = 100 * (1 + (lv - 1) / 10);
  Monster(this.lv);
}

class Player {
  String name = 'Player';
  late int lv = 1;
  late double hp = 100 * (1 + (lv - 1) / 10);
  late double attack = 10 * (1 + (lv - 1) / 10);
  late double exp = 0;
  bool hasHead = false;
  bool hasBody = false;
  bool hasWeap = false;
  late double lvUp = 100 * ((lv - 1) * 5);

  void checkLVup() {
    if (exp >= lvUp) {
      lv++;
    }
  }

  void getHead() {
    hasHead = true;
  }

  void getBody() {
    hasBody = true;
  }

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
