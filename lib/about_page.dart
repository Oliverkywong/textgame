import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            Text('Copyright © 2023 - 2023'),
            Text('Oliver Company Ltd. All Rights Reserved'),
            Text('App Version: v1.0'),
          ],
        ),
      ),
    );
  }
}