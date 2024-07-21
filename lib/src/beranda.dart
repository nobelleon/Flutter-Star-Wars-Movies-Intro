import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with SingleTickerProviderStateMixin {
  final String titleText = '''Episode 3 
  
  REVENGE OF THE SITH
  
  ''';

  final String crawlText =
      '''War! The Republic is crumbling under attacks by the ruthless Sith Lord, Count Dooku. There are heroes on both sides. Evil is everywhere.

In a stunning move, the fiendish droid leader, General Grievous, has swept into the Republic capital and kidnapped Chancellor Palpatine, leader of the Galactic Senate.

As the Separatist Droid Army attempts to flee the besieged capital with their valuable hostage, two Jedi Knights lead a desperate mission to rescue the captive Chancellor....''';

  late final AnimationController _animationController;

  late final Animation<Offset> crawlTextposition;

  late final Animation<double> disappearCrawlText;

  late AudioCache audioPlayer = AudioCache();

  void playAnimation() {
    final height = MediaQuery.of(context).size.height;
    final topOffset = height + 100;
    final bottomOffset = -height / 2;
    crawlTextposition =
        Tween(begin: Offset(0, topOffset), end: Offset(0, bottomOffset))
            .animate(_animationController);
    disappearCrawlText = Tween<double>(begin: 1.0, end: 0)
        .chain(
          CurveTween(
            curve: Interval(0.9, 0.95),
          ),
        )
        .animate(_animationController);

    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  Future<void> playTrack() async {
    await audioPlayer.load("star_wars_intro.mp3");
    await audioPlayer.play("star_wars_intro.mp3");
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    //playAnimation();
    playTrack();
  }

  @override
  void didChangeDependencies() {
    playAnimation();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/galaxy.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4, //370,
              height: 818,
              child: Transform(
                origin: Offset(
                  MediaQuery.of(context).size.width / 2 -
                      MediaQuery.of(context).size.width * 0.35, //540, 0.37
                  150,
                ),
                transform: Matrix4.identity()
                  ..setRotationX(
                    pi / 2.5, //2.8, //2.5,
                  )
                  ..setEntry(
                    3,
                    1,
                    -0.001,
                  ),
                child: AnimatedBuilder(
                  animation: _animationController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        titleText,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xffc7890a),
                          fontFamily: "Crawl",
                        ),
                      ),
                      Text(
                        crawlText,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xffc7890a),
                          fontFamily: "Crawl",
                        ),
                      ),
                    ],
                  ),
                  builder: (context, child) {
                    return Transform.translate(
                      offset: crawlTextposition.value,
                      child: Opacity(
                        opacity: disappearCrawlText.value,
                        child: child,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
