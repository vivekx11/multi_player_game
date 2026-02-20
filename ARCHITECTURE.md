# System Architecture

## Overview

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│   Flutter App   │         │   Flutter App   │         │   Flutter App   │
│   (Player 1)    │         │   (Player 2)    │         │   (Player 3)    │
└────────┬────────┘         └────────┬────────┘         └────────┬────────┘
         │                           │                           │
         │        Socket.IO WebSocket Connection                 │
         │                           │                           │
         └───────────────────────────┼───────────────────────────┘
                                     │
                          ┌──────────▼──────────┐
                          │   Node.js Server    │
                          │   (Express + IO)    │
                          └──────────┬──────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
            ┌───────▼───────┐ ┌─────▼─────┐ ┌───────▼───────┐
            │ RoomManager   │ │GameManager│ │SocketManager  │
            │ - Create Room │ │- Game Logic│ │- Connections  │
            │ - Join Room   │ │- Moves     │ │- Events       │
            │ - Leave Room  │ │- State     │ │- Broadcasting │
            └───────────────┘ └───────────┘ └───────────────┘
```

## Data Flow

### Creating a Room

```
Player 1 (Flutter)                Server (Node.js)
      │                                │
      │──── create_room ──────────────>│
      │     {roomName, password,       │
      │      gameType, maxPlayers}     │
      │                                │
      │                           [RoomManager]
      │                           - Generate Room ID
      │                           - Create Room Object
      │                           - Add Player as Host
      │                                │
      │<──── room_created ─────────────│
      │     {room object}              │
      │                                │
```

### Joining a Room

```
Player 2 (Flutter)                Server (Node.js)
      │                                │
      │──── join_room ────────────────>│
      │     {roomId, password,         │
      │      playerName}               │
      │                                │
      │                           [RoomManager]
      │                           - Validate Room
      │                           - Check Password
      │                           - Add Player
      │                                │
      │<──── room_joined ──────────────│
      │     {room object}              │
      │                                │
      │                           [Broadcast]
      │<──── player_joined ────────────│ (to all in room)
      │     {player, players}          │
      │                                │
```

### Chat Message Flow

```
Player 1                          Server                          Player 2
   │                                │                                │
   │──── chat_message ─────────────>│                                │
   │     {roomId, message}          │                                │
   │                                │                                │
   │                           [Validate]                            │
   │                           - Check Room                          │
   │                           - Get Player Name                     │
   │                                │                                │
   │<──── chat_message ─────────────┼──── chat_message ─────────────>│
   │     {playerId, name, msg}      │     {playerId, name, msg}      │
   │                                │                                │
```

### Starting Game

```
Host (Player 1)                   Server                    Other Players
      │                              │                            │
      │──── start_game ─────────────>│                            │
      │     {roomId}                 │                            │
      │                              │                            │
      │                         [Validate]                        │
      │                         - Is Host?                        │
      │                         - Min Players?                    │
      │                         - Update Status                   │
      │                              │                            │
      │<──── game_started ───────────┼──── game_started ─────────>│
      │     {gameType, players}      │     {gameType, players}    │
      │                              │                            │
```

## Component Details

### Frontend (Flutter)

#### SocketService
- Manages WebSocket connection
- Handles connect/disconnect
- Emits events to server
- Listens for server events

#### MultiplayerProvider
- State management with Provider
- Maintains current room state
- Manages chat messages
- Handles errors
- Notifies UI of changes

#### UI Screens
1. **GameModeSelectionScreen**: Choose online/offline
2. **MultiplayerLobbyScreen**: Browse/create rooms
3. **CreateRoomScreen**: Room creation form
4. **JoinRoomScreen**: Join with password
5. **RoomScreen**: Lobby with chat

### Backend (Node.js)

#### Server.js
- Express HTTP server
- Socket.IO initialization
- Event handlers
- CORS configuration

#### RoomManager
- Room CRUD operations
- Player management
- Room validation
- Host migration

#### GameManager
- Game initialization
- Move processing
- State management
- Game-specific logic

## State Management

### Room State
```javascript
{
  id: "ABC123",              // Unique room ID
  name: "My Game Room",      // Display name
  password: "secret",        // Optional password
  gameType: "ludo",          // Game type
  maxPlayers: 4,             // Max players
  hostId: "socket-id",       // Host socket ID
  status: "waiting",         // waiting | playing
  players: [                 // Array of players
    {
      id: "socket-id",
      name: "Player 1",
      isHost: true,
      isReady: true
    }
  ],
  createdAt: 1234567890      // Timestamp
}
```

### Game State (Example: Ludo)
```javascript
{
  roomId: "ABC123",
  gameType: "ludo",
  players: [
    {
      id: "socket-id",
      name: "Player 1",
      position: 0,
      score: 0,
      order: 0
    }
  ],
  currentTurn: 0,            // Index of current player
  state: {                   // Game-specific state
    board: { /* ... */ },
    dice: 6
  },
  startedAt: 1234567890
}
```

## Security Considerations

### Current Implementation
- ✅ Password-protected rooms
- ✅ Host validation
- ✅ Room capacity limits
- ✅ CORS configuration

### Recommended Additions
- 🔒 User authentication
- 🔒 Rate limiting
- 🔒 Input sanitization
- 🔒 Session management
- 🔒 Encrypted passwords
- 🔒 Anti-cheat measures

## Scalability

### Current Limitations
- Single server instance
- In-memory state (no persistence)
- No load balancing
- Limited to vertical scaling

### Scaling Solutions

#### Horizontal Scaling
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Server 1│     │ Server 2│     │ Server 3│
└────┬────┘     └────┬────┘     └────┬────┘
     │               │               │
     └───────────────┼───────────────┘
                     │
              ┌──────▼──────┐
              │    Redis    │
              │  (Pub/Sub)  │
              └─────────────┘
```

#### Database Integration
```
┌─────────────┐
│   Server    │
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
┌──▼──┐ ┌──▼──────┐
│Redis│ │PostgreSQL│
│Cache│ │ Database │
└─────┘ └──────────┘
```

## Performance Optimization

### Backend
- Use Redis for room state
- Implement connection pooling
- Add caching layer
- Optimize event handlers
- Clean up inactive rooms

### Frontend
- Debounce chat input
- Limit chat history
- Optimize re-renders
- Cache room list
- Lazy load components

## Monitoring

### Metrics to Track
- Active connections
- Room count
- Messages per second
- Average latency
- Error rate
- Memory usage

### Tools
- Render Dashboard (built-in)
- Socket.IO Admin UI
- Custom logging
- Error tracking (Sentry)

## Deployment Architecture

### Development
```
┌──────────────┐
│   Localhost  │
│              │
│  Backend:    │
│  :3000       │
│              │
│  Flutter:    │
│  Emulator    │
└──────────────┘
```

### Production
```
┌─────────────────┐         ┌──────────────────┐
│  Flutter Apps   │         │  Render.com      │
│  (iOS/Android)  │────────>│                  │
│                 │ HTTPS   │  Node.js Server  │
│  Web Browsers   │ WSS     │  Port 443        │
└─────────────────┘         └──────────────────┘
```

## Event Flow Summary

| Event | Direction | Purpose |
|-------|-----------|---------|
| create_room | Client → Server | Create new room |
| room_created | Server → Client | Room created confirmation |
| join_room | Client → Server | Join existing room |
| room_joined | Server → Client | Join confirmation |
| get_rooms | Client → Server | Request room list |
| rooms_list | Server → Client | Available rooms |
| leave_room | Client → Server | Leave current room |
| player_joined | Server → All | New player notification |
| player_left | Server → All | Player left notification |
| start_game | Client → Server | Start game (host) |
| game_started | Server → All | Game started notification |
| game_move | Client → Server | Send game move |
| game_update | Server → All | Game state update |
| chat_message | Client ↔ Server | Chat messages |
| error | Server → Client | Error notification |

---

This architecture provides a solid foundation for real-time multiplayer gaming with room for growth and optimization.
