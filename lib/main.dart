import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlueAccent,
        hintColor: Colors.purpleAccent,
        fontFamily: 'Montserrat',
      ),
      home: const StopwatchScreen(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      setState(() {
        _stopwatch.start();
        _startTimer();
      });
    }
  }

  void _stopStopwatch() {
    if (_stopwatch.isRunning) {
      setState(() {
        _stopwatch.stop();
      });
      _timer?.cancel();
    }
  }

  void _resetStopwatch() {
    if (!_stopwatch.isRunning) {
      setState(() {
        _stopwatch.reset();
      });
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Stopwatch and Label
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                
                const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Text(
                    'Stopwatch',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20), 
                
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: _formattedMinutesSeconds()),
                      TextSpan(text: ":${_formattedMilliseconds()}"),
                      TextSpan(text: ":${_formattedMicroseconds()}"),
                    ],
                  ),
                ),
              ],
            ),
            // Start/Stop/Reset buttons
            Positioned(
              bottom: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(Icons.play_arrow, _startStopwatch),
                  const SizedBox(width: 20),
                  _buildButton(Icons.stop, _stopStopwatch),
                  const SizedBox(width: 20),
                  _buildButton(Icons.refresh, _resetStopwatch),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formattedMinutesSeconds() {
    var seconds = (_stopwatch.elapsedMilliseconds / 1000).truncate();
    var minutes = (seconds / 60).truncate();
    return '${(minutes % 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  String _formattedMilliseconds() {
    var milliseconds = (_stopwatch.elapsedMilliseconds % 1000) ~/ 10;
    return milliseconds.toString().padLeft(2, '0');
  }

  String _formattedMicroseconds() {
    var microseconds = (_stopwatch.elapsedMicroseconds % 1000000) % 100;
    return microseconds.toString().padLeft(2, '0');
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.white.withOpacity(0.3), shape: const CircleBorder(),
        padding: const EdgeInsets.all(24), // Icon color
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 30),
    );
  }
}
