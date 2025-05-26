import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const LightsOutApp());
}

class LightsOutApp extends StatelessWidget {
  const LightsOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LightsOutGame(),
    );
  }
}

class LightsOutGame extends StatefulWidget {
  const LightsOutGame({super.key});

  @override
  State<LightsOutGame> createState() => _LightsOutGameState();
}

class _LightsOutGameState extends State<LightsOutGame> {
  static const int gridSize = 5;
  late List<List<bool>> grid;
  int moveCount = 0;  // licznik ruchów

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid() {
    final rand = Random();
    grid = List.generate(gridSize, (i) =>
        List.generate(gridSize, (j) => rand.nextBool()));
    moveCount = 0;  // reset ruchów przy nowej grze
  }

  void _toggle(int x, int y) {
    setState(() {
      void flip(int i, int j) {
        if (i >= 0 && i < gridSize && j >= 0 && j < gridSize) {
          grid[i][j] = !grid[i][j];
        }
      }

      flip(x, y);
      flip(x - 1, y);
      flip(x + 1, y);
      flip(x, y - 1);
      flip(x, y + 1);

      moveCount++; // zwiększamy licznik ruchów
    });
  }

  bool _isGameWon() {
    for (var row in grid) {
      if (row.contains(true)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POTEC - Projekt Oszustwo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(_initializeGrid);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ruchy: $moveCount',
            style: const TextStyle(fontSize: 20),
          ),
          if (_isGameWon())
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'You won!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: gridSize * gridSize,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
            ),
            itemBuilder: (context, index) {
              int x = index ~/ gridSize;
              int y = index % gridSize;
              bool isOn = grid[x][y];
              return GestureDetector(
                onTap: () => _toggle(x, y),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  color: isOn ? Colors.yellow : Colors.grey[800],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
