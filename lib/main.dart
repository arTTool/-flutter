import 'dart:collection';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_tic_tac_toe/OWidget.dart';

import 'XWidget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {"/": (context) => const MainPage()},
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<List<int>> ticList = List.generate(3, (_) => List.generate(3, (_) => 0));
  List<List<bool>> redFlag = List.generate(3, (_) => List.generate(3, (_) => false));
  List<List<bool>> blueFlag = List.generate(3, (_) => List.generate(3, (_) => false));
  String redLast = "";
  String blueLast = "";
  bool firstFlag = false;
  Queue<String> queueRed = Queue();
  Queue<String> queueBlue = Queue();
  int tempNum = 0; //临时的
  int maxNum = 0;
  List<List<bool>> listStatus = List.generate(3, (_) => List.generate(3, (_) => false));
  bool gameFlag = false;

  void checkGame(int x, int y, int target) {
    vertical(x, y, target);
    maxNum = max(maxNum, tempNum);
    tempNum = 0;
    listStatus = List.generate(3, (_) => List.generate(3, (_) => false));
    horizontal(x, y, target);
    maxNum = max(maxNum, tempNum);
    tempNum = 0;
    listStatus = List.generate(3, (_) => List.generate(3, (_) => false));
    leftUpToRight(x, y, target);
    maxNum = max(maxNum, tempNum);
    tempNum = 0;
    listStatus = List.generate(3, (_) => List.generate(3, (_) => false));
    leftToRightUp(x, y, target);
    maxNum = max(maxNum, tempNum);
    tempNum = 0;
    listStatus = List.generate(3, (_) => List.generate(3, (_) => false));
    if (maxNum == 3) {
      gameFlag = true;
    }
  }

  void vertical(int x, int y, int target) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return;
    }
    if (ticList[x][y] != target || listStatus[x][y]) {
      return;
    } else {
      tempNum++;
    }
    listStatus[x][y] = true;
    vertical(x, y - 1, target);
    vertical(x, y + 1, target);
  }

  void horizontal(int x, int y, int target) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return;
    }
    if (ticList[x][y] != target || listStatus[x][y]) {
      return;
    } else {
      tempNum++;
    }
    listStatus[x][y] = true;
    horizontal(x - 1, y, target);
    horizontal(x + 1, y, target);
  }

  void leftUpToRight(int x, int y, int target) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return;
    }
    if (ticList[x][y] != target || listStatus[x][y]) {
      return;
    } else {
      tempNum++;
    }
    listStatus[x][y] = true;
    leftUpToRight(x - 1, y - 1, target);
    leftUpToRight(x + 1, y + 1, target);
  }

  void leftToRightUp(int x, int y, int target) {
    if (x < 0 || x > 2 || y < 0 || y > 2) {
      return;
    }
    if (ticList[x][y] != target || listStatus[x][y]) {
      return;
    } else {
      tempNum++;
    }
    listStatus[x][y] = true;
    leftToRightUp(x - 1, y + 1, target);
    leftToRightUp(x + 1, y - 1, target);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: width - 20,
              decoration: BoxDecoration(color: Colors.yellow, borderRadius: BorderRadius.circular(15)),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 9,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    int x = index % 3;
                    int y = index ~/ 3;
                    return GestureDetector(
                      onTap: () {
                        if (!gameFlag) {
                          if (!firstFlag && ticList[x][y] == 0) {
                            ticList[x][y] = 1;
                            if (redLast != "") {
                              int x = int.parse(redLast.substring(0, 1));
                              int y = int.parse(redLast.substring(2, 3));
                              ticList[x][y] = 0;
                            }
                            firstFlag = !firstFlag;
                            if (queueRed.length <= 3) {
                              String str = "$x:$y";
                              queueRed.add(str);
                            }
//蓝色透明
                            if (queueBlue.length == 3) {
                              blueFlag = List.generate(3, (_) => List.generate(3, (_) => false));
                              String str = queueBlue.removeFirst();
                              blueLast = str;
                              int x = int.parse(str.substring(0, 1));
                              int y = int.parse(str.substring(2, 3));
                              blueFlag[x][y] = true;
                            }
                            checkGame(x, y, 1);
                          } else if (firstFlag && ticList[x][y] == 0) {
                            ticList[x][y] = 2;
                            if (blueLast != "") {
                              int x = int.parse(blueLast.substring(0, 1));
                              int y = int.parse(blueLast.substring(2, 3));
                              ticList[x][y] = 0;
                            }
                            firstFlag = !firstFlag;
                            if (queueBlue.length <= 3) {
                              String str = "$x:$y";
                              queueBlue.add(str);
                            }
                            if (queueRed.length == 3) {
                              redFlag = List.generate(3, (_) => List.generate(3, (_) => false));
                              String str = queueRed.removeFirst();
                              redLast = str;
                              int x = int.parse(str.substring(0, 1));
                              int y = int.parse(str.substring(2, 3));
                              redFlag[x][y] = true;
                            }
//检查
                            checkGame(x, y, 2);
                          }
                        }
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
                        child: ticList[x][y] == 1
                            ? ORedWidget(
                                size: width / 5,
                                color: redFlag[x][y] ? const Color.fromRGBO(250, 0, 0, 0.5) : Colors.red,
                              )
                            : ticList[x][y] == 0
                                ? null
                                : XBlueWidget(
                                    size: width / 5,
                                    color: blueFlag[x][y] ? const Color.fromRGBO(33, 150, 243, 0.5) : Colors.blue,
                                  ),
                      ),
                    );
                  }),
            ),
          ),
          const Positioned(
            child: Text('有问题联系qq:178585584'),
            left: 10,
            bottom: 10,
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: ElevatedButton(
                onPressed: () {
                  ticList = List.generate(3, (_) => List.generate(3, (_) => 0));
                  redFlag = List.generate(3, (_) => List.generate(3, (_) => false));
                  blueFlag = List.generate(3, (_) => List.generate(3, (_) => false));
                  redLast = "";
                  blueLast = "";
                  firstFlag = false;
                  queueRed = Queue();
                  queueBlue = Queue();
                  tempNum = 0;
                  maxNum = 0;
                  gameFlag = false;
                  setState(() {});
                },
                child: const Text('重新开始')),
          )
        ],
      ),
    );
  }
}
