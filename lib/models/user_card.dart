class UserCard {
  final String uid;
  final String cardId;
  final String themeId;
  final bool completed;
  final DateTime time_to_pass;
  final String userId;
  final int value;

  UserCard(
      {required this.uid,
      required this.cardId,
      required this.value,
      required this.userId,
      required this.themeId,
      required this.time_to_pass,
      required this.completed});
}
