import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// This example show how to play the Lottie animation in various way:
/// - Start and stop the animation forward
/// - Play the animation in reverse
/// - Loop between two specific frames
///
/// This works by creating an AnimationController instance and passing it
/// to the Lottie widget.
/// The AnimationController class has a rich API to run the animation in various ways.
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  bool get _isLoaded => _controller.duration != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animation control'),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/LottieLogo1.json',
              controller: _controller,
              height: 300,
              onLoaded: (composition) {
                setState(() {
                  _controller.duration = composition.duration;
                });
              },
            ),
            if (_isLoaded) ...[
              Text('${_controller.value.toStringAsFixed(2)}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Transform(
                      child: Icon(Icons.play_arrow),
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(math.pi),
                    ),
                    onPressed: () {
                      // Play the animation in reverse

                      if (_controller.value == 0) _controller.value = 1;
                      _controller.reverse(from: _controller.value);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: _controller.isAnimating
                        ? () {
                            _controller.stop();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      // Play the animation forward from where is is

                      if (_controller.value == 1) _controller.value = 0;
                      _controller.forward(
                          from: _controller.value == 1 ? 0 : _controller.value);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              RaisedButton(
                child: Text('Loop between frames'),
                onPressed: () {
                  // Loop between 2 specifics frames

                  var start = 0.1;
                  var stop = 0.5;
                  _controller.repeat(
                    min: start,
                    max: stop,
                    reverse: true,
                    period: _controller.duration * (stop - start),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}