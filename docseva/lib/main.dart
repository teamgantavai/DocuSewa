import 'package:flutter/material.dart';
import 'package:docusewa/screens/auth/phone_auth_screen.dart';
import 'package:docusewa/screens/home_screen.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_theme.dart';
import 'package:docusewa/core/supabase_client.dart';

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Supabase — must run before runApp()
  await DocuSewaSupabase.initialize();

  runApp(const DocuSewaApp());
}

class DocuSewaApp extends StatelessWidget {
  const DocuSewaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'DocuSewa — Citizen Services Portal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: ValueListenableBuilder<DocuSewaUserSession?>(
            valueListenable: DocuSewaAuthService().currentUser,
            builder: (context, session, _) {
              if (session != null) {
                return const HomeScreen();
              }
              return const PhoneAuthScreen();
            },
          ),
        );
      },
    );
  }
}

/// Backwards compatibility alias
typedef JanSevaApp = DocuSewaApp;
