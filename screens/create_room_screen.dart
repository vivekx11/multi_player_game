import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/multiplayer_provider.dart';

class CreateRoomScreen extends StatefulWidget {
  final String gameType;
  final String gameName;

  const CreateRoomScreen({
    Key? key,
    required this.gameType,
    required this.gameName,
  }) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hostNameController = TextEditingController();
  int _maxPlayers = 4;
  bool _hasPassword = false;

  @override
  void dispose() {
    _roomNameController.dispose();
    _passwordController.dispose();
    _hostNameController.dispose();
    super.dispose();
  }

  void _createRoom() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<MultiplayerProvider>(context, listen: false);
      
      provider.createRoom(
        roomName: _roomNameController.text.trim(),
        password: _hasPassword ? _passwordController.text.trim() : null,
        gameType: widget.gameType,
        maxPlayers: _maxPlayers,
        hostName: _hostNameController.text.trim(),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _hostNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                labelText: 'Room Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.meeting_room),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a room name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Password Protected'),
              value: _hasPassword,
              onChanged: (value) {
                setState(() {
                  _hasPassword = value;
                });
              },
            ),
            if (_hasPassword) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (_hasPassword && (value == null || value.trim().isEmpty)) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Max Players: $_maxPlayers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _maxPlayers.toDouble(),
              min: 2,
              max: 8,
              divisions: 6,
              label: _maxPlayers.toString(),
              onChanged: (value) {
                setState(() {
                  _maxPlayers = value.toInt();
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _createRoom,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Create Room'),
            ),
          ],
        ),
      ),
    );
  }
}
