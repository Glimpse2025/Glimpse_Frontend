import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/posts/data/posts_repository.dart';

final PostsRepository _postsRepository = getIt<PostsRepository>();

Future<void> updatePostCaption(String newCaption, Post _post,
    [UserAndPostState? state]) async {
  try {
    final response = await _postsRepository.updatePostCaption(_post.postId, newCaption);
    if (state != null) {
      state.post = _post.copyWith(caption: newCaption);
    }
  } catch (e) {
    print('Error updating caption: $e');
  }
}