import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import '../models/room_model.dart';

class MultiplayerProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  
  Room? _currentRoom;
  List<RoomListItem> _availableRooms = [];
  List<ChatMessage> _chatMessages = [];
  String? _error;
  bool _isLoading = false;

  Room? get currentRoom => _currentRoom;
  List<RoomListItem> get availableRooms => _availableRooms;
  List<ChatMessage> get chatMessages => _chatMessages;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isConnected => _socketService.isConnected;

  void initialize() {
    _socketService.connect();
    _setupListeners();
  }

  void _setupListeners() {
    _socketService.on('room_created', (data) {
      _currentRoom = Room.fromJson(data);
      _isLoading = false;
      _error = null;
      notifyListeners();
    });

    _socketService.on('room_joined', (data) {
      _currentRoom = Room.fromJson(data);
      _isLoading = false;
      _error = null;
      notifyListeners();
    });

    _socketService.on('rooms_list', (data) {
      _availableRooms = (data as List)
          .map((room) => RoomListItem.fromJson(room))
          .toList();
      _isLoading = false;
      notifyListeners();
    });

    _socketService.on('player_joined', (data) {
      if (_currentRoom != null) {
        _currentRoom = Room.fromJson(data['room'] ?? _currentRoom!.toJson());
        notifyListeners();
      }
    });

    _socketService.on('player_left', (data) {
      if (_currentRoom != null) {
        final players = (data['players'] as List)
            .map((p) => Player.fromJson(p))
            .toList();
        _currentRoom = Room(
          id: _currentRoom!.id,
          name: _currentRoom!.name,
          password: _currentRoom!.password,
          gameType: _currentRoom!.gameType,
          maxPlayers: _currentRoom!.maxPlayers,
          hostId: _currentRoom!.hostId,
          status: _currentRoom!.status,
          players: players,
        );
        notifyListeners();
      }
    });

    _socketService.on('host_changed', (data) {
      if (_currentRoom != null) {
        final newHost = Player.fromJson(data);
        notifyListeners();
      }
    });

    _socketService.on('room_closed', (_) {
      _currentRoom = null;
      _chatMessages.clear();
      _error = 'Room has been closed';
      notifyListeners();
    });

    _socketService.on('game_started', (data) {
      // Navigate to game screen
      notifyListeners();
    });

    _socketService.on('game_update', (data) {
      // Update game state
      notifyListeners();
    });

    _socketService.on('chat_message', (data) {
      _chatMessages.add(ChatMessage.fromJson(data));
      notifyListeners();
    });

    _socketService.on('error', (data) {
      _error = data['message'];
      _isLoading = false;
      notifyListeners();
    });
  }

  void createRoom({
    required String roomName,
    String? password,
    required String gameType,
    required int maxPlayers,
    required String hostName,
  }) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _socketService.emit('create_room', {
      'roomName': roomName,
      'password': password,
      'gameType': gameType,
      'maxPlayers': maxPlayers,
      'hostName': hostName,
    });
  }

  void joinRoom({
    required String roomId,
    String? password,
    required String playerName,
  }) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _socketService.emit('join_room', {
      'roomId': roomId,
      'password': password,
      'playerName': playerName,
    });
  }

  void getRooms(String? gameType) {
    _isLoading = true;
    notifyListeners();
    _socketService.emit('get_rooms', gameType);
  }

  void leaveRoom() {
    if (_currentRoom != null) {
      _socketService.emit('leave_room', _currentRoom!.id);
      _currentRoom = null;
      _chatMessages.clear();
      notifyListeners();
    }
  }

  void startGame() {
    if (_currentRoom != null) {
      _socketService.emit('start_game', _currentRoom!.id);
    }
  }

  void sendChatMessage(String message) {
    if (_currentRoom != null && message.trim().isNotEmpty) {
      _socketService.emit('chat_message', {
        'roomId': _currentRoom!.id,
        'message': message.trim(),
      });
    }
  }

  void sendGameMove(Map<String, dynamic> move) {
    if (_currentRoom != null) {
      _socketService.emit('game_move', {
        'roomId': _currentRoom!.id,
        'move': move,
      });
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}
