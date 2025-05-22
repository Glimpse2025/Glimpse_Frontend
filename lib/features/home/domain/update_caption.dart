import 'package:glimpse/features/common/data/models.dart';
import 'package:glimpse/features/common/di/service_locator.dart';
import 'package:glimpse/features/posts/data/post_repository.dart';

final PostRepository _postRepository = getIt<PostRepository>();

Future<void> updatePostCaption(String newCaption, Post _post,
    [UserAndPostState? state]) async {
  try {
    final response = await _postRepository.updatePostCaption(_post.postId, newCaption);
    if (state != null && response!) {
      state.post = _post.copyWith(caption: newCaption);
    }
  } catch (e) {
    print('Error updating caption: $e');
  }
}