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
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
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

  bool isModifying = false; //수정 하는 중에 다른 할 일을 추가하면 문제가 생길 수 있음!
  //수정을 할 때는 수정을 완료하기까지 수정만 할 수 있도록!
  int modifyingIndex = 0; //인덱스 저장 공간
  double percent = 0.0;

  String getToday() {
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }

  void updatePercent() {
    if (tasks.isEmpty) {
      percent = 0.0;
    } else {
      var completeTaskCnt = 0;
      for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].isComplete) {
          completeTaskCnt += 1;
        }
      }
      percent = completeTaskCnt / tasks.length; //원하는 퍼센트
    }
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
      body: SingleChildScrollView(
        child: Center(
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
                          isModifying
                              ? setState(() {
                                  //수정 중이다
                                  tasks[modifyingIndex].work =
                                      _textController.text;
                                  tasks[modifyingIndex].isComplete = false;
                                  _textController.clear();
                                  modifyingIndex = 0;
                                  isModifying = false;
                                })
                              : setState(() {
                                  //수정 중이 아니다(추가)
                                  var task = Task(_textController.text);
                                  tasks.add(task);
                                  _textController.clear();
                                });
                          updatePercent();
                        }
                      },
                      child: isModifying ? const Text("수정") : const Text("추가"),
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
                      //진척도
                      width: MediaQuery.of(context).size.width -
                          50, //of(context)에 기기의 크기가 들어있다.
                      lineHeight: 14.0, //막대기의 높이는 임의지정했음
                      percent: percent,
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
                        onPressed: () {
                          setState(() {
                            tasks[i].isComplete = !tasks[i].isComplete;
                            updatePercent();
                          });
                        }, //onPressed 함수
                        child: Row(
                          children: [
                            //기본값이 false
                            tasks[i].isComplete
                                ? const Icon(Icons.check_box_rounded)
                                : const Icon(
                                    Icons.check_box_outline_blank_rounded),
                            Text(
                              tasks[i].work,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isModifying
                          ? null //현재 수정 중이라면 비활성화
                          : () {
                              setState(() {
                                //수정한 걸 즉시 보기 위해
                                isModifying = true;
                                _textController.text = tasks[i].work;
                                modifyingIndex = i; //modifyingIndex를 현재 인덱스로 저장
                              });
                            },
                      child: const Text("수정"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tasks.remove(tasks[i]);
                          updatePercent();
                        });
                      },
                      child: const Text("삭제"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
