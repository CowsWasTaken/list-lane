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
      home: const MyHomePage(title: 'List Lane'),
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
  int _counter = 0;

  List<bool> isChecked = List.generate(20, (index) => false);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  double calculateProgress() {
    int checkedCount = isChecked.where((element) => element).length;
    return checkedCount / isChecked.length;
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,  // Hier setzen wir die Kurve
            builder: (BuildContext context, double value, Widget? child) {
              return LinearProgressIndicator(
                value: value,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
        ),
        actions: [
          Flexible(child: Tooltip(
            message: "Search for Entry",
            child: IconButton(
              icon: const Icon(Icons.search_outlined),
              onPressed: () => handleOnSearchEvent(),
            ),
          ))
        ],
      ),
      body: MyListView(
        onItemChecked: (index, value) {
          setState(() {
            isChecked[index] = value;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  handleOnSearchEvent() {}

}
class MyListView extends StatefulWidget {
  const MyListView({super.key, required this.onItemChecked});
  final Function(int index, bool value) onItemChecked;

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<bool> isChecked = List.generate(20, (index) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return InkWell(
          child: Card(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(
                Icons.abc,
                size: 50,
              ),
              title: Text('Item $index'),
              subtitle: Text('Subtitle for $index'),
              trailing: Checkbox(
                value: isChecked[index],
                onChanged: (bool? value) {
                  setState(() {
                    isChecked[index] = value!;
                  });
                  widget.onItemChecked(index, value!);
                },
              ),
            ),
          ),
          onTap: () {
            setState(() {
              isChecked[index] = !isChecked[index];
            });
            widget.onItemChecked(index, isChecked[index]);
          },
        );
      },
    );
  }
}
