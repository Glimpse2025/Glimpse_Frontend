import 'package:get_it/get_it.dart';
import 'package:glimpse/features/posts/data/post_repository.dart';
import 'package:glimpse/features/posts/data/posts_service.dart';
import 'package:glimpse/features/posts/domain/post_upload.dart';
import 'package:glimpse/features/common/data/api_client.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Регистрация сервисов
  getIt.registerLazySingleton<PostsService>(() => PostsService(baseUrl: ApiClient.baseUrl));

  // Регистрация репозиториев
  getIt.registerLazySingleton<PostRepository>(
          () => PostRepository(postsService: getIt<PostsService>())
  );

  // Регистрация use cases
  getIt.registerLazySingleton<PostUpload>(
          () => PostUpload(postRepository: getIt<PostRepository>())
  );
}