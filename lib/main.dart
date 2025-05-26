import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const LightsOutApp());
}

class LightsOutApp extends StatefulWidget {
  const LightsOutApp({super.key});

  @override
  State<LightsOutApp> createState() => _LightsOutAppState();
}

class _LightsOutAppState extends State<LightsOutApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.grey[200],
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
      ),
      home: LightsOutGame(onToggleTheme: _toggleTheme),
    );
  }
}

class LightsOutGame extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const LightsOutGame({super.key, required this.onToggleTheme});

  @override
  State<LightsOutGame> createState() => _LightsOutGameState();
}

class _LightsOutGameState extends State<LightsOutGame> {
  static const int gridSize = 5;
  late List<List<bool>> grid;
  int moveCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeGrid();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartDialog();
    });
  }

  void _initializeGrid() {
    final rand = Random();
    grid = List.generate(gridSize, (i) =>
        List.generate(gridSize, (j) => rand.nextBool()));
    moveCount = 0;
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

      moveCount++;
    });
  }

  bool _isGameWon() {
    for (var row in grid) {
      if (row.contains(true)) return false;
    }
    return true;
  }

  void _showStartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Gra Lights Out'),
          content: const Text(
            'Ta aplikacja została stworzona na podstawie układu z programu Logisim Evolution '
            'na potrzeby projektu na przedmiot POTEC w semestrze 25L.\n\n'
            'Autorzy projektu:\nKinga Konieczna,\nTymon Zadara,\nJan Czechowski\n\nInżynieria Internetu Rzeczy, EiTI, Politechnika Warszawska.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('POTEC - Lights Out'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(_initializeGrid);
            },
          ),
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            tooltip: 'Zmień motyw',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ruchy: $moveCount',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (_isGameWon())
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'You won!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: gridSize * gridSize,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  int x = index ~/ gridSize;
                  int y = index % gridSize;
                  bool isOn = grid[x][y];

                  return GestureDetector(
                    onTap: () => _toggle(x, y),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isOn ? Colors.amber : Colors.grey,
                          width: 3,
                        ),
                        boxShadow: [
                          if (isOn)
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          isOn ? 'assets/images/on-128.png' : 'assets/images/off-128-2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
