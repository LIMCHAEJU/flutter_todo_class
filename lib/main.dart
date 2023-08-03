import 'package:flutter/material.dart';
import 'package:flutter_application_13/task.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //화면에서 동적인 게 없을 때
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO DO List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TO DO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //이걸로 어플을 만들거임
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  List<Task> tasks = [];

  String getToday() {
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //appBar라는 위젯을 넣을거임!
        centerTitle: true, //타이틀 중앙 정렬
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, //세로기준으로 중앙
          children: [
            Text(getToday()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_textController.text == "") {
                        return;
                      } else {
                        setState(() {
                          var task = Task(_textController.text);
                          tasks.add(task);
                          _textController.clear();
                        });
                      }
                    },
                    child: const Text("Add"),
                  )
                ], //한 줄에 같이 들어갈 위젯들을 children안에 써주면 됨
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width -
                        50, //of(context)에 기기의 크기가 들어있다.
                    lineHeight: 14.0, //막대기의 높이는 임의지정했음
                    percent: 0.3,
                  ),
                ],
              ),
            ),
            for (var i = 0; i < tasks.length; i++)
              Row(
                children: [
                  Flexible(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                      ),
                      onPressed: () {}, //onPressed 함수
                      child: Row(
                        children: [
                          Icon(Icons.check_box_outline_blank_rounded),
                          Text(tasks[i].work),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("수정"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tasks.remove(tasks[i]);
                      });
                    },
                    child: const Text("삭제"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
