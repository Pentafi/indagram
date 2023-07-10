import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifierProvider;
import 'package:indagram/state/auth/models/auth_state.dart';
import 'package:indagram/state/auth/notifiers/auth_state_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);