class Room {
  final String id;
  final String name;
  final String? password;
  final String gameType;
  final int maxPlayers;
  final String hostId;
  final String status;
  final List<Player> players;

  Room({
    required this.id,
    required this.name,
    this.password,
    required this.gameType,
    required this.maxPlayers,
    required this.hostId,
    required this.status,
    required this.players,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      gameType: json['gameType'],
      maxPlayers: json['maxPlayers'],
      hostId: json['hostId'],
      status: json['status'],
      players: (json['players'] as List)
          .map((p) => Player.fromJson(p))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'gameType': gameType,
      'maxPlayers': maxPlayers,
      'hostId': hostId,
      'status': status,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }
}

class Player {
  final String id;
  final String name;
  final bool isHost;
  final bool isReady;

  Player({
    required this.id,
    required this.name,
    required this.isHost,
    required this.isReady,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      isHost: json['isHost'],
      isReady: json['isReady'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isHost': isHost,
      'isReady': isReady,
    };
  }
}

class RoomListItem {
  final String id;
  final String name;
  final String gameType;
  final bool hasPassword;
  final int currentPlayers;
  final int maxPlayers;
  final String hostName;

  RoomListItem({
    required this.id,
    required this.name,
    required this.gameType,
    required this.hasPassword,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.hostName,
  });

  factory RoomListItem.fromJson(Map<String, dynamic> json) {
    return RoomListItem(
      id: json['id'],
      name: json['name'],
      gameType: json['gameType'],
      hasPassword: json['hasPassword'],
      currentPlayers: json['currentPlayers'],
      maxPlayers: json['maxPlayers'],
      hostName: json['hostName'],
    );
  }
}

class ChatMessage {
  final String playerId;
  final String playerName;
  final String message;
  final int timestamp;

  ChatMessage({
    required this.playerId,
    required this.playerName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      playerId: json['playerId'],
      playerName: json['playerName'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}
