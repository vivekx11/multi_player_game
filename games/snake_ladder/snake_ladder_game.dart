import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── SETUP SCREEN ───
class SnakeLadderSetup extends StatefulWidget {
  const SnakeLadderSetup({super.key});

  @override
  State<SnakeLadderSetup> createState() => _SnakeLadderSetupState();
}

class _SnakeLadderSetupState extends State<SnakeLadderSetup> {
  int playerCount = 2;

  final List<Color> playerColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFF44336),
    const Color(0xFFFF9800),
  ];

  final List<String> playerNames = ['Green', 'Blue', 'Red', 'Orange'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake & Ladder', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F3A),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF43E97B).withValues(alpha: 0.2),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.pest_control, size: 60, color: const Color(0xFF43E97B)),
                    const SizedBox(height: 16),
                    Text(
                      'Snake & Ladder',
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Classic board game fun!',
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Players',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        final count = i + 2;
                        final selected = playerCount == count;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => playerCount = count),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: selected
                                    ? const LinearGradient(colors: [Color(0xFF43E97B), Color(0xFF38F9D7)])
                                    : null,
                                color: selected ? null : const Color(0xFF252A4A),
                                border: Border.all(
                                  color: selected ? Colors.transparent : Colors.white24,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$count',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: selected ? Colors.black : Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: List.generate(playerCount, (i) {
                        return Chip(
                          avatar: CircleAvatar(backgroundColor: playerColors[i], radius: 10),
                          label: Text('Player ${i + 1} (${playerNames[i]})'),
                          backgroundColor: const Color(0xFF252A4A),
                          labelStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SnakeLadderBoard(playerCount: playerCount),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43E97B),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                        ),
                        child: Text('Start Game', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── GAME BOARD ───
class SnakeLadderBoard extends StatefulWidget {
  final int playerCount;
  const SnakeLadderBoard({super.key, required this.playerCount});

  @override
  State<SnakeLadderBoard> createState() => _SnakeLadderBoardState();
}

class _SnakeLadderBoardState extends State<SnakeLadderBoard>
    with TickerProviderStateMixin {
  late List<int> positions;
  int currentPlayer = 0;
  int diceValue = 1;
  bool isRolling = false;
  bool gameOver = false;
  int? winner;
  final Random _random = Random();

  late AnimationController _diceAnimController;
  late AnimationController _bounceController;

  final List<Color> playerColors = [
    const Color(0xFF4CAF50),
    const Color(0xFF2196F3),
    const Color(0xFFF44336),
    const Color(0xFFFF9800),
  ];

  // Snakes: head -> tail
  final Map<int, int> snakes = {
    16: 6,
    47: 26,
    49: 11,
    56: 53,
    62: 19,
    64: 60,
    87: 24,
    93: 73,
    95: 75,
    98: 78,
  };

  // Ladders: bottom -> top
  final Map<int, int> ladders = {
    1: 38,
    4: 14,
    9: 31,
    21: 42,
    28: 84,
    36: 44,
    51: 67,
    71: 91,
    80: 100,
  };

  @override
  void initState() {
    super.initState();
    positions = List.filled(widget.playerCount, 0);
    _diceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _diceAnimController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _rollDice() async {
    if (isRolling || gameOver) return;
    setState(() => isRolling = true);

    // Dice animation
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() => diceValue = _random.nextInt(6) + 1);
    }

    final roll = diceValue;
    int newPos = positions[currentPlayer] + roll;

    if (newPos > 100) {
      // Can't move, need exact
      setState(() {
        isRolling = false;
        currentPlayer = (currentPlayer + 1) % widget.playerCount;
      });
      return;
    }

    if (newPos == 100) {
      setState(() {
        positions[currentPlayer] = 100;
        gameOver = true;
        winner = currentPlayer;
        isRolling = false;
      });
      _showWinnerDialog();
      return;
    }

    // Check snakes and ladders
    if (snakes.containsKey(newPos)) {
      setState(() => positions[currentPlayer] = newPos);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      newPos = snakes[newPos]!;
      _bounceController.forward().then((_) => _bounceController.reverse());
    } else if (ladders.containsKey(newPos)) {
      setState(() => positions[currentPlayer] = newPos);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      newPos = ladders[newPos]!;
      _bounceController.forward().then((_) => _bounceController.reverse());
    }

    setState(() {
      positions[currentPlayer] = newPos;
      isRolling = false;
      if (roll != 6) {
        currentPlayer = (currentPlayer + 1) % widget.playerCount;
      }
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 12),
            Text(
              'Player ${winner! + 1} Wins!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: playerColors[winner!],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Congratulations!',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _restartGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43E97B),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Play Again', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Home', style: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _restartGame() {
    setState(() {
      positions = List.filled(widget.playerCount, 0);
      currentPlayer = 0;
      diceValue = 1;
      isRolling = false;
      gameOver = false;
      winner = null;
    });
  }

  int _getBoardNumber(int row, int col) {
    // Bottom-left start, snake pattern
    int number;
    if (row % 2 == 0) {
      number = (9 - row) * 10 + col + 1;
    } else {
      number = (9 - row) * 10 + (10 - col);
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Snake & Ladder', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _restartGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart',
          ),
        ],
      ),
      body: Column(
        children: [
          // Player info bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(widget.playerCount, (i) {
                final isCurrent = i == currentPlayer && !gameOver;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isCurrent ? playerColors[i].withValues(alpha: 0.2) : Colors.transparent,
                    border: isCurrent ? Border.all(color: playerColors[i], width: 2) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: playerColors[i],
                        child: Text('${i + 1}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${positions[i]}',
                        style: GoogleFonts.poppins(
                          color: isCurrent ? Colors.white : Colors.white54,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          // Board
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                    color: const Color(0xFF141830),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                      ),
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        int row = index ~/ 10;
                        int col = index % 10;
                        int number = _getBoardNumber(row, col);

                        bool isSnakeHead = snakes.containsKey(number);
                        bool isLadderBottom = ladders.containsKey(number);

                        Color bgColor;
                        if (isSnakeHead) {
                          bgColor = Colors.red.withValues(alpha: 0.25);
                        } else if (isLadderBottom) {
                          bgColor = Colors.green.withValues(alpha: 0.25);
                        } else if (number == 100) {
                          bgColor = Colors.amber.withValues(alpha: 0.3);
                        } else {
                          bgColor = (row + col) % 2 == 0
                              ? const Color(0xFF1E2348)
                              : const Color(0xFF252B52);
                        }

                        // Players on this tile
                        List<int> playersHere = [];
                        for (int p = 0; p < widget.playerCount; p++) {
                          if (positions[p] == number) playersHere.add(p);
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          child: Stack(
                            children: [
                              // Number
                              Positioned(
                                top: 1,
                                left: 2,
                                child: Text(
                                  '$number',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Snake/Ladder indicator
                              if (isSnakeHead)
                                Positioned(
                                  top: 0,
                                  right: 1,
                                  child: Text('🐍', style: TextStyle(fontSize: 10)),
                                ),
                              if (isLadderBottom)
                                Positioned(
                                  top: 0,
                                  right: 1,
                                  child: Text('🪜', style: TextStyle(fontSize: 10)),
                                ),
                              if (number == 100)
                                const Center(child: Text('🏆', style: TextStyle(fontSize: 14))),
                              // Player tokens
                              if (playersHere.isNotEmpty)
                                Center(
                                  child: Wrap(
                                    spacing: 1,
                                    runSpacing: 1,
                                    alignment: WrapAlignment.center,
                                    children: playersHere.map((p) {
                                      return Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: playerColors[p],
                                          border: Border.all(color: Colors.white, width: 1),
                                          boxShadow: [
                                            BoxShadow(
                                              color: playerColors[p].withValues(alpha: 0.6),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${p + 1}',
                                            style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Dice and controls
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dice
                    GestureDetector(
                      onTap: _rollDice,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: playerColors[currentPlayer].withValues(alpha: 0.4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _diceEmoji(diceValue),
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Roll button
                    ElevatedButton.icon(
                      onPressed: isRolling || gameOver ? null : _rollDice,
                      icon: const Icon(Icons.casino),
                      label: Text(
                        isRolling ? 'Rolling...' : 'Roll Dice',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: playerColors[currentPlayer],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!gameOver)
                  Text(
                    'Player ${currentPlayer + 1}\'s turn',
                    style: GoogleFonts.poppins(
                      color: playerColors[currentPlayer],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _diceEmoji(int val) {
    switch (val) {
      case 1: return '⚀';
      case 2: return '⚁';
      case 3: return '⚂';
      case 4: return '⚃';
      case 5: return '⚄';
      case 6: return '⚅';
      default: return '⚀';
    }
  }
}
