import 'package:flutter/material.dart';
import 'dart:async';
import 'package:typewritertext/typewritertext.dart';

class AnimatedTextCarousel extends StatefulWidget {
  @override
  _AnimatedTextCarouselState createState() => _AnimatedTextCarouselState();
}

class _AnimatedTextCarouselState extends State<AnimatedTextCarousel> {
  final List<String> _texts = [
    'Cegah stunting, wujudkan generasi yang sehat.',
    'Bersama kita lawan stunting demi masa depan anak.',
    'Jaga pertumbuhan anak, cegah stunting sejak dini.',
    'Indonesia Emas, Bebas Stunting.',
  ];

  int _currentIndex = 0;
  late Timer _timer;
  bool _isDisposed =
      false; // Flag untuk mengecek apakah widget sudah di-dispose

  void _changeText() {
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      // Pastikan tidak ada perubahan state jika widget sudah tidak aktif
      if (_isDisposed) return;

      Future.delayed(Duration(milliseconds: 1500), () {
        if (_isDisposed) return;

        setState(() {
          _currentIndex = (_currentIndex + 1) % _texts.length;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _changeText();
  }

  @override
  void dispose() {
    _isDisposed = true; // Tandai widget sebagai disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: double.infinity,
        child: TypeWriter.text(
          key: ValueKey<int>(_currentIndex),
          textAlign: TextAlign.center,
          _texts[_currentIndex],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
          duration: const Duration(milliseconds: 100),
        ),
      ),
    );
  }
}
