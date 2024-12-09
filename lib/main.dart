import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
  String message = '';
  TextEditingController controller = TextEditingController(text: '1000');
  final ScrollController _scrollController = ScrollController(); // Controller for ListView and Scrollbar
  final follower2 = <int>[];

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
          child: Row(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('number of followers to take'),
                SizedBox(
                    width: 100,
                    child: TextField(
                      controller: controller,
                    )),
                ElevatedButton(
                    onPressed: () async {
                      String? outputFile = await FilePicker.platform.saveFile(
                        dialogTitle: 'Please select an output file:',
                        fileName: '*.txt',
                      );

                      if (outputFile != null) {
                        File file = File(outputFile);
                        List<int> toSave = followers.take(int.tryParse(controller.text) ?? 0).toList();
                        String fileContent = toSave.map((int num) => num.toString()).join('\n');
                        await file.writeAsString(fileContent);
                        followers.removeAll(toSave);
                        message = 'Taking out ${toSave.length}';
                      }

                      setState(() {});
                    },
                    child: Text('Save followers to a file')),


                SizedBox(height: 120,),

                ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles();

                      if (result != null) {
                        File file = File(result.files.single.path!);
                        List<String> lines = await file.readAsLines();
                        final newItems = lines
                            .where((line) => line.trim().isNotEmpty)
                            .map<int>((line) => int.tryParse(line.trim()) ?? 0) // Convert to int
                            .where((number) => number != 0)
                            .toSet();
                        int followersBefore = followers.length;
                        followers.addAll(newItems);
                        int followersAfter = followers.length;
                        follower2.addAll(followers);
                        setState(() {
                          message = 'Adding ${newItems.length}, actual increase ${followersAfter - followersBefore}';
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                    child: Text('Load followers from a file'))
              ],
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('total followers ${followers.length}'),
              Text('$message'),
              Expanded(child:
              Container(
                  color: Colors.blue,
                  height: 300,
                  width: 300,
                  child: Scrollbar(
                      thumbVisibility: true,
                      trackVisibility: true,
                      thickness: 10,
                      interactive: false,

                      radius: Radius.circular(10),

                      controller: _scrollController,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: follower2.length,
                          cacheExtent: 1000,
                          itemBuilder: (context, index) {
                            //  ListTile( key: ValueKey(index), title: Text('$index - ${followers.elementAt(index)}'));
                            return Text('$index - ${follower2.elementAt(index)}');
                          })))),
            ]),
          ]),
        ));
  }
}
