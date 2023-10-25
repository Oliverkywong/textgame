import 'package:flutter/material.dart';
import 'package:textgame/menu_page.dart';

// import 'package:textgame/Data.dart';
import 'package:xml/xml.dart' as xml;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Text Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future<List<Con>> getConFromXML(BuildContext context) async {
  //   String datalist =
  //   await DefaultAssetBundle.of(context).loadString("assets/data/data.xml");
  //   var raw = xml.XmlDocument.parse(datalist);
  //   var elements = raw.findAllElements('contact');
  //   return elements.map((element) {
  //     return Con(element.findElements("name").first.text,
  //         int.parse(element.findElements("age").first.text));
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'GAME',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MenuPage();
                }));
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
    //   body: Center(
    //     child: FutureBuilder(
    //       future: getConFromXML(context),
    //       builder: (context, data){
    //         if(data.hasData){
    //           List<Con>? contacts = data.data;
    //           return ListView.builder(
    //             itemCount: contacts!.length,
    //               itemBuilder: (context, index){
    //               return ListTile(
    //                 title: Text(contacts[index].name),
    //                 subtitle: Text(contacts[index].age.toString()),
    //               );
    //           });
    //         }else{
    //           return Center(child: CircularProgressIndicator(),);
    //         }
    //       },
    //     ),
    //   ),
    // );
  }
}
