import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'games/snake_ladder/snake_ladder_game.dart';
import 'games/ludo/ludo_game.dart';
import 'games/business/business_game.dart';
import 'games/bingo/bingo_game.dart';
import 'providers/multiplayer_provider.dart';
import 'screens/game_mode_selection_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MultiplayerProvider()),
      ],
      child: const MultiGamesApp(),
    ),
  );
}

class MultiGamesApp extends StatelessWidget {
  const MultiGamesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiGames',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF00D2FF),
          surface: const Color(0xFF1A1F3A),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late Animation<double> _titleAnimation;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;

  final List<GameItem> games = [
    GameItem(
      title: 'Snake & Ladder',
      subtitle: 'Classic board game',
      icon: Icons.pest_control,
      gradient: [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      screen: GameModeSelectionScreen(
        gameType: 'snake_ladder',
        gameName: 'Snake & Ladder',
        offlineGameScreen: const SnakeLadderSetup(),
      ),
    ),
    GameItem(
      title: 'Ludo',
      subtitle: 'Race to the finish',
      icon: Icons.casino,
      gradient: [const Color(0xFFF7971E), const Color(0xFFFFD200)],
      screen: GameModeSelectionScreen(
        gameType: 'ludo',
        gameName: 'Ludo',
        offlineGameScreen: const LudoSetup(),
      ),
    ),
    GameItem(
      title: 'Business',
      subtitle: 'Monopoly-style trading',
      icon: Icons.business_center,
      gradient: [const Color(0xFF6C63FF), const Color(0xFFE100FF)],
      screen: GameModeSelectionScreen(
        gameType: 'business',
        gameName: 'Business',
        offlineGameScreen: const BusinessSetup(),
      ),
    ),
    GameItem(
      title: 'Bingo',
      subtitle: 'Number matching fun',
      icon: Icons.grid_on,
      gradient: [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
      screen: GameModeSelectionScreen(
        gameType: 'bingo',
        gameName: 'Bingo',
        offlineGameScreen: const BingoSetup(),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    );

    _cardControllers = List.generate(4, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });
    _cardAnimations = _cardControllers.map((c) {
      return CurvedAnimation(parent: c, curve: Curves.easeOutBack);
    }).toList();

    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      for (int i = 0; i < _cardControllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 150), () {
          if (mounted) _cardControllers[i].forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _titleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(_titleAnimation),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🎮 MultiGames',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF00D2FF)],
                            ).createShader(
                              const Rect.fromLTWH(0, 0, 300, 70),
                            ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose a game to play',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    return ScaleTransition(
                      scale: _cardAnimations[index],
                      child: _GameCard(
                        game: games[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => games[index].screen,
                              transitionsBuilder: (_, anim, __, child) {
                                return FadeTransition(
                                  opacity: anim,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.1, 0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(
                                      parent: anim,
                                      curve: Curves.easeOut,
                                    )),
                                    child: child,
                                  ),
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 400),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final GameItem game;
  final VoidCallback onTap;

  const _GameCard({required this.game, required this.onTap});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovering = true),
      onTapUp: (_) {
        setState(() => _hovering = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: widget.game.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.game.gradient[0].withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    widget.game.icon,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Text(
                  widget.game.title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.game.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Play Now',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final Widget screen;

  GameItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.screen,
  });
}
