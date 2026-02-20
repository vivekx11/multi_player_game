# 🚀 Quick Start Guide......

Get your multiplayer gaming platform running in 5 minutes!

## Step 1: Install Dependencies

### Backend
```bash
cd backend
npm install
```

Or on Windows, double-click `backend/setup.bat`

### Flutter App
```bash
flutter pub get
```

## Step 2: Start Backend Server

```bash
cd backend
npm run dev
```

You should see:
```
Server running on port 3000
```

## Step 3: Configure Flutter App

Open `lib/config/socket_config.dart` and verify:
```dart
static const String serverUrl = 'http://localhost:3000';
```

## Step 4: Run Flutter App

```bash
flutter run
```

Or press F5 in VS Code

## Step 5: Test Multiplayer

### On Same Device (Testing)
1. Run app in emulator/simulator
2. Select a game → Online
3. Create a room
4. Note the Room ID

### On Different Devices
1. Make sure both devices are on same network
2. Find your computer's IP address:
   - Windows: `ipconfig` (look for IPv4)
   - Mac/Linux: `ifconfig` or `ip addr`
3. Update `socket_config.dart`:
   ```dart
   static const String serverUrl = 'http://YOUR_IP:3000';
   ```
4. Run app on both devices
5. One creates room, other joins

## Testing Flow

1. **Device 1**: Select game → Online → Create Room
   - Enter your name
   - Set room name
   - Optional: Set password
   - Choose max players
   - Click "Create Room"

2. **Device 2**: Select same game → Online
   - See the room in list
   - Click on room
   - Enter your name
   - Enter password (if set)
   - Click "Join Room"

3. **Both Devices**: Now in room lobby
   - See each other in player list
   - Try the chat!
   - Host (Device 1) clicks "Start Game"

## Common Issues

### "Connection failed"
- ✅ Backend server is running?
- ✅ Correct URL in `socket_config.dart`?
- ✅ Firewall not blocking port 3000?

### "Room not found"
- ✅ Both devices using same backend URL?
- ✅ Room still exists? (closes when all leave)
- ✅ Refresh room list

### Can't connect from other device
- ✅ Both on same WiFi network?
- ✅ Using computer's IP, not localhost?
- ✅ Firewall allows incoming connections?

## Next Steps

### Deploy to Production
See [DEPLOYMENT.md](DEPLOYMENT.md) to deploy backend to Render (free hosting)

### Customize
See [MULTIPLAYER_GUIDE.md](MULTIPLAYER_GUIDE.md) for:
- Adding game logic
- Customizing rooms
- Enhancing chat
- Adding features

## Quick Commands Reference

### Backend
```bash
cd backend
npm install          # Install dependencies
npm run dev         # Start development server
npm start           # Start production server
```

### Flutter
```bash
flutter pub get     # Install dependencies
flutter run         # Run app
flutter build apk   # Build Android APK
flutter build ios   # Build iOS app
```

## Testing Checklist

- [ ] Backend starts without errors
- [ ] Flutter app connects to backend
- [ ] Can create a room
- [ ] Can see room in list
- [ ] Can join room
- [ ] Can see other players
- [ ] Chat works
- [ ] Host can start game
- [ ] Players leave properly

## Need Help?

1. Check [README.md](README.md) for full documentation
2. Review [MULTIPLAYER_GUIDE.md](MULTIPLAYER_GUIDE.md) for technical details
3. Check backend logs for errors
4. Check Flutter console for errors

---

**You're ready to play! 🎮**
