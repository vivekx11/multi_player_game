import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<Color> ludoColors = [Color(0xFFE53935), Color(0xFF43A047), Color(0xFFFFB300), Color(0xFF1E88E5)];
const List<String> colorNames = ['Red', 'Green', 'Yellow', 'Blue'];
const List<int> safePositions = [0, 8, 13, 21, 26, 34, 39, 47];

class LudoSetup extends StatefulWidget {
  const LudoSetup({super.key});
  @override
  State<LudoSetup> createState() => _LudoSetupState();
}

class _LudoSetupState extends State<LudoSetup> {
  int playerCount = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ludo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFFF7971E).withValues(alpha: 0.2), blurRadius: 30)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.casino, size: 60, color: Color(0xFFFFD200)),
          const SizedBox(height: 16),
          Text('Ludo', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Race your tokens home!', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54)),
          const SizedBox(height: 24),
          Text('Select Players', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) {
            final count = i + 2; final selected = playerCount == count;
            return Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: GestureDetector(
              onTap: () => setState(() => playerCount = count),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 60, height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                  gradient: selected ? const LinearGradient(colors: [Color(0xFFF7971E), Color(0xFFFFD200)]) : null,
                  color: selected ? null : const Color(0xFF252A4A),
                  border: Border.all(color: selected ? Colors.transparent : Colors.white24)),
                child: Center(child: Text('$count', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold,
                  color: selected ? Colors.black : Colors.white54))))));
          })),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: List.generate(playerCount, (i) => Chip(
            avatar: CircleAvatar(backgroundColor: ludoColors[i], radius: 10),
            label: Text('Player ${i + 1} (${colorNames[i]})'),
            backgroundColor: const Color(0xFF252A4A),
            labelStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)))),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LudoBoard(playerCount: playerCount))),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD200), foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 8),
            child: Text('Start Game', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)))),
        ])))),
    );
  }
}

class LudoBoard extends StatefulWidget {
  final int playerCount;
  const LudoBoard({super.key, required this.playerCount});
  @override
  State<LudoBoard> createState() => _LudoBoardState();
}

class _LudoBoardState extends State<LudoBoard> {
  late List<List<int>> tokenPos;
  int curPlayer = 0, diceVal = 1;
  bool rolling = false, over = false, selectToken = false;
  int? winner;
  List<int> selectable = [];
  final rng = Random();

  @override
  void initState() { super.initState(); tokenPos = List.generate(widget.playerCount, (_) => List.filled(4, -1)); }

  int _next() => (curPlayer + 1) % widget.playerCount;
  int _toGlobal(int p, int lp) => (lp + p * 13) % 52;

  String _de(int v) => ['⚀','⚁','⚂','⚃','⚄','⚅'][v - 1];

  void _roll() async {
    if (rolling || over || selectToken) return;
    setState(() => rolling = true);
    for (int i = 0; i < 10; i++) { await Future.delayed(const Duration(milliseconds: 50)); if (!mounted) return; setState(() => diceVal = rng.nextInt(6) + 1); }
    final r = diceVal;
    List<int> mov = [];
    for (int t = 0; t < 4; t++) {
      int p = tokenPos[curPlayer][t];
      if (p == -1 && r == 6) mov.add(t);
      else if (p >= 0 && p < 57 && p + r <= 57) mov.add(t);
    }
    if (mov.isEmpty) { setState(() { rolling = false; if (r != 6) curPlayer = _next(); }); return; }
    if (mov.length == 1) { _move(mov[0], r); } else { setState(() { rolling = false; selectToken = true; selectable = mov; }); }
  }

  void _move(int ti, int r) {
    int p = tokenPos[curPlayer][ti];
    int np = p == -1 ? 0 : p + r;
    if (np < 52 && !safePositions.contains(np)) {
      int bp = _toGlobal(curPlayer, np);
      for (int op = 0; op < widget.playerCount; op++) { if (op == curPlayer) continue;
        for (int ot = 0; ot < 4; ot++) { if (tokenPos[op][ot] >= 0 && tokenPos[op][ot] < 52 && _toGlobal(op, tokenPos[op][ot]) == bp) tokenPos[op][ot] = -1; }}
    }
    setState(() { tokenPos[curPlayer][ti] = np; selectToken = false; selectable = []; rolling = false; });
    if (tokenPos[curPlayer].every((x) => x == 57)) { setState(() { over = true; winner = curPlayer; }); _winDlg(); return; }
    if (r != 6) setState(() => curPlayer = _next());
  }

  void _winDlg() { showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
    backgroundColor: const Color(0xFF1A1F3A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('🏆', style: TextStyle(fontSize: 60)), const SizedBox(height: 12),
      Text('${colorNames[winner!]} Wins!', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: ludoColors[winner!])),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(context); _restart(); },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD200), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text('Play Again', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); },
          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text('Home', style: GoogleFonts.poppins())))
      ])
    ]))); }

  void _restart() { setState(() { tokenPos = List.generate(widget.playerCount, (_) => List.filled(4, -1)); curPlayer = 0; diceVal = 1; rolling = false; over = false; winner = null; selectToken = false; selectable = []; }); }

  static const List<Offset> _path = [
    Offset(0, 7), Offset(0, 6), Offset(1, 6), Offset(2, 6), Offset(3, 6), Offset(4, 6), Offset(5, 6),
    Offset(6, 5), Offset(6, 4), Offset(6, 3), Offset(6, 2), Offset(6, 1), Offset(6, 0),
    Offset(7, 0), Offset(8, 0), Offset(8, 1), Offset(8, 2), Offset(8, 3), Offset(8, 4), Offset(8, 5),
    Offset(9, 6), Offset(10, 6), Offset(11, 6), Offset(12, 6), Offset(13, 6), Offset(14, 6),
    Offset(14, 7), Offset(14, 8), Offset(13, 8), Offset(12, 8), Offset(11, 8), Offset(10, 8), Offset(9, 8),
    Offset(8, 9), Offset(8, 10), Offset(8, 11), Offset(8, 12), Offset(8, 13), Offset(8, 14),
    Offset(7, 14), Offset(6, 14), Offset(6, 13), Offset(6, 12), Offset(6, 11), Offset(6, 10), Offset(6, 9),
    Offset(5, 8), Offset(4, 8), Offset(3, 8), Offset(2, 8), Offset(1, 8), Offset(0, 8),
  ];

  Offset _gridPos(int pl, int lp) {
    if (lp == -1) { const bases = [Offset(1.5, 10.5), Offset(1.5, 1.5), Offset(10.5, 1.5), Offset(10.5, 10.5)]; return bases[pl]; }
    if (lp >= 52) { int h = (lp - 52).clamp(0, 4);
      switch (pl) { case 0: return Offset(1.0 + h, 7); case 1: return Offset(7, 1.0 + h); case 2: return Offset(13.0 - h, 7); case 3: return Offset(7, 13.0 - h); default: return Offset.zero; }
    }
    return _path[_toGlobal(pl, lp)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ludo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0,
        actions: [IconButton(onPressed: _restart, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        // Player info
        Container(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(widget.playerCount, (i) {
            final cur = i == curPlayer && !over; int fin = tokenPos[i].where((p) => p == 57).length;
            return AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: cur ? ludoColors[i].withValues(alpha: 0.2) : Colors.transparent,
                border: cur ? Border.all(color: ludoColors[i], width: 2) : null),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(colorNames[i], style: GoogleFonts.poppins(fontSize: 12, color: cur ? Colors.white : Colors.white54, fontWeight: cur ? FontWeight.bold : FontWeight.normal)),
                Row(mainAxisSize: MainAxisSize.min, children: List.generate(4, (t) => Container(width: 10, height: 10, margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: tokenPos[i][t] == 57 ? Colors.amber : tokenPos[i][t] >= 0 ? ludoColors[i] : ludoColors[i].withValues(alpha: 0.3))))),
                Text('$fin/4', style: GoogleFonts.poppins(fontSize: 10, color: Colors.white38)),
              ]));
          }))),
        // Board
        Expanded(child: Padding(padding: const EdgeInsets.all(8), child: AspectRatio(aspectRatio: 1, child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFF141830), border: Border.all(color: Colors.white10)),
          child: LayoutBuilder(builder: (ctx, cons) {
            double cs = cons.maxWidth / 15;
            return Stack(children: [
              // Home areas
              _homeArea(0, 0, 6, ludoColors[0], cs), _homeArea(9, 0, 6, ludoColors[1], cs),
              _homeArea(9, 9, 6, ludoColors[2], cs), _homeArea(0, 9, 6, ludoColors[3], cs),
              // Center
              Positioned(left: 6*cs, top: 6*cs, child: Container(width: 3*cs, height: 3*cs,
                decoration: BoxDecoration(gradient: LinearGradient(colors: ludoColors.map((c) => c.withValues(alpha: 0.4)).toList()), borderRadius: BorderRadius.circular(4)),
                child: const Center(child: Text('🏠', style: TextStyle(fontSize: 20))))),
              // Path cells
              for (int i = 0; i < 52; i++) Positioned(left: _path[i].dx * cs, top: _path[i].dy * cs,
                child: Container(width: cs, height: cs, decoration: BoxDecoration(color: safePositions.contains(i) ? Colors.white.withValues(alpha: 0.15) : const Color(0xFF1E2348),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5)))),
              // Home stretches
              for (int c = 1; c < 6; c++) _hsCell(c.toDouble(), 7, ludoColors[0], cs),
              for (int r = 1; r < 6; r++) _hsCell(7, r.toDouble(), ludoColors[1], cs),
              for (int c = 9; c < 14; c++) _hsCell(c.toDouble(), 7, ludoColors[2], cs),
              for (int r = 9; r < 14; r++) _hsCell(7, r.toDouble(), ludoColors[3], cs),
              // Tokens
              for (int p = 0; p < widget.playerCount; p++)
                for (int t = 0; t < 4; t++)
                  if (tokenPos[p][t] != 57)
                    AnimatedPositioned(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut,
                      left: _gridPos(p, tokenPos[p][t]).dx * cs + (t % 2) * cs * 0.35 + cs * 0.1,
                      top: _gridPos(p, tokenPos[p][t]).dy * cs + (t ~/ 2) * cs * 0.35 + cs * 0.1,
                      child: GestureDetector(
                        onTap: selectToken && selectable.contains(t) && curPlayer == p ? () => _move(t, diceVal) : null,
                        child: Container(width: cs * 0.55, height: cs * 0.55,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: ludoColors[p],
                            border: Border.all(color: selectToken && selectable.contains(t) && curPlayer == p ? Colors.white : Colors.white54,
                              width: selectToken && selectable.contains(t) && curPlayer == p ? 2.5 : 1),
                            boxShadow: [BoxShadow(color: ludoColors[p].withValues(alpha: 0.5), blurRadius: 4)]),
                          child: Center(child: Text('${t + 1}', style: TextStyle(fontSize: cs * 0.25, fontWeight: FontWeight.bold, color: Colors.white))))))
            ]);
          }))))),
        // Controls
        Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Color(0xFF1A1F3A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            if (selectToken) Padding(padding: const EdgeInsets.only(bottom: 12), child: Column(children: [
              Text('Select a token to move', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: selectable.map((t) => Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ElevatedButton(onPressed: () => _move(t, diceVal),
                  style: ElevatedButton.styleFrom(backgroundColor: ludoColors[curPlayer], foregroundColor: Colors.white, shape: const CircleBorder(), padding: const EdgeInsets.all(14)),
                  child: Text('${t + 1}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))))).toList())])),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(onTap: _roll, child: Container(width: 72, height: 72,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: ludoColors[curPlayer].withValues(alpha: 0.4), blurRadius: 16)]),
                child: Center(child: Text(_de(diceVal), style: const TextStyle(fontSize: 40))))),
              const SizedBox(width: 20),
              ElevatedButton.icon(onPressed: rolling || over || selectToken ? null : _roll, icon: const Icon(Icons.casino),
                label: Text(rolling ? 'Rolling...' : 'Roll Dice', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: ludoColors[curPlayer], foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))]),
            const SizedBox(height: 8),
            if (!over) Text('${colorNames[curPlayer]}\'s turn', style: GoogleFonts.poppins(color: ludoColors[curPlayer], fontWeight: FontWeight.w600)),
          ])),
      ]),
    );
  }

  Widget _homeArea(int x, int y, int s, Color c, double cs) => Positioned(left: x * cs, top: y * cs,
    child: Container(width: s * cs, height: s * cs, decoration: BoxDecoration(color: c.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.white10)),
      child: Center(child: Container(width: 3 * cs, height: 3 * cs, decoration: BoxDecoration(color: const Color(0xFF141830), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10))))));

  Widget _hsCell(double x, double y, Color c, double cs) => Positioned(left: x * cs, top: y * cs,
    child: Container(width: cs, height: cs, decoration: BoxDecoration(color: c.withValues(alpha: 0.6), border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5))));
}
