import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/socket_config.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;

  bool get isConnected => _isConnected;
  IO.Socket? get socket => _socket;

  void connect() {
    if (_socket != null && _isConnected) return;

    _socket = IO.io(
      SocketConfig.serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setReconnectionDelay(SocketConfig.reconnectionDelay.inMilliseconds)
          .setReconnectionAttempts(SocketConfig.maxReconnectionAttempts)
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Connected to server');
      _isConnected = true;
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from server');
      _isConnected = false;
    });

    _socket!.onConnectError((error) {
      print('Connection error: $error');
      _isConnected = false;
    });
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
  }

  void emit(String event, dynamic data) {
    if (_isConnected && _socket != null) {
      _socket!.emit(event, data);
    }
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }
}
