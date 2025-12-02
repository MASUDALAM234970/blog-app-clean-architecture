import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
}
