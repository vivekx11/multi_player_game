# Testing Guide

## Local Testing Setup

### Option 1: Single Device Testing

Test with multiple emulators/simulators on one machine.

**Android:**
```bash
# Terminal 1 - Start backend
cd backend
npm run dev

# Terminal 2 - Run first instance
flutter run -d emulator-5554

# Terminal 3 - Run second instance (if you have multiple emulators)
flutter run -d emulator-5556
```

**iOS (Mac only):**
```bash
# Terminal 1 - Start backend
cd backend
npm run dev

# Terminal 2 - Run on iPhone simulator
flutter run -d "iPhone 14"

# Terminal 3 - Run on iPad simulator
flutter run -d "iPad Pro"
```

### Option 2: Multiple Physical Devices

Test on real devices over local network.

**Step 1: Find Your Computer's IP**

Windows:
```cmd
ipconfig
```
Look for "IPv4 Address" (e.g., 192.168.1.100)

Mac/Linux:
```bash
ifconfig
# or
ip addr show
```

**Step 2: Update Socket Config**

Edit `lib/config/socket_config.dart`:
```dart
static const String serverUrl = 'http://192.168.1.100:3000';
```

**Step 3: Allow Firewall**

Windows:
- Open Windows Defender Firewall
- Allow Node.js through firewall
- Or temporarily disable firewall for testing

Mac:
```bash
# Allow port 3000
sudo pfctl -d  # Disable firewall temporarily
```

**Step 4: Run on Devices**
```bash
# Device 1
flutter run -d device1-id

# Device 2
flutter run -d device2-id
```

## Test Scenarios

### 1. Basic Connection Test

**Goal:** Verify backend connection

**Steps:**
1. Start backend server
2. Run Flutter app
3. Select any game → Online
4. Check for "Connected to server" (no error)

**Expected:** App connects successfully

**Troubleshooting:**
- Backend running? Check terminal
- Correct URL? Check socket_config.dart
- Firewall blocking? Check settings

### 2. Room Creation Test

**Goal:** Create a room successfully

**Steps:**
1. Select game → Online
2. Click "Create Room"
3. Fill form:
   - Your Name: "Player1"
   - Room Name: "Test Room"
   - Max Players: 4
4. Click "Create Room"

**Expected:**
- Redirected to room lobby
- See yourself in player list
- Room ID displayed
- Host indicator (star) shown

### 3. Room Joining Test

**Goal:** Join an existing room

**Device 1:**
1. Create room "Test Room"
2. Note the Room ID

**Device 2:**
1. Select same game → Online
2. See "Test Room" in list
3. Click on room
4. Enter name: "Player2"
5. Click "Join Room"

**Expected:**
- Device 2 joins successfully
- Both devices see 2 players
- Both receive "player_joined" notification

### 4. Password Protection Test

**Goal:** Test password-protected rooms

**Device 1:**
1. Create room with password "1234"

**Device 2:**
1. Try joining with wrong password
   - **Expected:** Error message
2. Try joining with correct password "1234"
   - **Expected:** Join successfully

### 5. Chat Test

**Goal:** Test real-time chat

**Both Devices:**
1. Join same room
2. Device 1 sends: "Hello!"
3. Device 2 sends: "Hi there!"

**Expected:**
- Messages appear on both devices
- Correct player names shown
- Messages in correct order
- Auto-scroll to latest message

### 6. Host Migration Test

**Goal:** Test automatic host transfer

**Steps:**
1. Device 1 (host) creates room
2. Device 2 joins
3. Device 3 joins
4. Device 1 leaves room

**Expected:**
- Device 2 becomes new host
- Star icon moves to Device 2
- "Start Game" button appears on Device 2
- Room stays open

### 7. Room Closure Test

**Goal:** Test room cleanup

**Steps:**
1. Create room with 2 players
2. Both players leave

**Expected:**
- Room closes automatically
- Room disappears from list
- No memory leaks

### 8. Max Players Test

**Goal:** Test player limit

**Steps:**
1. Create room with max 2 players
2. Player 1 joins
3. Player 2 joins
4. Player 3 tries to join

**Expected:**
- Player 3 gets "Room is full" error
- Room shows 2/2 players

### 9. Game Start Test

**Goal:** Test game initialization

**Steps:**
1. Create room with 2 players
2. Both join
3. Non-host tries to start game
   - **Expected:** Button disabled or error
4. Host clicks "Start Game"
   - **Expected:** Game starts for all players

### 10. Disconnect/Reconnect Test

**Goal:** Test connection stability

**Steps:**
1. Join room
2. Turn off WiFi for 5 seconds
3. Turn WiFi back on

**Expected:**
- App shows disconnected state
- Auto-reconnects when WiFi returns
- Room state restored (if still exists)

## Automated Testing

### Backend Unit Tests

Create `backend/test/room.test.js`:
```javascript
const RoomManager = require('../managers/RoomManager');

describe('RoomManager', () => {
  let roomManager;

  beforeEach(() => {
    roomManager = new RoomManager();
  });

  test('should create room', () => {
    const room = roomManager.createRoom(
      'host-id',
      'Test Room',
      null,
      'ludo',
      4,
      'Host'
    );
    expect(room).toBeDefined();
    expect(room.name).toBe('Test Room');
  });

  test('should join room', () => {
    const room = roomManager.createRoom(
      'host-id',
      'Test Room',
      null,
      'ludo',
      4,
      'Host'
    );
    const result = roomManager.joinRoom(
      'player-id',
      room.id,
      null,
      'Player'
    );
    expect(result.success).toBe(true);
    expect(room.players.length).toBe(2);
  });
});
```

Run tests:
```bash
cd backend
npm install --save-dev jest
npm test
```

### Flutter Widget Tests

Create `test/multiplayer_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:multigames/providers/multiplayer_provider.dart';

void main() {
  group('MultiplayerProvider', () {
    test('should initialize', () {
      final provider = MultiplayerProvider();
      expect(provider.currentRoom, isNull);
      expect(provider.availableRooms, isEmpty);
    });
  });
}
```

Run tests:
```bash
flutter test
```

## Load Testing

### Using Artillery

Install Artillery:
```bash
npm install -g artillery
```

Create `backend/load-test.yml`:
```yaml
config:
  target: "http://localhost:3000"
  phases:
    - duration: 60
      arrivalRate: 10
  engines:
    socketio:
      transports: ["websocket"]

scenarios:
  - engine: socketio
    flow:
      - emit:
          channel: "create_room"
          data:
            roomName: "Load Test"
            gameType: "ludo"
            maxPlayers: 4
            hostName: "Tester"
      - think: 5
      - emit:
          channel: "chat_message"
          data:
            roomId: "{{ roomId }}"
            message: "Test message"
```

Run load test:
```bash
artillery run load-test.yml
```

## Performance Benchmarks

### Expected Performance

| Metric | Target | Acceptable |
|--------|--------|------------|
| Connection Time | < 500ms | < 1s |
| Room Creation | < 100ms | < 300ms |
| Join Room | < 200ms | < 500ms |
| Chat Message | < 50ms | < 200ms |
| Game Move | < 100ms | < 300ms |

### Measuring Latency

Add to Flutter app:
```dart
final stopwatch = Stopwatch()..start();
provider.createRoom(...);

provider.on('room_created', (_) {
  print('Room created in ${stopwatch.elapsedMilliseconds}ms');
});
```

## Common Issues & Solutions

### Issue: "Connection timeout"
**Cause:** Backend not running or wrong URL
**Solution:** 
- Check backend is running: `curl http://localhost:3000`
- Verify URL in socket_config.dart

### Issue: "Room not found"
**Cause:** Room closed or wrong room ID
**Solution:**
- Refresh room list
- Check room still exists
- Verify room ID is correct

### Issue: Chat messages delayed
**Cause:** Network latency or server overload
**Solution:**
- Check network speed
- Monitor server CPU/memory
- Reduce message frequency

### Issue: Players not seeing each other
**Cause:** Not in same room or connection issues
**Solution:**
- Verify both joined same room ID
- Check both are connected
- Look for errors in console

### Issue: Game won't start
**Cause:** Not enough players or not host
**Solution:**
- Minimum 2 players required
- Only host can start
- Check all players connected

## Test Checklist

Before deploying to production:

- [ ] Backend starts without errors
- [ ] Flutter app connects successfully
- [ ] Can create room
- [ ] Can join room
- [ ] Password protection works
- [ ] Chat works in real-time
- [ ] Multiple players can join
- [ ] Host can start game
- [ ] Host migration works
- [ ] Room closes properly
- [ ] Handles disconnects gracefully
- [ ] Max players enforced
- [ ] Error messages clear
- [ ] UI responsive
- [ ] No memory leaks
- [ ] Works on different networks
- [ ] Works on mobile data
- [ ] Performance acceptable
- [ ] Logs are clean

## Continuous Testing

### During Development
1. Test after each feature
2. Test on multiple devices
3. Test edge cases
4. Monitor logs
5. Fix issues immediately

### Before Release
1. Full test suite
2. Load testing
3. Security audit
4. Performance profiling
5. User acceptance testing

---

**Happy Testing! 🧪**
