import 'package:flutter/material.dart';
import 'package:textgame/module.dart';

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
