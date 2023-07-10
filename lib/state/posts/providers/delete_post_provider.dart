import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:indagram/state/image_upload/typedefs/is_loading.dart';
import 'package:indagram/state/posts/notifiers/delete_post_state_notifiers.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (ref) => DeletePostStateNotifier(),
);