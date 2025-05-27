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

  enum Difficulty { easy, hard }
class _LightsOutGameState extends State<LightsOutGame> {

  Difficulty _difficulty = Difficulty.easy;  // domyślnie łatwe
  static const int gridSize = 5;
  late List<List<bool>> grid;
  int moveCount = 0;

  // Przykładowe łatwe plansze (5x5) DO MODYFIKACJI!!!
  static final List<List<List<bool>>> easyBoards = [
    // // PRZYKŁADOWA - WSZYSTKIE NA FALSE DO MODYFIKACJI!
    // Plansza nr 1
    // [
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    // ],

    // Plansza nr 1
    [
      [false, false, false, false, false],
      [false, false, false, false, false],
      [true,  false,  true, false,  true],
      [true,  false,  true, false,  true],
      [false,  true,  true,  true, false],
    ],
    
    // Plansza nr 2
    [
      [false, true, true, true, false],
      [false, true,  true, true,  false],
      [false, true, true, true, false],
      [false, false,  false, false,  false],
      [false, false, false, false, false],
    ],

    // Plansza nr 3
    [
      [true, true, true,  true, false],
      [true, false,  false, false,  true],
      [true,  false, false, false, true],
      [true, false,  false, false,  true],
      [true, true, true,  true, false],
    ],

    // Plansza nr 4
    [
      [true, false, true,  false, true],
      [true, false,  false, false,  true],
      [true,  true, false, true, true],
      [true, false,  false, false,  true],
      [true, false, true,  false, true],
    ],

    // Plansza nr 5
    [
      [false, true, false,  true, false],
      [true, true,  true, true,  true],
      [false,  true, true, true, false],
      [false, true,  false, true,  true],
      [true, true, true,  false, false],
    ],

    // Plansza nr 6
    [
      [false, true, false,  true, false],
      [true, true,  true, true,  true],
      [true,  false, true, false, true],
      [true, true,  true, true,  true],
      [false, true, false,  true, false],
    ],

    // Plansza nr 7
    [
      [false, false, false,  false, false],
      [false, false,  true, false,  false],
      [true,  true, false, true, true],
      [false, false,  true, false,  false],
      [false, false, false,  false, false],
    ],

    // Plansza nr 8
    [
      [true, false, true,  false, true],
      [true, false,  false, false,  true],
      [false,  true, true, true, false],
      [true, false,  false, false,  true],
      [true, false, true,  false, true],
    ],

    // Plansza nr 9
    [
      [true, true, true,  true, true],
      [false, false,  true, false,  false],
      [true,  false, false, false, true],
      [false, false,  true, false,  false],
      [true, true, true,  true, true],
    ],

    // Plansza nr 10
    [
      [false, false, false, true, false],
      [false, false, true, false, true],
      [false, true, false, true, false],
      [true, false, true, false, false],
      [false, true, false, false, false],
    ],
    
    // Plansza nr 11
    [
      [true, false, false, false, true],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [true, false, false, false, true],
    ],
    
    // Plansza nr 12
    [
      [true, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, true],
    ],

    // Plansza nr 13
    [
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, true, false, false, false],
      [false, true, false, false, false],
      [false, true, false, false, false],
    ],
    
    // Plansza nr 14
    [
      [true, false, false, false, true],
      [false, true, false, true, false],
      [false, false, false, false, false],
      [false, true, false, true, false],
      [true, false, false, false, true],
    ],
    
    // Plansza nr 15
    [
      [false, true, true, true, false],
      [false, true, false, true, false],
      [false, true, true, true, false],
      [false, false, false, true, false],
      [false, true, true, true, false],
    ],
    
    // Plansza nr 16
    [
      [false, false, false, false, false],
      [true, true, false, false, false],
      [false, false, false, true, false],
      [true, false, false, false, true],
      [false, false, true, true, false],
    ],
    
    // Plansza nr 17
    [
      [false, false, true, true, false],
      [false, true, false, false, true],
      [true, true, true, false, false],
      [false, false, false, true, true],
      [true, true, false, true, false],
    ],
    
    // Plansza nr 18
    [
      [true, true, true, false, true],
      [true, false, true, true, true],
      [false, true, false, false, true],
      [true, true, false, true, true],
      [false, false, false, true, false],
    ],
    
    // Plansza nr 19
    [
      [false, false, false, true, false],
      [true, false, true, true, false],
      [false, false, true, true, true],
      [false, false, false, false, false],
      [false, false, false, true, false],
    ],
    
    // Plansza nr 20
    [
      [true, true, true, false, false],
      [false, false, true, false, true],
      [false, true, false, false, true],
      [false, false, false, false, true],
      [true, false, true, false, true],
    ],
    
    // Plansza nr 21
    [
      [false, false, true, true, true],
      [true, false, true, false, false],
      [false, true, false, true, false],
      [false, false, false, false, false],
      [true, false, true, true, false],
    ],
    
    // Plansza nr 22
    [
      [false, false, true, false, false],
      [false, true, true, true, true],
      [true, false, true, false, false],
      [false, false, true, false, false],
      [false, true, false, false, false],
    ],
    
    // Plansza nr 23
    [
      [false, true, false, true, true],
      [true, true, true, true, true],
      [true, false, true, true, true],
      [true, false, true, true, false],
      [true, false, false, false, true],
    ],
    
    // Plansza nr 2
    // [
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    // ],
    
    // // Plansza nr 2
    // [
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    //   [false, false, false, false, false],
    // ],
    // DODAĆ PLANSZE KTÓRE SĄ ŁATWE!!!
  ];

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
    if (_difficulty == Difficulty.easy) {
      _loadEasyBoard();
    } else {
      grid = List.generate(gridSize, (i) => List.generate(gridSize, (j) => rand.nextBool()));
    }
    moveCount = 0;
  }
  // Nowa funkcja do wczytania łatwej planszy losowo
  void _loadEasyBoard() {
    final rand = Random();
    final board = easyBoards[rand.nextInt(easyBoards.length)];
    setState(() {
      grid = board.map((row) => row.toList()).toList(); // kopiujemy planszę
      moveCount = 0;
      _difficulty = Difficulty.easy;
    });
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

    if (_isGameWon()) {
      Future.delayed(const Duration(seconds: 1), () {
        _showWinDialog();
      });
    }
  }

  bool _isGameWon() {
    for (var row in grid) {
      if (row.contains(true)) return false;
    }
    return true;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // wymuszamy kliknięcie przycisku
      builder: (context) {
        return AlertDialog(
          title: const Text('Gratulacje!'),
          content: const Text('Wygrałeś!'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _initializeGrid();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Od nowa'),
            ),
          ],
        );
      },
    );
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
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0), // przesunięcie w prawo
        child: IconButton(
          icon: const Icon(Icons.lightbulb),
          tooltip: 'Wskazówki',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Center(child: Text('Wskazówka')),
                  content: const SingleChildScrollView(
                    child: Center(
                      child: Text(
                        ' DÓŁ      |   GÓRA\n\n'
                        'O---O     |   OO---\n'
                        '-O-O-     |   O--O-\n'
                        'OOO--     |   -O---\n'
                        '--OOO     |   ---O-\n'
                        'O-OO-     |   ----O\n'
                        '-OO-O     |   O----\n'
                        'OO-OO     |   --O--',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Zamknij'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),

        leadingWidth: 40,
        title: const Text(
          'POTEC - Lights Out',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        backgroundColor: isDark ? Colors.grey[900] : Colors.amber[700],
        foregroundColor: isDark ? Colors.white : Colors.black,
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
            // if (_isGameWon())
            //   const Padding(
            //     padding: EdgeInsets.all(16.0),
            //     child: Text(
            //       'Wygrałeś!',
            //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            //     ),
            //   ),
            Text(
              'Ruchy: $moveCount',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
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
            const SizedBox(height: 24),
            // Nowe menu na dole
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _difficulty == Difficulty.easy
                      ? Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _loadEasyBoard,
                            child: const Text('Łatwe'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              side: const BorderSide(color: Colors.amber, width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _loadEasyBoard,
                          child: const Text('Łatwe'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            side: BorderSide(color: Colors.transparent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                  const SizedBox(width: 16),
                  _difficulty == Difficulty.hard
                      ? Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _difficulty = Difficulty.hard;
                                _initializeGrid();
                              });
                            },
                            child: const Text('Trudne'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              side: const BorderSide(color: Colors.amber, width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _difficulty = Difficulty.hard;
                              _initializeGrid();
                            });
                          },
                          child: const Text('Trudne'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            side: BorderSide(color: Colors.transparent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                ],
              ),
            )

          //  const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}