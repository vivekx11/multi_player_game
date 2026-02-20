import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/multiplayer_provider.dart';
import 'multiplayer_lobby_screen.dart';

class GameModeSelectionScreen extends StatelessWidget {
  final String gameType;
  final String gameName;
  final Widget offlineGameScreen;

  const GameModeSelectionScreen({
    Key? key,
    required this.gameType,
    required this.gameName,
    required this.offlineGameScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$gameName - Select Mode'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gamepad,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 40),
              Text(
                'Choose Game Mode',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 40),
              _buildModeButton(
                context,
                icon: Icons.person,
                title: 'Offline',
                subtitle: 'Play locally on this device',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => offlineGameScreen,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildModeButton(
                context,
                icon: Icons.wifi,
                title: 'Online',
                subtitle: 'Play with friends online',
                onTap: () {
                  final provider = Provider.of<MultiplayerProvider>(
                    context,
                    listen: false,
                  );
                  provider.initialize();
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiplayerLobbyScreen(
                        gameType: gameType,
                        gameName: gameName,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
