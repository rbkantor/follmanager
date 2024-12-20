import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Followers management'),
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
  final followers = <int>{};
  final emails = <String>{};
  final domains = <String>{};
  String message = '';
  TextEditingController controller = TextEditingController(text: '5000');
  final ScrollController _scrollController = ScrollController(); // Controller for ListView and Scrollbar

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('number of followers to take'),
                SizedBox(
                    width: 100,
                    child: TextField(
                      controller: controller,
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () async {
                          List<int> toSave = followers.take(int.tryParse(controller.text) ?? 0).toList();
                          String fileContent = toSave.map((int num) => num.toString()).join('\n');
                          Clipboard.setData(ClipboardData(text: fileContent));

                          setState(() {
                            followers.removeAll(toSave);
                            message = 'Taking out ${toSave.length}';
                          });
                        },
                        child: Text('Save followers to clipboard'))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          followers.clear();
                          setState(() {
                            message = 'Resetting followers';
                          });
                        },
                        child: Text('clear clipboard'))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () async {
                          final clipboardData = await Clipboard.getData('text/plain');
                          if (clipboardData == null) {
                            return;
                          }

                          String clipboardText = clipboardData.text ?? '';
                          print('Clipboard Text: $clipboardText');

                          List<String> lines = clipboardText.split('\n');
                          final newItems = lines
                              .where((line) => line.trim().isNotEmpty)
                              .map<int>((line) => int.tryParse(line.trim()) ?? 0) // Convert to int
                              .where((number) => number != 0)
                              .toSet();
                          int followersBefore = followers.length;
                          followers.addAll(newItems);
                          int followersAfter = followers.length;
                          setState(() {
                            message = 'Adding ${newItems.length}, actual increase ${followersAfter - followersBefore}';
                          });
                        },
                        child: Text('Load followers from clipboard'))),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          final random = Random();
                          for (int i = 0; i < 10000; i++) {
                            followers.add(random.nextInt(100000) + 1);
                          }
                          setState(() {
                            message = 'Filling with 10k random values';
                          });
                        },
                        child: Text('Filling with 10k random values'))),
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('total followers ${followers.length} emails ${emails.length} domains ${domains.length}'),
              Text('$message'),
              Expanded(
                  child: Container(

                height: 300,
                width: 300,
                child: CustomScrollView(slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 30.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Followers'),
                    ),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 30.0,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          color: index.isEven ? Colors.lightBlue[200] : Colors.lightBlue[100],
                          child: Text('$index - ${followers.elementAt(index)}'),
                        );
                      },
                      childCount: followers.length, // Number of items in the list
                    ),
                  ),
                ]),
              )),
            ]),
            Column(children: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        final clipboardData = await Clipboard.getData('text/plain');
                        if (clipboardData == null) {
                          return;
                        }

                        String clipboardText = clipboardData.text ?? '';

                        List<String> lines = clipboardText.split('\n');
                      
                
                        emails.addAll(lines);
                    
                        setState(() {
                          message = 'Adding ${lines.length} emails';
                        });
                      },
                      child: Text('Load emails from clipboard'))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        final clipboardData = await Clipboard.getData('text/plain');
                        if (clipboardData == null) {
                          return;
                        }

                        String clipboardText = clipboardData.text ?? '';
                        final newDomains = clipboardText.split('\n');


                        setState(() {
                          domains.addAll(newDomains);
                          message = 'Adding ${newDomains.length} domains';
                        });
                      },
                      child: Text('Load domains from clipboard'))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () {

                        setState(() {
                          emails.clear();
                          domains.clear();
                          message = 'Resetting emails';
                        });
                      },
                      child: Text('clear all'))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        for (final email in emails) {
                          final split = email.split('@');
                          if (split.length == 2) {
                            final domain = split[1] + ':imap.firstmail.ltd:993';
                            domains.add(domain);
                          }
                        }
                        setState(() {
                          message = 'Converted emails';
                        });
                      },
                      child: Text('Convert emails'))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                      onPressed: () async {
                        final fileContent = domains.join('\n');
                        Clipboard.setData(ClipboardData(text: fileContent));

                        setState(() {

                            message = 'Saved domains to clipboard';
                        });
                      },
                      child: Text('Save domains to clipboard'))),

            ],),
            Expanded(
                child: Container(

                  height: 300,
                  width: 300,
                  child: CustomScrollView(slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 30.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Emails'),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 30.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Container(
                            color: index.isEven ? Colors.lightBlue[200] : Colors.lightBlue[100],
                            child: Text('$index - ${emails.elementAt(index)}'),
                          );
                        },
                        childCount: emails.length, // Number of items in the list
                      ),
                    ),
                  ]),
                )),
            Expanded(
                child: Container(

                  height: 300,
                  width: 300,
                  child: CustomScrollView(slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 30.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Domains'),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 30.0,
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return Container(
                            color: index.isEven ? Colors.lightBlue[200] : Colors.lightBlue[100],
                            child: Text('$index - ${domains.elementAt(index)}'),
                          );
                        },
                        childCount: domains.length, // Number of items in the list
                      ),
                    ),
                  ]),
                )),






          ]),
        ));
  }
}
