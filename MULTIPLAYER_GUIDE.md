# Multiplayer System Guide.......

## Overview

This multiplayer system allows players to create and join game rooms, chat with each other, and play games online in real-time.

## Features

### Room Management
- **Create Room**: Host creates a room with custom settings
  - Room name
  - Optional password protection
  - Max players (2-8)
  - Game type selection

- **Join Room**: Players can browse and join available rooms
  - View room list with player counts
  - Password-protected rooms
  - Real-time room updates

- **Room Lobby**: Pre-game waiting area
  - See all players in room
  - Host indicator (star icon)
  - In-room chat
  - Host can start game when ready

### Chat System
- Real-time messaging in room lobby
- Player names displayed with messages
- Auto-scroll to latest messages
- Works during game (can be extended)

### Game Flow

1. **Select Game** → Choose from 4 games
2. **Choose Mode** → Online or Offline
3. **Online Path**:
   - Create Room or Browse Rooms
   - Wait for players in lobby
   - Chat while waiting
   - Host starts game when ready
4. **Offline Path** → Direct to game setup

### Host Features
- Create room with custom settings
- Start game (requires minimum 2 players)
- If host leaves, next player becomes host
- Room closes if all players leave

### Player Features
- Browse available rooms
- Join rooms (with password if needed)
- Chat in lobby
- Leave room anytime
- Auto-reconnect on disconnect

## Technical Architecture

### Backend (Node.js + Socket.IO)

**Server Components:**
- `server.js` - Main server and Socket.IO setup
- `RoomManager.js` - Room creation, joining, leaving
- `GameManager.js` - Game state management

**Socket Events:**

Client → Server:
- `create_room` - Create new room
- `join_room` - Join existing room
- `get_rooms` - Get available rooms list
- `leave_room` - Leave current room
- `start_game` - Start game (host only)
- `game_move` - Send game move
- `chat_message` - Send chat message

Server → Client:
- `room_created` - Room created successfully
- `room_joined` - Joined room successfully
- `rooms_list` - List of available rooms
- `player_joined` - New player joined
- `player_left` - Player left room
- `host_changed` - New host assigned
- `room_closed` - Room closed
- `game_started` - Game started
- `game_update` - Game state update
- `chat_message` - New chat message
- `error` - Error message

### Frontend (Flutter)

**Key Components:**
- `SocketService` - Socket.IO client wrapper
- `MultiplayerProvider` - State management
- `Room Models` - Data structures
- `UI Screens` - User interface

**Screens:**
1. `GameModeSelectionScreen` - Online/Offline choice
2. `MultiplayerLobbyScreen` - Browse/create rooms
3. `CreateRoomScreen` - Room creation form
4. `JoinRoomScreen` - Join room with password
5. `RoomScreen` - Lobby with chat

## Extending the System

### Adding Game Logic

To add multiplayer logic to your games:

1. **Listen for game start:**
```dart
Provider.of<MultiplayerProvider>(context).on('game_started', (data) {
  // Initialize game with data
  final players = data['players'];
  final gameType = data['gameType'];
});
```

2. **Send moves:**
```dart
provider.sendGameMove({
  'action': 'roll_dice',
  'value': diceValue,
});
```

3. **Receive updates:**
```dart
provider.on('game_update', (data) {
  // Update game state
  setState(() {
    gameState = data['gameState'];
  });
});
```

### Adding New Game Types

1. Update `GameManager.js` with game-specific logic:
```javascript
getInitialGameState(gameType, playerCount) {
  switch (gameType) {
    case 'your_game':
      return { /* initial state */ };
  }
}
```

2. Add move processing:
```javascript
processYourGameMove(game, move) {
  // Process move logic
  return { /* result */ };
}
```

3. Update Flutter to handle new game type

### Customization Ideas

**Room Features:**
- Add ready/not ready status
- Kick player (host only)
- Room settings (time limits, rules)
- Spectator mode

**Chat Enhancements:**
- Emojis
- Message reactions
- Private messages
- Chat history

**Game Features:**
- Pause/resume
- Save/load game state
- Replay system
- Statistics tracking

**Social Features:**
- Friend system
- Player profiles
- Leaderboards
- Achievements

## Security Considerations

**Current Implementation:**
- Basic password protection for rooms
- No user authentication
- No data persistence
- No rate limiting

**Recommended Improvements:**
1. Add user authentication (Firebase, JWT)
2. Implement rate limiting
3. Add input validation
4. Store game history in database
5. Add anti-cheat measures
6. Implement proper session management

## Performance Tips

**Backend:**
- Use Redis for room state (scalability)
- Implement room cleanup for inactive rooms
- Add connection pooling
- Monitor memory usage

**Frontend:**
- Debounce chat messages
- Limit chat history length
- Optimize re-renders with Provider
- Cache room list

## Testing

**Local Testing:**
1. Start backend: `cd backend && npm run dev`
2. Update `socket_config.dart` to `http://localhost:3000`
3. Run multiple Flutter instances to test multiplayer

**Production Testing:**
1. Deploy backend to Render
2. Update `socket_config.dart` with production URL
3. Test with real devices on different networks

## Common Issues

**Connection Failed:**
- Check backend is running
- Verify URL in `socket_config.dart`
- Check firewall/network settings
- Ensure WebSocket is enabled

**Room Not Found:**
- Room may have closed
- Check room ID is correct
- Refresh room list

**Chat Not Working:**
- Verify socket connection
- Check room ID is set
- Look for errors in console

**Game Not Starting:**
- Ensure minimum 2 players
- Only host can start game
- Check game_started event listener

## Future Enhancements

- [ ] Voice chat
- [ ] Video chat
- [ ] Screen sharing
- [ ] Tournament system
- [ ] Matchmaking
- [ ] AI opponents
- [ ] Cross-platform play
- [ ] Mobile notifications
- [ ] Game replays
- [ ] Custom game modes
