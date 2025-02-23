
import '../../../../core/models/user.dart';
import '../../../../services/firebase_firestore_user_service.dart';


class SearchRepository {
  final FireStoreUserService _fireStoreService;

  SearchRepository({
    required FireStoreUserService fireStoreService,
  }) : _fireStoreService = fireStoreService;

  // Global cache for all fetched users
  var users = <UserModel>[];

  // Map to track if a query (by nickname prefix) is fully fetched.
  // When set to true, it means no additional matching users exist in Firebase.
  final Map<String, bool> _fullyFetchedQueries = {};
  bool isQueryFullyFetched(String query) {
    // Check if any prefix of the current query is fully fetched.
    for (var key in _fullyFetchedQueries.keys) {
      // If a broader query (shorter string) is fully fetched and is a prefix of the current query,
      // assume the current query is fully fetched as well.
      if (query.startsWith(key) && _fullyFetchedQueries[key] == true) {
        return true;
      }
    }
    return false;
  }

  /// Searches for users by nickname and returns a List<UserModel>
  Future<List<UserModel>> searchUsersByNickname(String query) async {
    print("Cache size: ${users.length}");
    query = query.trim();
    try {
      // Filter local cache for users whose nickname starts with the query.
      var result =
      users.where((user) => user.nickname.startsWith(query)).take(3).toList();
      print("Local filtered result count: ${result.length}");

      // Use hierarchical check: if a broader query is fully fetched, treat this one as fully fetched.
      if (isQueryFullyFetched(query)) {
        return result;
      }

      // If the local result already meets our limit, return it.
      if (result.length >= 3) {
        return result;
      }

      // Only fetch from Firebase if we don't already have enough results.
      final int docsRequested = 3 - result.length;
      final snapshot = await _fireStoreService.searchUsersByNickname(
        nickname: query,
        limit: docsRequested,
      );

      // Mark query as fully fetched if fewer docs than requested were returned.
      if (snapshot.docs.isEmpty || snapshot.docs.length < docsRequested) {
        _fullyFetchedQueries[query] = true;
      }

      if (snapshot.docs.isNotEmpty) {
        var newUsers = snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data()))
            .toList();

        for (var newUser in newUsers) {
          // Add to global cache if not already present.
          if (!users.any((user) => user.id == newUser.id)) {
            users.add(newUser);
          }
          // Also add to the local result if not already there.
          if (result.length < 3 && !result.any((user) => user.id == newUser.id)) {
            result.add(newUser);
          }
        }
      }
      print("Updated cache size: ${users.length}");
      print("Final result count: ${result.length}");

      return result;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  /// Clear the cache and fully fetched queries.
  void clearCache() {
    users.clear();
    _fullyFetchedQueries.clear();
  }
}
