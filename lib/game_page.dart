import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return GamePageState();
  }
}

class Monster {
  String name = 'Monster';
  int hp = 100;
  int attack = 10;
}

class Player {
  String name = 'Player';
  int hp = 100;
  int attack = 10;
}

class GamePageState extends State<GamePage> {
  var monster = Monster();
  var player = Player();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('1-1'),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(monster.name),
          Text('Monster HP: ' + (monster.hp).toString()),
          Text(player.name),
          Text('Player HP: ' + (player.hp).toString()),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    monster.hp -= 10;
                    player.hp = player.hp - monster.attack;
                  });
                },
                child: const Text('Attack'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Escape'),
              ),
            ],
          )
        ],
      )));
}
