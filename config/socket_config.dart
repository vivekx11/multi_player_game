class SocketConfig {
  // Replace with your Render backend URL after deployment
  static const String serverUrl = 'https://your-app-name.onrender.com';
  
  // For local testing, use:
  // static const String serverUrl = 'http://localhost:3000';
  
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration reconnectionDelay = Duration(seconds: 2);
  static const int maxReconnectionAttempts = 5;
}
