class UserCardData {
  String uid;
  final String cardId;
  final String themeId;
  final String userId;
  final bool completed; // completed
  final DateTime dataCompleted; // completed

  UserCardData({
    required this.dataCompleted,
    required this.uid,
    required this.cardId,
    required this.completed,
    required this.userId,
    required this.themeId,
  });
}
