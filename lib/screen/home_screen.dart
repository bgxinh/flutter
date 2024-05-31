import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:memory/data/data.dart';
import 'package:memory/screen/challenges.dart';
import 'package:memory/screen/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'challenges_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AudioPlayer bgSound = AudioPlayer();
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool change = false;
  late Timer timer;

  bool newGame = false;
  bool level = false;
  bool challenges = false;
  bool highScore = false;

  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
    getHighScore();
    WidgetsBinding.instance.addObserver(this);
    timer = Timer.periodic(const Duration(milliseconds: 2700), (timer) {
      setState(() {
        if (Data.play == true && Data.neverPlay == false) {
          playAgain();
        }
        change = !change;
      });
    });
  }

  Future<void> _playBackgroundMusic() async {
    if (!Data.neverPlay) {
      await bgSound.setSource(AssetSource("audios/background.wav"));
      await bgSound.resume();
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

  void snackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.only(left: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          s,
          style: const TextStyle(
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
    bgSound.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 2500),
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
                colors: const [
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 10,
                      child: const Center(
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
                          return const Challenges();
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
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                      height: newGame == false ? 65 : 60,
                      width: newGame == false ? 200 : 185,
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: const Center(
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
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const ChooseChallenges();
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
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut,
                      height: level == false ? 70 : 65,
                      width: level == false ? 215 : 200,
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                        child: const Center(
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
                  const SizedBox(
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
                          bgSound.pause();
                          Data.neverPlay = true;
                        } else {
                          bgSound.resume();
                          Data.neverPlay = false;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    iconSize: 25,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const Setting();
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
