import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory/data/data.dart';
import 'package:memory/screen/challenges.dart';
import 'package:memory/screen/high%20score.dart';
import 'package:memory/screen/memoryGame.dart';
import 'package:memory/screen/setting.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'challenges page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

AudioPlayer audioPlayer = AudioPlayer();

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final fireStore = Firebase.initializeApp();

  bool change = false;
  late Timer timer;

  bool newGame = false;
  bool level = false;
  bool challenges = false;
  bool highScore = false;

  @override
  void initState() {
    super.initState();
    getHighScore();
    WidgetsBinding.instance.addObserver(this);
    timer = Timer.periodic(Duration(milliseconds: 2700), (timer) {
      setState(() {
        if (Data.play == true && Data.neverPlay == false) {
          playAgain();
        }
        change = !change;
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        if (!Data.neverPlay) {
          setState(() {
            audioPlayer.pause();
            Data.play = false;
          });
        }
        break;
      case AppLifecycleState.resumed:
        if (!Data.neverPlay) {
          setState(() {
            audioPlayer.resume();
            Data.play = true;
          });
        }
        break;
      case AppLifecycleState.inactive:
        if (!Data.neverPlay) {
          setState(() {
            audioPlayer.pause();
            Data.play = false;
          });
        }
        break;
      case AppLifecycleState.detached:
        if (!Data.neverPlay) {
          setState(() {
            audioPlayer.pause();
            Data.play = false;
          });
        }
        break;
      default:
        break;
    }
  }

  playAgain() async {}

  getHighScore() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    if (myPrefs.getInt("hp") != null && myPrefs.getInt("tp") != null) {
      setState(() {
        Data.highScoreInPokemon = myPrefs.getInt("hp")!;
        Data.timeInPokemon = myPrefs.getInt("tp")!;
      });
    }

    if (myPrefs.getInt("he") != null && myPrefs.getInt("te") != null) {
      setState(() {
        Data.highScoreInEmoji = myPrefs.getInt("he")!;
        Data.timeInEmoji = myPrefs.getInt("te")!;
      });
    }

    if (myPrefs.getInt("hn") != null && myPrefs.getInt("tn") != null) {
      setState(() {
        Data.highScoreInNumber = myPrefs.getInt("hn")!;
        Data.timeInNumber = myPrefs.getInt("tn")!;
      });
    }

    if (myPrefs.getBool("play") != null) {
      setState(() {
        Data.neverPlay = myPrefs.getBool("play")!;
      });
    }
  }

  Future<void> share() async {
    try {
      fireStore.then((value) async {
        FirebaseFirestore.instance
            .collection("memory")
            .doc("1")
            .get()
            .then((result) {
          Share.share(result.get("share"));
        });
      });
    } catch (e) {
      snackBar("Something went wrong");
    }
  }

  void snackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.white,
        padding: EdgeInsets.only(left: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          s,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 2500),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: change == false ? Alignment.topRight : Alignment.topLeft,
                end: change == false
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                stops: [
              0,
              change == false ? 0.4 : 0.6,
              1
            ],
                colors: [
              Color(0xffFFCC70),
              Color(0xffC850C0),
              Color(0xff4158D0),
            ])),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height * 0.2,
                  //   width: MediaQuery.of(context).size.width * 0.75,
                  //   child: Card(
                  //     margin: EdgeInsets.all(0),
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //     elevation: 10,
                  //     child: Center(
                  //       child: AnimatedTextKit(
                  //         animatedTexts: [
                  //           WavyAnimatedText("Memory Game",
                  //               speed: Duration(milliseconds: 450),
                  //               textStyle: TextStyle(
                  //                 fontSize: 29,
                  //                 fontFamily: "Source",
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Color(0xffDD2A7B),
                  //               )),
                  //         ],
                  //         repeatForever: true,
                  //         isRepeatingAnimation: true,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 10,
                      child: Center(
                        child: Text(
                          "Memory Game",
                          style: TextStyle(
                            fontSize: 29,
                            fontFamily: "Source",
                            fontWeight: FontWeight.w600,
                            color: Color(0xffDD2A7B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.12,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Data.level = 1;
                      });
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Challenges();
                        },
                      ));
                    },
                    onTapDown: (value) {
                      setState(() {
                        newGame = true;
                      });
                    },
                    onTapUp: (value) {
                      setState(() {
                        newGame = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                      height: newGame == false ? 65 : 60,
                      width: newGame == false ? 200 : 185,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: Center(
                            child: Text(
                          "Levels",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Source",
                            fontWeight: FontWeight.w600,
                            color: Color(0xffDD2A7B),
                          ),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ChooseChallenges();
                        },
                      ));
                    },
                    onTapDown: (value) {
                      setState(() {
                        level = true;
                      });
                    },
                    onTapUp: (value) {
                      setState(() {
                        level = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                      height: level == false ? 70 : 65,
                      width: level == false ? 215 : 200,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: Center(
                            child: Text(
                          "Challenges",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Source",
                            fontWeight: FontWeight.w600,
                            color: Color(0xffDD2A7B),
                          ),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Memory();
                        },
                      ));
                    },
                    onTapDown: (value) {
                      setState(() {
                        challenges = true;
                      });
                    },
                    onTapUp: (value) {
                      setState(() {
                        challenges = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                      height: challenges == false ? 70 : 65,
                      width: challenges == false ? 215 : 200,
                      child: Card(
                        margin: EdgeInsets.all(0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: Center(
                            child: Text(
                          "Marathon",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Source",
                            fontWeight: FontWeight.w600,
                            color: Color(0xffDD2A7B),
                          ),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Data.neverPlay == true
                        ? Icons.play_circle_outline
                        : Icons.pause_circle_outline),
                    iconSize: 28,
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        if (Data.neverPlay == false) {
                          audioPlayer.pause();
                          Data.neverPlay = true;
                        } else {
                          audioPlayer.resume();
                          Data.neverPlay = false;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    iconSize: 25,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Setting();
                        },
                      ));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
