<<<<<<< HEAD
# 🎮 MultiGames - Online Multiplayer Gaming Platform

A Flutter-based multi-game application with real-time online multiplayer support. Play Snake & Ladder, Ludo, Business (Monopoly-style), and Bingo with friends online or offline!

## ✨ Features

### 🎯 Four Classic Games
- **Snake & Ladder** - Classic board game with snakes and ladders
- **Ludo** - Race your tokens to the finish
- **Business** - Monopoly-style property trading game
- **Bingo** - Number matching fun

### 🌐 Online Multiplayer
- Create private rooms with password protection
- Join public rooms
- Real-time gameplay with Socket.IO
- In-game chat system
- Support for 2-8 players per room
- Automatic host migration
- Room browsing and filtering

### 💬 Social Features
- Real-time chat in game lobbies
- Player presence indicators
- Host controls (start game, manage room)

### 🎨 Modern UI
- Beautiful gradient designs
- Smooth animations
- Dark theme
- Responsive layout

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Node.js (18.0.0 or higher)
- Dart SDK

### Flutter App Setup

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd multigames
```

2. **Install Flutter dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Backend Setup

1. **Navigate to backend folder**
```bash
cd backend
```

2. **Install dependencies**
```bash
npm install
```

3. **Create environment file**
```bash
cp .env.example .env
```

4. **Start the server**
```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

The server will run on `http://localhost:3000`

### Configure Flutter App for Local Backend

Open `lib/config/socket_config.dart` and set:
```dart
static const String serverUrl = 'http://localhost:3000';
```

## 📱 How to Play

### Offline Mode
1. Launch the app
2. Select a game
3. Choose "Offline"
4. Configure game settings
5. Start playing!

### Online Mode
1. Launch the app
2. Select a game
3. Choose "Online"
4. Either:
   - **Create Room**: Set room name, password (optional), max players
   - **Join Room**: Browse available rooms and join
5. Wait in lobby, chat with players
6. Host starts the game when ready
7. Play together in real-time!

## 🌍 Deploy to Production

### Deploy Backend to Render

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions.

Quick steps:
1. Push code to GitHub
2. Create account on [Render](https://render.com)
3. Create new Web Service
4. Connect your repository
5. Set root directory to `backend`
6. Deploy!

After deployment, update `lib/config/socket_config.dart` with your Render URL:
```dart
static const String serverUrl = 'https://your-app-name.onrender.com';
```

## 📚 Documentation

- [Deployment Guide](DEPLOYMENT.md) - How to deploy backend to Render
- [Multiplayer Guide](MULTIPLAYER_GUIDE.md) - Technical details and customization
- [Backend README](backend/README.md) - Backend API documentation

## 🏗️ Project Structure

```
multigames/
├── lib/
│   ├── config/
│   │   └── socket_config.dart          # Backend URL configuration
│   ├── games/
│   │   ├── bingo/                      # Bingo game
│   │   ├── business/                   # Business game
│   │   ├── ludo/                       # Ludo game
│   │   └── snake_ladder/               # Snake & Ladder game
│   ├── models/
│   │   └── room_model.dart             # Data models
│   ├── providers/
│   │   └── multiplayer_provider.dart   # State management
│   ├── screens/
│   │   ├── create_room_screen.dart     # Create room UI
│   │   ├── game_mode_selection_screen.dart
│   │   ├── join_room_screen.dart       # Join room UI
│   │   ├── multiplayer_lobby_screen.dart
│   │   └── room_screen.dart            # Room lobby with chat
│   ├── services/
│   │   └── socket_service.dart         # Socket.IO client
│   └── main.dart
├── backend/
│   ├── managers/
│   │   ├── GameManager.js              # Game logic
│   │   └── RoomManager.js              # Room management
│   ├── .env.example
│   ├── package.json
│   └── server.js                       # Main server
└── pubspec.yaml
```

## 🔧 Technologies Used

### Frontend
- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **Socket.IO Client** - Real-time communication
- **Google Fonts** - Typography

### Backend
- **Node.js** - Runtime environment
- **Express** - Web framework
- **Socket.IO** - Real-time bidirectional communication
- **CORS** - Cross-origin resource sharing

## 🎮 Game Types

Each game supports both offline and online multiplayer modes:

| Game | Players | Description |
|------|---------|-------------|
| Snake & Ladder | 2-4 | Classic board game with dice rolling |
| Ludo | 2-4 | Race your tokens around the board |
| Business | 2-8 | Buy properties and bankrupt opponents |
| Bingo | 2-8 | Mark numbers and complete patterns |

## 🔐 Security Notes

Current implementation includes:
- Password-protected rooms
- Basic input validation
- CORS configuration

For production, consider adding:
- User authentication (Firebase, JWT)
- Rate limiting
- Input sanitization
- Database for persistence
- SSL/TLS encryption

## 🤝 Contributing

Contributions are welcome! Here are some ideas:
- Add new games
- Improve game logic
- Enhance UI/UX
- Add features (voice chat, tournaments, etc.)
- Fix bugs
- Improve documentation

## 📝 License

This project is open source and available under the MIT License.

## 🐛 Troubleshooting

### Connection Issues
- Ensure backend is running
- Check URL in `socket_config.dart`
- Verify firewall settings
- Check Render logs if deployed

### Room Not Found
- Refresh room list
- Room may have closed
- Check internet connection

### Game Not Starting
- Minimum 2 players required
- Only host can start game
- Check all players are connected

For more help, see [MULTIPLAYER_GUIDE.md](MULTIPLAYER_GUIDE.md)

## 📧 Support

For issues and questions:
1. Check documentation
2. Review troubleshooting section
3. Open an issue on GitHub

## 🎉 Acknowledgments

Built with Flutter and Node.js for seamless cross-platform multiplayer gaming!

---

**Happy Gaming! 🎮**
=======
# multi_player_game
>>>>>>> cfdf42f3049b9b3da7efb7279b4490363d378f58
