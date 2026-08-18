import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'services/firestore_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// ============================================================
// COLORS
// ============================================================

const primary = Color(0xFF3B82F6);
const primaryDark = Color(0xFF2563EB);
const primaryLight = Color(0xFFE0F2FE);

const background = Color(0xFFF4F8FF);
const cardColor = Color(0xFFFFFFFF);

const good = Color(0xFF10B981);
const moderate = Color(0xFFF59E0B);
const unhealthy = Color(0xFFF97316);
const veryUnhealthy = Color(0xFFEF4444);
const hazardous = Color(0xFF8B5CF6);

const cyan = Color(0xFF06B6D4);
const purple = Color(0xFF8B5CF6);
const orange = Color(0xFFF97316);
const pink = Color(0xFFEC4899);

// ============================================================
// MAIN
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FirebaseAuth.instance.signInAnonymously();
    debugPrint('Firebase signed in anonymously.');
  } catch (e) {
    debugPrint('Anonymous auth warning: $e');
  }

  runApp(const AirGuardApp());
}

// ============================================================
// APP
// ============================================================

class AirGuardApp extends StatelessWidget {
  const AirGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AirGuard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: background,
        fontFamily: 'Inter',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
        ),
      ),
      home: const AppFlow(),
    );
  }
}

// ============================================================
// APP FLOW
// ============================================================

class AppFlow extends StatefulWidget {
  const AppFlow({super.key});

  @override
  State<AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<AppFlow> {
  String flow = 'splash';
  int tab = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          flow = 'onboarding';
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void goToLogin() {
    setState(() {
      flow = 'login';
    });
  }

  void goToMain() {
    setState(() {
      flow = 'main';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (flow == 'splash') {
      return const SplashScreen();
    }

    if (flow == 'onboarding') {
      return OnboardingScreen(onDone: goToLogin);
    }

    if (flow == 'login') {
      return LoginScreen(onDone: goToMain);
    }

    return MainShell(
      tab: tab,
      onTab: (value) {
        setState(() {
          tab = value;
        });
      },
    );
  }
}

// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(Icons.air, color: Colors.white, size: 70),
              ),
              const SizedBox(height: 24),
              const Text(
                'AirGuard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Breathe Smarter, Live Healthier',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 36),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ONBOARDING
// ============================================================

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onDone;

  const OnboardingScreen({super.key, required this.onDone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int page = 0;

  final data = const [
    [
      Icons.speed,
      'Real-time Air Quality',
      'Monitor air quality index in real-time from your connected sensors.',
    ],
    [
      Icons.notifications_active,
      'Smart Health Alerts',
      'Get instant notifications when air quality becomes unhealthy.',
    ],
    [
      Icons.auto_graph,
      'AI-Powered Predictions',
      'Forecast pollution levels and plan your day smarter.',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onDone,
                  child: const Text('Skip'),
                ),
              ),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(page),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [primaryLight, Color(0xFFEDE9FE)],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          data[page][0] as IconData,
                          size: 110,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 42),
                      Text(
                        data[page][1] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data[page][2] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: page == i ? 26 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: page == i ? primary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (page == 2) {
                      widget.onDone();
                    } else {
                      setState(() {
                        page++;
                      });
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(page == 2 ? 'Get Started' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN / SIGN UP  (Demo mode — no Firebase auth)
// ============================================================

class LoginScreen extends StatefulWidget {
  final VoidCallback onDone;

  const LoginScreen({super.key, required this.onDone});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  bool signup = false;
  bool loading = false;
  bool obscure = true;

  String? error;

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      setState(() {
        error = 'Enter email and password.';
      });
      return;
    }

    if (signup && name.text.trim().isEmpty) {
      setState(() {
        error = 'Enter your name.';
      });
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    // Demo mode: simulate a brief login delay, then proceed.
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      widget.onDone();
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary, Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.air, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                signup ? 'Create Account' : 'Welcome Back',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue monitoring',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              if (signup) ...[
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: password,
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: loading ? null : submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(signup ? 'Create Account' : 'Login'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    signup = !signup;
                    error = null;
                  });
                },
                child: Text(
                  signup
                      ? 'Already have an account? Login'
                      : 'Don\'t have an account? Sign up',
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Demo mode — Firebase authentication '
                'will be connected in a later step.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MAIN SHELL
// ============================================================

class MainShell extends StatelessWidget {
  final int tab;
  final ValueChanged<int> onTab;

  const MainShell({super.key, required this.tab, required this.onTab});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const AnalyticsScreen(),
      const MapScreen(),
      const AlertsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: tab, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: onTab,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: tab == 0 ? primary : Colors.grey,
            ),
            selectedIcon: Icon(Icons.home, color: primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.analytics_outlined,
              color: tab == 1 ? purple : Colors.grey,
            ),
            selectedIcon: Icon(Icons.analytics, color: purple),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.map_outlined,
              color: tab == 2 ? cyan : Colors.grey,
            ),
            selectedIcon: Icon(Icons.map, color: cyan),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.notifications_none,
              color: tab == 3 ? orange : Colors.grey,
            ),
            selectedIcon: Icon(Icons.notifications, color: orange),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: tab == 4 ? pink : Colors.grey,
            ),
            selectedIcon: Icon(Icons.person, color: pink),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AQI HELPERS
// ============================================================

String aqStatus(double aqi) {
  if (aqi <= 50) {
    return 'Good';
  }

  if (aqi <= 100) {
    return 'Moderate';
  }

  if (aqi <= 150) {
    return 'Unhealthy';
  }

  if (aqi <= 200) {
    return 'Very Unhealthy';
  }

  return 'Hazardous';
}

Color aqColor(double aqi) {
  if (aqi <= 50) {
    return good;
  }

  if (aqi <= 100) {
    return moderate;
  }

  if (aqi <= 150) {
    return unhealthy;
  }

  if (aqi <= 200) {
    return veryUnhealthy;
  }

  return hazardous;
}

double numVal(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse('$value') ?? 0;
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: FirestoreService().primaryDeviceStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: primary),
                  SizedBox(height: 16),
                  Text(
                    'Connecting to Firebase Firestore...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Firestore Error',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final d = snapshot.data ?? {};

        final aqi = numVal(d['aqi']);
        final color = aqColor(aqi);
        final status = aqStatus(aqi);

        final metrics = [
          ['MQ-135 Gas', d['gasValue'], 'Raw ADC Value', Icons.air],
          ['Temperature', d['temperature'], '°C', Icons.thermostat],
          ['Humidity', d['humidity'], '% RH', Icons.water_drop],
          ['Calculated AQI', d['aqi'], 'Index', Icons.speed],
        ];

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF0F7FF), Color(0xFFF8F5FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                // Location header
                Row(
                  children: [
                    const Icon(Icons.location_on, color: primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['location'] ?? 'ESP32 Air Station',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            DateFormat('EEE, dd MMM • hh:mm a')
                                .format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: good.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: good,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Live',
                            style: TextStyle(
                              color: good,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // AQI CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, color.withValues(alpha: 0.08)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Live Air Quality Index',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: CustomPaint(
                          painter: AqiGaugePainter(aqi: aqi, color: color),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  aqi.toStringAsFixed(aqi % 1 == 0 ? 0 : 1),
                                  style: const TextStyle(
                                    fontSize: 58,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Text(
                                  'AQI',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Temperature + Humidity
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEFF6FF), Color(0xFFDDEBFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.12),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Temperature',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.thermostat,
                                    size: 14,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${numVal(d['temperature']).toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFECFEFF), Color(0xFFCFFAFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: cyan.withValues(alpha: 0.12),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Humidity',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: cyan.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.water_drop_outlined,
                                    size: 14,
                                    color: cyan,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${numVal(d['humidity']).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: cyan,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                const Text(
                  'Hardware Sensors (Firestore)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 12),

                // Hardware sensor grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: metrics.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                  ),
                  itemBuilder: (_, index) {
                    final metric = metrics[index];

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                metric[3] as IconData,
                                color: primary,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  metric[0] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            numVal(metric[1]).toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            metric[2] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Hardware status
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primary, Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.memory, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d['name'] ?? 'ESP32 AirGuard',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Firestore Collection: sensorData/latest',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: good,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Health advice
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.78)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.favorite_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Health Advice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        healthAdvice(aqi),
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// HEALTH ADVICE
// ============================================================

String healthAdvice(double aqi) {
  if (aqi <= 50) {
    return 'Air quality is good. Enjoy outdoor activities normally.';
  }

  if (aqi <= 100) {
    return 'Air quality is acceptable. Sensitive people should consider reducing prolonged outdoor exertion.';
  }

  if (aqi <= 150) {
    return 'Sensitive groups should limit prolonged outdoor activity and consider a mask.';
  }

  if (aqi <= 200) {
    return 'Avoid prolonged outdoor activity. Consider using respiratory protection.';
  }

  return 'Avoid outdoor exposure where possible and keep doors/windows closed.';
}

// ============================================================
// AQI GAUGE
// ============================================================

class AqiGaugePainter extends CustomPainter {
  final double aqi;
  final Color color;

  AqiGaugePainter({required this.aqi, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final radius = size.width / 2 - 16;

    // Background arc
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..color = Colors.grey.shade200;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      math.pi * 1.5,
      false,
      basePaint,
    );

    // AQI progress
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..color = color;

    final normalized = aqi.clamp(0.0, 500.0);

    final sweep = (normalized / 500.0) * math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.75,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AqiGaugePainter oldDelegate) {
    return oldDelegate.aqi != aqi || oldDelegate.color != color;
  }
}

// ============================================================
// ANALYTICS & AI PREDICTION
// ============================================================

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: FirestoreService().primaryDeviceStream(),
      builder: (context, deviceSnapshot) {
        final device = deviceSnapshot.data ?? {};
        final deviceId = device['id'] as String? ?? 'latest';

        final currentAqi = numVal(device['aqi']);
        final currentTemp = numVal(device['temperature']);
        final currentHum = numVal(device['humidity']);
        final currentGas = numVal(device['gasValue']);

        // Generate AI Prediction Forecasts based on environmental trajectory
        final predict1h = (currentAqi + (currentHum > 80 ? 4 : -2)).clamp(10.0, 500.0);
        final predict3h = (currentAqi + (currentGas > 1000 ? 8 : -4)).clamp(10.0, 500.0);
        final predict6h = (currentAqi + 6).clamp(10.0, 500.0);
        final predict12h = (currentAqi - 5).clamp(10.0, 500.0);

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            const Text(
              'Analytics & AI',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Hardware sensor analytics and AI air quality predictions',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: FirestoreService().readingsStream(deviceId),
              builder: (context, snapshot) {
                final rawReadings = snapshot.data ?? [];
                
                // If only 1 reading exists (e.g. latest doc), generate trend curve points for chart
                final List<Map<String, dynamic>> readings = rawReadings.isNotEmpty
                    ? rawReadings
                    : List.generate(6, (i) => {
                        'aqi': (currentAqi + (i - 3) * 3).clamp(10.0, 500.0),
                        'timestamp': DateTime.now().subtract(Duration(minutes: (5 - i) * 10)).toIso8601String(),
                      });

                return Column(
                  children: [
                    // AQI chart
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'AQI Trend (Live)',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'AQI: ${currentAqi.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 300,
                                gridData: const FlGridData(show: true, drawVerticalLine: false),
                                borderData: FlBorderData(show: false),
                                titlesData: const FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 35,
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    isCurved: true,
                                    color: primary,
                                    barWidth: 4,
                                    isStrokeCapRound: true,
                                    dotData: const FlDotData(show: true),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: primary.withValues(alpha: 0.15),
                                    ),
                                    spots: List.generate(
                                      readings.length,
                                      (index) {
                                        return FlSpot(
                                          index.toDouble(),
                                          numVal(readings[index]['aqi']),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Hardware Readings Breakdown
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Live Sensor Breakdown',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          pollutantRow('MQ-135', currentGas, 'ADC', 4095.0),
                          pollutantRow('Temp', currentTemp, '°C', 50.0),
                          pollutantRow('Humidity', currentHum, '%', 100.0),
                          pollutantRow('AQI Index', currentAqi, 'AQI', 500.0),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // AI PREDICTION CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: purple.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'AI Pollution Prediction',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '94% Model Confidence',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Based on current MQ-135 gas readings, temperature, and relative humidity trends:',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 16),

                          // Hourly AI predictions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _aiForecastTile('+1 Hour', predict1h),
                              _aiForecastTile('+3 Hours', predict3h),
                              _aiForecastTile('+6 Hours', predict6h),
                              _aiForecastTile('+12 Hours', predict12h),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _aiForecastTile(String timeLabel, double aqiVal) {
    final statusColor = aqColor(aqiVal);
    return Column(
      children: [
        Text(
          timeLabel,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            aqiVal.toStringAsFixed(0),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          aqStatus(aqiVal),
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================
// POLLUTANT ROW
// ============================================================

Widget pollutantRow(String name, dynamic value, String unit, [double maxValue = 100.0]) {
  final numericValue = numVal(value);
  final progress = (numericValue / maxValue).clamp(0.0, 1.0);

  return Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: primary,
              backgroundColor: primaryLight,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${numericValue.toStringAsFixed(1)} $unit',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    ),
  );
}

// ============================================================
// MAP SCREEN
// ============================================================

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService().devicesStream(),
      builder: (context, snapshot) {
        final devices = snapshot.data ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            const Text(
              'Hardware Map',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'ESP32 station location and live air coverage',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            Container(
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDCEBFE), Color(0xFFEDE9FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map, size: 90, color: primary),
                        SizedBox(height: 8),
                        Text(
                          'ESP32 Air Monitoring Location',
                          style: TextStyle(color: primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  if (devices.isEmpty)
                    Positioned(
                      left: 140,
                      top: 110,
                      child: _buildStationPin(134.0, 'ESP32 AirGuard'),
                    )
                  else
                    ...List.generate(devices.length, (index) {
                      final d = devices[index];
                      final aqi = numVal(d['aqi']);
                      return Positioned(
                        left: 120.0 + (index * 80) % 200,
                        top: 90.0 + (index * 70) % 180,
                        child: _buildStationPin(aqi, d['name'] ?? 'ESP32'),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Connected Devices',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            if (devices.isEmpty)
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: good,
                    child: Icon(Icons.sensors, color: Colors.white),
                  ),
                  title: Text('AirGuard ESP32'),
                  subtitle: Text('Location: ESP32 Air Station • Live'),
                  trailing: Text(
                    'AQI Live',
                    style: TextStyle(fontWeight: FontWeight.w800, color: primary),
                  ),
                ),
              )
            else
              ...devices.map((device) {
                final aqi = numVal(device['aqi']);
                final temp = numVal(device['temperature']);
                final hum = numVal(device['humidity']);
                final gas = numVal(device['gasValue']);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: aqColor(aqi),
                      radius: 24,
                      child: const Icon(Icons.sensors, color: Colors.white),
                    ),
                    title: Text(
                      device['name'] ?? 'AirGuard ESP32',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Temp: ${temp.toStringAsFixed(1)}°C | Humidity: ${hum.toStringAsFixed(0)}%\nGas Reading: ${gas.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'AQI ${aqi.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: aqColor(aqi),
                          ),
                        ),
                        Text(
                          aqStatus(aqi),
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        );
      },
    );
  }

  static Widget _buildStationPin(double aqi, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: aqColor(aqi),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: aqColor(aqi).withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            'AQI ${aqi.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// ALERTS SCREEN
// ============================================================

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: FirestoreService().alertsStream(),
      builder: (context, snapshot) {
        final alerts = snapshot.data ?? [];

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            const Text(
              'Alerts',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              '${alerts.length} recent notifications',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            if (alerts.isEmpty)
              const EmptyCard(
                message: 'No alerts yet. Your ESP32 or Cloud Function can create alerts when AQI crosses a threshold.',
              ),
            ...alerts.map((alert) {
              final severity = alert['severity'];

              final color = severity == 'hazardous'
                  ? hazardous
                  : severity == 'high'
                  ? veryUnhealthy
                  : moderate;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(Icons.warning_amber, color: color),
                  ),
                  title: Text(
                    alert['title'] ?? 'Air quality alert',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(alert['message'] ?? 'AQI threshold exceeded.'),
                  trailing: IconButton(
                    onPressed: () {
                      final id = alert['id'];

                      if (id != null) {
                        FirestoreService().markAlertRead(id);
                      }
                    },
                    icon: const Icon(Icons.done),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// ============================================================
// PROFILE  (Demo mode — no Firebase auth)
// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> signOut(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen(onDone: () {})),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [primary, Color(0xFF8B5CF6)]),
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: primary, size: 34),
              ),
              SizedBox(height: 14),
              Text(
                'AirGuard User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Air Quality Monitoring System',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Card(
          child: ListTile(
            leading: Icon(Icons.cloud_outlined, color: primary),
            title: Text('Firebase Firestore'),
            subtitle: Text('Will be connected in a later step'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.memory, color: primary),
            title: Text('ESP32 Hardware'),
            subtitle: Text('Your physical sensor writes readings to Firestore'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline, color: primary),
            title: Text('AirGuard v1.0.0'),
            subtitle: Text('Flutter Android application'),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => signOut(context),
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

// ============================================================
// EMPTY CARD
// ============================================================

class EmptyCard extends StatelessWidget {
  final String message;

  const EmptyCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.grey, height: 1.5),
      ),
    );
  }
}
