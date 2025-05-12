import 'package:glimpse/features/common/data/api_service.dart';

class FriendsService extends ApiService {
  FriendsService({required super.baseUrl});

  Future<Map<String, dynamic>> addFriend(int userId, int friendId) async {
    return await post(
        'api/friends', {'user_id': userId, 'friend_id': friendId});
  }
}
