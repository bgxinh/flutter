import 'package:flutter/material.dart';
import 'package:memory/data/data.dart';
import 'package:memory/screen/high_score.dart';
import 'package:audioplayers/audioplayers.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  AudioPlayer bgSound = AudioPlayer();


  @override
  void initState() {
    super.initState();
    _playBackgroundMusic();
  }

  @override
  void dispose() {
    bgSound.dispose();
    super.dispose();
  }

Future<void> _playBackgroundMusic() async {
    if (!Data.neverPlay) {
      await bgSound.setSource(AssetSource("audios/background.wav"));
      await bgSound.resume();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0, 0.46, 1],
          colors: [Color(0xffFFCC70), Color(0xffC850C0), Color(0xff4158D0)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Colors.transparent,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Music",
                            style: TextStyle(
                              color: Color(0xffDD2A7B),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                           Switch(
                            value: Data.neverPlay == false ? true : false,
                            onChanged: (value) {
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
                            activeTrackColor: const Color(0xffDD2A7B),
                            activeColor: Colors.white,
                            inactiveTrackColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const HighScore(); // Update with actual HighScore class
                      },
                    ));
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.white,
                      child: const Center(
                        child: Text(
                          "High Score",
                          style: TextStyle(
                            color: Color(0xffDD2A7B),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}