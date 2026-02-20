import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BingoSetup extends StatefulWidget {
  const BingoSetup({super.key});
  @override
  State<BingoSetup> createState() => _BingoSetupState();
}

class _BingoSetupState extends State<BingoSetup> {
  int playerCount = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bingo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFFFF416C).withValues(alpha: 0.2), blurRadius: 30)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.grid_on, size: 60, color: Color(0xFFFF416C)),
          const SizedBox(height: 16),
          Text('Bingo', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Match numbers, win big!', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54)),
          const SizedBox(height: 24),
          Text('Select Players', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) {
            final c = i + 2; final s = playerCount == c;
            return Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: GestureDetector(
              onTap: () => setState(() => playerCount = c),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 60, height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                  gradient: s ? const LinearGradient(colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]) : null,
                  color: s ? null : const Color(0xFF252A4A), border: Border.all(color: s ? Colors.transparent : Colors.white24)),
                child: Center(child: Text('$c', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: s ? Colors.white : Colors.white54))))));
          })),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BingoBoard(playerCount: playerCount))),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF416C), foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 8),
            child: Text('Start Game', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)))),
        ])))),
    );
  }
}

class BingoBoard extends StatefulWidget {
  final int playerCount;
  const BingoBoard({super.key, required this.playerCount});
  @override
  State<BingoBoard> createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  late List<List<int>> grids; // each player has 25 numbers
  late List<List<bool>> marked;
  late List<int> bingoCount;
  List<int> calledNumbers = [];
  int curPlayer = 0;
  bool over = false;
  int? winner;
  int? lastCalled;
  final rng = Random();

  static const bingoLetters = ['B', 'I', 'N', 'G', 'O'];
  static const List<Color> pColors = [Color(0xFFFF416C), Color(0xFF00D2FF), Color(0xFF43E97B), Color(0xFFFFD200)];

  @override
  void initState() {
    super.initState();
    grids = List.generate(widget.playerCount, (_) => _generateGrid());
    marked = List.generate(widget.playerCount, (_) => List.filled(25, false));
    bingoCount = List.filled(widget.playerCount, 0);
  }

  List<int> _generateGrid() {
    final nums = List.generate(25, (i) => i + 1);
    nums.shuffle(rng);
    return nums;
  }


  void _tapNumber(int player, int index) {
    if (over || player != curPlayer) return;
    int num = grids[player][index];
    if (!calledNumbers.contains(num)) {
      // This is the player's chosen number to call
      calledNumbers.add(num);
      lastCalled = num;
      // Mark for all
      for (int p = 0; p < widget.playerCount; p++) {
        for (int i = 0; i < 25; i++) {
          if (grids[p][i] == num) marked[p][i] = true;
        }
      }
      for (int p = 0; p < widget.playerCount; p++) {
        bingoCount[p] = _countLines(p);
        if (bingoCount[p] >= 5 && !over) { over = true; winner = p; }
      }
      setState(() { curPlayer = (curPlayer + 1) % widget.playerCount; });
      if (over) _winDlg();
    }
  }

  int _countLines(int player) {
    int lines = 0;
    // Rows
    for (int r = 0; r < 5; r++) {
      bool complete = true;
      for (int c = 0; c < 5; c++) { if (!marked[player][r * 5 + c]) { complete = false; break; } }
      if (complete) lines++;
    }
    // Cols
    for (int c = 0; c < 5; c++) {
      bool complete = true;
      for (int r = 0; r < 5; r++) { if (!marked[player][r * 5 + c]) { complete = false; break; } }
      if (complete) lines++;
    }
    // Diag 1
    bool d1 = true;
    for (int i = 0; i < 5; i++) { if (!marked[player][i * 5 + i]) { d1 = false; break; } }
    if (d1) lines++;
    // Diag 2
    bool d2 = true;
    for (int i = 0; i < 5; i++) { if (!marked[player][i * 5 + (4 - i)]) { d2 = false; break; } }
    if (d2) lines++;
    return lines;
  }

  void _winDlg() { showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
    backgroundColor: const Color(0xFF1A1F3A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('🎉', style: TextStyle(fontSize: 60)), const SizedBox(height: 12),
      Text('Player ${winner! + 1} BINGO!', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: pColors[winner!])),
      const SizedBox(height: 8),
      Text('5 lines completed!', style: GoogleFonts.poppins(color: Colors.white54)),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(context); _restart(); },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF416C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text('Play Again', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); },
          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text('Home', style: GoogleFonts.poppins())))
      ])
    ]))); }

  void _restart() { setState(() { grids = List.generate(widget.playerCount, (_) => _generateGrid()); marked = List.generate(widget.playerCount, (_) => List.filled(25, false)); bingoCount = List.filled(widget.playerCount, 0); calledNumbers = []; curPlayer = 0; over = false; winner = null; lastCalled = null; }); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bingo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0,
        actions: [IconButton(onPressed: _restart, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        // BINGO progress
        Container(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(widget.playerCount, (p) {
            final cur = p == curPlayer && !over;
            return AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: cur ? pColors[p].withValues(alpha: 0.2) : Colors.transparent,
                border: cur ? Border.all(color: pColors[p], width: 2) : null),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('P${p + 1}', style: GoogleFonts.poppins(fontSize: 12, color: cur ? Colors.white : Colors.white54, fontWeight: cur ? FontWeight.bold : FontWeight.normal)),
                Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1), padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: i < bingoCount[p] ? pColors[p] : Colors.white.withValues(alpha: 0.1)),
                  child: Text(bingoLetters[i], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: i < bingoCount[p] ? Colors.white : Colors.white38))))),
              ]));
          }))),
        // Called number
        if (lastCalled != null) Container(margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Last called: ', style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]), borderRadius: BorderRadius.circular(20)),
              child: Text('$lastCalled', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
          ])),
        // Player grids
        Expanded(child: PageView.builder(
          itemCount: widget.playerCount,
          controller: PageController(initialPage: curPlayer),
          itemBuilder: (ctx, p) => _buildPlayerGrid(p),
        )),
        // Controls
        Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Color(0xFF1A1F3A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            Text(over ? 'Game Over!' : 'Player ${curPlayer + 1}\'s turn - Tap a number!',
              style: GoogleFonts.poppins(color: over ? Colors.amber : pColors[curPlayer], fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Swipe to see other grids', style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
          ])),
      ]),
    );
  }

  Widget _buildPlayerGrid(int player) {
    final cur = player == curPlayer && !over;
    return Padding(padding: const EdgeInsets.all(12), child: Column(children: [
      Text('Player ${player + 1}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: pColors[player])),
      const SizedBox(height: 8),
      // BINGO header
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => Container(
        width: 56, height: 32, margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [pColors[player], pColors[player].withValues(alpha: 0.6)]), borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(bingoLetters[i], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))))),
      const SizedBox(height: 4),
      // 5x5 grid
      Expanded(child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 4, mainAxisSpacing: 4),
        itemCount: 25,
        itemBuilder: (ctx, i) {
          final num = grids[player][i];
          final isMarked = marked[player][i];
          final isCalled = calledNumbers.contains(num);
          return GestureDetector(
            onTap: cur && !isMarked && !isCalled ? () => _tapNumber(player, i) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: isMarked ? LinearGradient(colors: [pColors[player], pColors[player].withValues(alpha: 0.6)]) : null,
                color: isMarked ? null : const Color(0xFF252A4A),
                border: Border.all(color: isMarked ? Colors.transparent : Colors.white.withValues(alpha: 0.1)),
                boxShadow: isMarked ? [BoxShadow(color: pColors[player].withValues(alpha: 0.3), blurRadius: 8)] : null,
              ),
              child: Center(child: Text('$num',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold,
                  color: isMarked ? Colors.white : Colors.white70,
                  decoration: isMarked ? TextDecoration.lineThrough : null))),
            ),
          );
        },
      )),
    ]));
  }
}
