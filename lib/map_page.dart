import 'package:flutter/material.dart';
import 'package:textgame/module.dart';

class Map extends StatefulWidget {
  GenMap genMap;
  Map(this.genMap, {super.key});
  @override
  State<StatefulWidget> createState() => MapState(genMap);
}

class MapState extends State<Map> {
  GenMap genMap;
  MapState(this.genMap);

  // @override
  // void initState() {
  //   super.initState();
  //   genMap.gen();
  // }

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
