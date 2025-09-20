enum ChatType {
  global,
  clan,
  private,
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String avatarUrl;
  final String message;
  final DateTime timestamp;
  final ChatType type;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.avatarUrl,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'avatarUrl': avatarUrl,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      type: ChatType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChatType.global,
      ),
    );
  }
}
