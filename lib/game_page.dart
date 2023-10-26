import 'package:flutter/material.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  int _selectedIndex = 1;
  bool fight = false;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const Game(),
    const ProfileScreen()
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}

class Game extends StatefulWidget {
  const Game({super.key});
  @override
  State<StatefulWidget> createState() {
    return GameState();
  }
}

class GameState extends State<Game> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('welcome 1-1 round'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('left'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
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

class Fight extends StatefulWidget {
  const Fight({super.key});
  @override
  State<StatefulWidget> createState() {
    return FightState();
  }
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

class FightState extends State<Fight> {
  var monster = Monster();
  var player = Player();

  Duration timeDelay = const Duration(milliseconds: 3000);

  void monsterattack() {
    setState(() {
      player.hp = player.hp - monster.attack;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
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
                onPressed: () {
                  if (monster.hp <= 0) {
                    setState(() {
                      monster = Monster();
                    });
                  } else {
                    setState(() {
                      monster.hp -= player.attack;
                    });
                    Timer(timeDelay, monsterattack);
                  }
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Screen'),
    );
  }
}
