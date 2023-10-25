import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return HelpPageState();
  }
}

class HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      primary: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: const Text('Q. How to start new game?'),
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('First click Start in the center.')),
                    Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          'assets/images/Q1.png',
                          height: 100,
                          width: 300,
                        )),
                    const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('Click New Game.')),
                    Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          'assets/images/Q1_1.png',
                          height: 200,
                          width: 300,
                        )),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: const Text('Q. How to load saved game?'),
                  children: <Widget>[
                    const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('Click Load Game.')),
                    Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          'assets/images/Q1_1.png',
                          height: 200,
                          width: 300,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
