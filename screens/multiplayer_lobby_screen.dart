import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/multiplayer_provider.dart';
import 'create_room_screen.dart';
import 'join_room_screen.dart';
import 'room_screen.dart';

class MultiplayerLobbyScreen extends StatefulWidget {
  final String gameType;
  final String gameName;

  const MultiplayerLobbyScreen({
    Key? key,
    required this.gameType,
    required this.gameName,
  }) : super(key: key);

  @override
  State<MultiplayerLobbyScreen> createState() => _MultiplayerLobbyScreenState();
}

class _MultiplayerLobbyScreenState extends State<MultiplayerLobbyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MultiplayerProvider>(context, listen: false);
      provider.getRooms(widget.gameType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameName} - Online'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<MultiplayerProvider>(context, listen: false)
                  .getRooms(widget.gameType);
            },
          ),
        ],
      ),
      body: Consumer<MultiplayerProvider>(
        builder: (context, provider, child) {
          if (!provider.isConnected) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to server...'),
                ],
              ),
            );
          }

          if (provider.currentRoom != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomScreen(
                    gameName: widget.gameName,
                  ),
                ),
              );
            });
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateRoomScreen(
                                gameType: widget.gameType,
                                gameName: widget.gameName,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create Room'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Available Rooms',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.availableRooms.isEmpty
                        ? const Center(
                            child: Text('No rooms available.\nCreate one to start!'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.availableRooms.length,
                            itemBuilder: (context, index) {
                              final room = provider.availableRooms[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${room.currentPlayers}'),
                                  ),
                                  title: Text(room.name),
                                  subtitle: Text(
                                    'Host: ${room.hostName} • ${room.currentPlayers}/${room.maxPlayers} players',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (room.hasPassword)
                                        const Icon(Icons.lock, size: 20),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_ios),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JoinRoomScreen(
                                          room: room,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
