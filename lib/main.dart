import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ledge/core/services/injection_container.dart';
import 'package:ledge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ledge/features/auth/presentation/views/homescreen.dart';
import 'package:logger/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  Logger logger = Logger();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    logger.e("Failed to load .env file: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /// generally we would inject bloc like this but since we've registered the dependency we wil use sl
      // create: (context) => AuthCubit(createUser: createUser, getUsers: getUsers),
      create: (context) => sl<AuthCubit>(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const Homescreen(),
      ),
    );
  }
}

