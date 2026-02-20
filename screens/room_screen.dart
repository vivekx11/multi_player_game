import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/multiplayer_provider.dart';

class RoomScreen extends StatefulWidget {
  final String gameName;

  const RoomScreen({
    Key? key,
    required this.gameName,
  }) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      Provider.of<MultiplayerProvider>(context, listen: false)
          .sendChatMessage(_chatController.text);
      _chatController.clear();
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = Provider.of<MultiplayerProvider>(context, listen: false);
        provider.leaveRoom();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.gameName),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Provider.of<MultiplayerProvider>(context, listen: false).leaveRoom();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Consumer<MultiplayerProvider>(
          builder: (context, provider, child) {
            final room = provider.currentRoom;
            
            if (room == null) {
              return const Center(child: Text('Room not found'));
            }

            final isHost = room.players.any((p) => 
              p.id == provider.currentRoom?.hostId && p.isHost
            );

            return Column(
              children: [
                // Room Info
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            room.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Room: ${room.id}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${room.players.length}/${room.maxPlayers} Players'),
                    ],
                  ),
                ),
                
                // Players List
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: room.players.length,
                    itemBuilder: (context, index) {
                      final player = room.players[index];
                      return Card(
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                child: Text(player.name[0].toUpperCase()),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                player.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (player.isHost)
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                // Chat Section
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Chat',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        child: provider.chatMessages.isEmpty
                            ? const Center(
                                child: Text('No messages yet. Say hi!'),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(8),
                                itemCount: provider.chatMessages.length,
                                itemBuilder: (context, index) {
                                  final msg = provider.chatMessages[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          child: Text(
                                            msg.playerName[0].toUpperCase(),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                msg.playerName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(msg.message),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _chatController,
                                decoration: const InputDecoration(
                                  hintText: 'Type a message...',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _sendMessage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Start Game Button (Host only)
                if (isHost)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: room.players.length >= 2
                          ? () => provider.startGame()
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        room.players.length >= 2
                            ? 'Start Game'
                            : 'Waiting for players...',
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
