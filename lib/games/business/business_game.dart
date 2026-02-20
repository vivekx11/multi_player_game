import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusinessSetup extends StatefulWidget {
  const BusinessSetup({super.key});
  @override
  State<BusinessSetup> createState() => _BusinessSetupState();
}

class _BusinessSetupState extends State<BusinessSetup> {
  int playerCount = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withValues(alpha: 0.2), blurRadius: 30)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.business_center, size: 60, color: Color(0xFFE100FF)),
          const SizedBox(height: 16),
          Text('Business', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text('Buy, sell & dominate!', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white54)),
          const SizedBox(height: 24),
          Text('Select Players', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white70)),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) {
            final c = i + 2; final s = playerCount == c;
            return Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: GestureDetector(
              onTap: () => setState(() => playerCount = c),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 60, height: 60,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
                  gradient: s ? const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFE100FF)]) : null,
                  color: s ? null : const Color(0xFF252A4A), border: Border.all(color: s ? Colors.transparent : Colors.white24)),
                child: Center(child: Text('$c', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: s ? Colors.white : Colors.white54))))));
          })),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 52, child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BusinessBoard(playerCount: playerCount))),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 8),
            child: Text('Start Game', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)))),
        ])))),
    );
  }
}

// Board tile types
enum TileType { start, property, tax, chance, jail, freeParking }

class BoardTile {
  final String name;
  final TileType type;
  final int price;
  final int rent;
  final Color color;
  int? owner;
  BoardTile({required this.name, required this.type, this.price = 0, this.rent = 0, this.color = Colors.white54, this.owner});
}

List<BoardTile> _createBoard() => [
  BoardTile(name: 'START', type: TileType.start, color: const Color(0xFF43E97B)),
  BoardTile(name: 'MG Road', type: TileType.property, price: 60, rent: 10, color: const Color(0xFF8B4513)),
  BoardTile(name: 'Chance', type: TileType.chance, color: const Color(0xFFFFD700)),
  BoardTile(name: 'Park St', type: TileType.property, price: 80, rent: 15, color: const Color(0xFF8B4513)),
  BoardTile(name: 'Tax', type: TileType.tax, color: const Color(0xFFFF4444)),
  BoardTile(name: 'Station 1', type: TileType.property, price: 200, rent: 50, color: const Color(0xFF444444)),
  BoardTile(name: 'Brigade', type: TileType.property, price: 100, rent: 20, color: const Color(0xFF00BFFF)),
  BoardTile(name: 'Chance', type: TileType.chance, color: const Color(0xFFFFD700)),
  BoardTile(name: 'Residency', type: TileType.property, price: 120, rent: 25, color: const Color(0xFF00BFFF)),
  BoardTile(name: 'Mall Rd', type: TileType.property, price: 140, rent: 30, color: const Color(0xFF00BFFF)),
  BoardTile(name: 'JAIL', type: TileType.jail, color: const Color(0xFFFF6347)),
  BoardTile(name: 'Bandra', type: TileType.property, price: 160, rent: 35, color: const Color(0xFFFF69B4)),
  BoardTile(name: 'Electric Co', type: TileType.property, price: 150, rent: 40, color: const Color(0xFFFFFF00)),
  BoardTile(name: 'Juhu', type: TileType.property, price: 180, rent: 40, color: const Color(0xFFFF69B4)),
  BoardTile(name: 'Marine Dr', type: TileType.property, price: 200, rent: 45, color: const Color(0xFFFF69B4)),
  BoardTile(name: 'Station 2', type: TileType.property, price: 200, rent: 50, color: const Color(0xFF444444)),
  BoardTile(name: 'Connaught', type: TileType.property, price: 220, rent: 50, color: const Color(0xFFFF8C00)),
  BoardTile(name: 'Chance', type: TileType.chance, color: const Color(0xFFFFD700)),
  BoardTile(name: 'Chandni C', type: TileType.property, price: 240, rent: 55, color: const Color(0xFFFF8C00)),
  BoardTile(name: 'Karol Bagh', type: TileType.property, price: 260, rent: 60, color: const Color(0xFFFF8C00)),
  BoardTile(name: 'Free Park', type: TileType.freeParking, color: const Color(0xFF32CD32)),
  BoardTile(name: 'Indiranagar', type: TileType.property, price: 280, rent: 65, color: const Color(0xFFE53935)),
  BoardTile(name: 'Chance', type: TileType.chance, color: const Color(0xFFFFD700)),
  BoardTile(name: 'Koramangala', type: TileType.property, price: 300, rent: 70, color: const Color(0xFFE53935)),
  BoardTile(name: 'Whitefield', type: TileType.property, price: 320, rent: 80, color: const Color(0xFFE53935)),
  BoardTile(name: 'Station 3', type: TileType.property, price: 200, rent: 50, color: const Color(0xFF444444)),
  BoardTile(name: 'Powai', type: TileType.property, price: 350, rent: 90, color: const Color(0xFF1E88E5)),
  BoardTile(name: 'Tax', type: TileType.tax, color: const Color(0xFFFF4444)),
  BoardTile(name: 'Andheri', type: TileType.property, price: 380, rent: 100, color: const Color(0xFF1E88E5)),
  BoardTile(name: 'Nariman Pt', type: TileType.property, price: 400, rent: 120, color: const Color(0xFF6C63FF)),
];

const _chanceCards = [
  'Bank pays you ₹200!', 'Pay hospital ₹100', 'You won lottery ₹150!',
  'Repair costs ₹75', 'Birthday! Collect ₹50', 'Go to Jail!',
  'Advance to START', 'Pay school fees ₹50', 'You found ₹100!', 'Tax refund ₹80',
];

const List<Color> pColors = [Color(0xFF4CAF50), Color(0xFF2196F3), Color(0xFFF44336), Color(0xFFFF9800)];

class BusinessBoard extends StatefulWidget {
  final int playerCount;
  const BusinessBoard({super.key, required this.playerCount});
  @override
  State<BusinessBoard> createState() => _BusinessBoardState();
}

class _BusinessBoardState extends State<BusinessBoard> {
  late List<BoardTile> board;
  late List<int> positions, money, jailTurns;
  late List<bool> bankrupt;
  int curPlayer = 0, diceVal = 1;
  bool rolling = false, over = false;
  int? winner;
  String message = '';
  final rng = Random();

  @override
  void initState() {
    super.initState();
    board = _createBoard();
    positions = List.filled(widget.playerCount, 0);
    money = List.filled(widget.playerCount, 1500);
    jailTurns = List.filled(widget.playerCount, 0);
    bankrupt = List.filled(widget.playerCount, false);
  }

  int _nextActive() {
    int n = (curPlayer + 1) % widget.playerCount;
    while (bankrupt[n]) n = (n + 1) % widget.playerCount;
    return n;
  }

  void _roll() async {
    if (rolling || over) return;
    if (jailTurns[curPlayer] > 0) {
      setState(() { jailTurns[curPlayer]--; message = 'P${curPlayer + 1} in Jail (${ jailTurns[curPlayer]} turns left)'; curPlayer = _nextActive(); });
      return;
    }
    setState(() => rolling = true);
    for (int i = 0; i < 10; i++) { await Future.delayed(const Duration(milliseconds: 50)); if (!mounted) return; setState(() => diceVal = rng.nextInt(6) + 1); }
    int newPos = (positions[curPlayer] + diceVal) % 30;
    if (newPos < positions[curPlayer]) money[curPlayer] += 200; // passed START
    positions[curPlayer] = newPos;
    _handleTile(newPos);
    setState(() => rolling = false);
    _checkGameOver();
  }

  void _handleTile(int pos) {
    final tile = board[pos];
    switch (tile.type) {
      case TileType.start: message = 'P${curPlayer + 1} on START! +₹200'; money[curPlayer] += 200; break;
      case TileType.property:
        if (tile.owner == null) { message = 'P${curPlayer + 1} landed on ${tile.name} (₹${tile.price})'; _showBuyDialog(pos); return; }
        else if (tile.owner != curPlayer) {
          money[curPlayer] -= tile.rent; money[tile.owner!] += tile.rent;
          message = 'P${curPlayer + 1} pays ₹${tile.rent} rent to P${tile.owner! + 1}';
          if (money[curPlayer] <= 0) _goBankrupt();
        } else { message = 'P${curPlayer + 1} on own property ${tile.name}'; }
        break;
      case TileType.tax: money[curPlayer] -= 150; message = 'P${curPlayer + 1} pays ₹150 tax!'; if (money[curPlayer] <= 0) _goBankrupt(); break;
      case TileType.chance: _drawChance(); break;
      case TileType.jail: jailTurns[curPlayer] = 2; message = 'P${curPlayer + 1} goes to Jail for 2 turns!'; break;
      case TileType.freeParking: message = 'P${curPlayer + 1} at Free Parking. Relax!'; break;
    }
    setState(() => curPlayer = _nextActive());
  }

  void _drawChance() {
    final card = _chanceCards[rng.nextInt(_chanceCards.length)];
    message = 'Chance: $card';
    if (card.contains('200')) money[curPlayer] += 200;
    else if (card.contains('150') && card.contains('won')) money[curPlayer] += 150;
    else if (card.contains('100') && card.contains('found')) money[curPlayer] += 100;
    else if (card.contains('50') && card.contains('Collect')) money[curPlayer] += 50;
    else if (card.contains('80')) money[curPlayer] += 80;
    else if (card.contains('hospital')) money[curPlayer] -= 100;
    else if (card.contains('75')) money[curPlayer] -= 75;
    else if (card.contains('school')) money[curPlayer] -= 50;
    else if (card.contains('Jail')) { jailTurns[curPlayer] = 2; }
    else if (card.contains('START')) { positions[curPlayer] = 0; money[curPlayer] += 200; }
    if (money[curPlayer] <= 0) _goBankrupt();
    setState(() => curPlayer = _nextActive());
  }

  void _goBankrupt() {
    bankrupt[curPlayer] = true;
    // Release properties
    for (var t in board) { if (t.owner == curPlayer) t.owner = null; }
    message += ' P${curPlayer + 1} is BANKRUPT!';
  }

  void _checkGameOver() {
    int alive = 0; int lastAlive = 0;
    for (int i = 0; i < widget.playerCount; i++) { if (!bankrupt[i]) { alive++; lastAlive = i; } }
    if (alive == 1) { setState(() { over = true; winner = lastAlive; }); _winDlg(); }
  }

  void _showBuyDialog(int pos) {
    final tile = board[pos];
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF1A1F3A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(tile.name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: tile.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Text('Price: ₹${tile.price}', style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
            Text('Rent: ₹${tile.rent}', style: GoogleFonts.poppins(color: Colors.white70)),
          ])),
        const SizedBox(height: 8),
        Text('Your balance: ₹${money[curPlayer]}', style: GoogleFonts.poppins(color: Colors.white54)),
      ]),
      actions: [
        TextButton(onPressed: () { Navigator.pop(context); setState(() => curPlayer = _nextActive()); },
          child: Text('Skip', style: GoogleFonts.poppins(color: Colors.white54))),
        if (money[curPlayer] >= tile.price)
          ElevatedButton(onPressed: () {
            setState(() { money[curPlayer] -= tile.price; tile.owner = curPlayer; message = 'P${curPlayer + 1} bought ${tile.name}!'; curPlayer = _nextActive(); });
            Navigator.pop(context);
          }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
            child: Text('Buy ₹${tile.price}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
      ],
    ));
  }

  void _winDlg() { showDialog(context: context, barrierDismissible: false, builder: (_) => AlertDialog(
    backgroundColor: const Color(0xFF1A1F3A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    content: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('🏆', style: TextStyle(fontSize: 60)), const SizedBox(height: 12),
      Text('Player ${winner! + 1} Wins!', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: pColors[winner!])),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: ElevatedButton(onPressed: () { Navigator.pop(context); _restart(); },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text('Play Again', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); },
          style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text('Home', style: GoogleFonts.poppins())))
      ])
    ]))); }

  void _restart() { setState(() { board = _createBoard(); positions = List.filled(widget.playerCount, 0); money = List.filled(widget.playerCount, 1500); jailTurns = List.filled(widget.playerCount, 0); bankrupt = List.filled(widget.playerCount, false); curPlayer = 0; diceVal = 1; rolling = false; over = false; winner = null; message = ''; }); }

  String _de(int v) => ['⚀','⚁','⚂','⚃','⚄','⚅'][v - 1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0,
        actions: [IconButton(onPressed: _restart, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        // Player money bar
        Container(margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFF1A1F3A), borderRadius: BorderRadius.circular(16)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(widget.playerCount, (i) {
            final cur = i == curPlayer && !over;
            return Opacity(opacity: bankrupt[i] ? 0.3 : 1.0, child: AnimatedContainer(duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cur ? pColors[i].withValues(alpha: 0.2) : Colors.transparent,
                border: cur ? Border.all(color: pColors[i], width: 2) : null),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                CircleAvatar(radius: 10, backgroundColor: pColors[i], child: Text('${i + 1}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold))),
                Text('₹${money[i]}', style: GoogleFonts.poppins(fontSize: 11, color: cur ? Colors.white : Colors.white54, fontWeight: cur ? FontWeight.bold : FontWeight.normal)),
                if (bankrupt[i]) Text('OUT', style: GoogleFonts.poppins(fontSize: 9, color: Colors.red)),
                if (jailTurns[i] > 0) Text('🔒${jailTurns[i]}', style: const TextStyle(fontSize: 9)),
              ])));
          }))),
        // Board
        Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: _buildBoard())),
        // Message
        if (message.isNotEmpty) Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFF252A4A), borderRadius: BorderRadius.circular(12)),
          child: Text(message, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
        // Dice
        Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Color(0xFF1A1F3A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 64, height: 64, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: pColors[curPlayer].withValues(alpha: 0.4), blurRadius: 12)]),
              child: Center(child: Text(_de(diceVal), style: const TextStyle(fontSize: 36)))),
            const SizedBox(width: 16),
            ElevatedButton.icon(onPressed: rolling || over || bankrupt[curPlayer] ? null : _roll, icon: const Icon(Icons.casino),
              label: Text(rolling ? 'Rolling...' : 'Roll', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: pColors[curPlayer], foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
          ])),
      ]),
    );
  }

  Widget _buildBoard() {
    return LayoutBuilder(builder: (ctx, cons) {
      // Show board as a scrollable list of tiles arranged in a path
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.75, crossAxisSpacing: 4, mainAxisSpacing: 4),
        itemCount: 30, padding: const EdgeInsets.all(4),
        itemBuilder: (ctx, i) {
          final tile = board[i];
          List<int> playersHere = [];
          for (int p = 0; p < widget.playerCount; p++) { if (positions[p] == i && !bankrupt[p]) playersHere.add(p); }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFF1E2348),
              border: Border.all(color: tile.color.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Stack(children: [
              // Color strip
              Positioned(top: 0, left: 0, right: 0, child: Container(height: 4, decoration: BoxDecoration(
                color: tile.color, borderRadius: const BorderRadius.vertical(top: Radius.circular(10))))),
              Padding(padding: const EdgeInsets.fromLTRB(4, 8, 4, 4), child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(_tileIcon(tile.type), style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 2),
                Text(tile.name, style: GoogleFonts.poppins(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                if (tile.type == TileType.property) Text('₹${tile.price}', style: GoogleFonts.poppins(fontSize: 7, color: Colors.white54)),
                if (tile.owner != null) Container(margin: const EdgeInsets.only(top: 2), width: 12, height: 12,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: pColors[tile.owner!], border: Border.all(color: Colors.white, width: 1))),
              ])),
              // Players
              if (playersHere.isNotEmpty) Positioned(bottom: 2, right: 2, child: Row(mainAxisSize: MainAxisSize.min,
                children: playersHere.map((p) => Container(width: 12, height: 12, margin: const EdgeInsets.only(left: 1),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: pColors[p], border: Border.all(color: Colors.white, width: 1),
                    boxShadow: [BoxShadow(color: pColors[p].withValues(alpha: 0.6), blurRadius: 3)]))).toList())),
            ]),
          );
        },
      );
    });
  }

  String _tileIcon(TileType t) {
    switch (t) {
      case TileType.start: return '🚀';
      case TileType.property: return '🏠';
      case TileType.tax: return '💰';
      case TileType.chance: return '🎲';
      case TileType.jail: return '🔒';
      case TileType.freeParking: return '🅿️';
    }
  }
}
