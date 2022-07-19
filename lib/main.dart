import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Unica/screens/screens.dart';
import 'package:Unica/services/services.dart';
import 'package:Unica/services/push_notifications_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'controllers/controllers.dart';
import 'screens/home_screen.dart';

void main() async {
  /*  FlutterError.onError = (details) {
    final exception = details.exception;
    final stackTrace = details.stack;
    print('hola');

    if (kReleaseMode) {
      Zone.current.handleUncaughtError(exception, stackTrace!);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  }; */

  await runZonedGuarded<Future<void>>(() async {
    // WidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    await PushNotificationService.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    /*  FlutterError.onError = (FlutterErrorDetails details) {
      final exception = details.exception;
      final stackTrace = details.stack ?? StackTrace.fromString('');

      if (!kReleaseMode) {
        Zone.current.handleUncaughtError(exception, stackTrace);
      } else {
        FlutterError.dumpErrorToConsole(details);
      }
    }; */

    runApp(AppState());
  }, (error, stackTrace) {
    NotificationsService.showSnackbar(
        'Oh!',
        "Debe asegurarse que el dipositivo tengo conexión a internet",
        ContentType.failure);
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
  });
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AutService()),
        ChangeNotifierProvider(create: (_) => ServicioService()),
        ChangeNotifierProvider(create: (_) => DeliveryService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationService.messageStream.listen((message) {
      final badgeCtrl = Get.find<BadgeController>();
      badgeCtrl.badge.value += 1;
      print('MyApp: $message');
      /*  print('MyApp: $message');
      if (message == 'message')
        NotificationsService.navigatorKey.currentState
            ?.pushNamed('message', arguments: message);
      if (message == 'invitacion')
        NotificationsService.navigatorKey.currentState
            ?.pop('notificacionInicio');

      if (message == 'Mascota')
        NotificationsService.navigatorKey.currentState
            ?.pushReplacementNamed('mascotaInicio');

      final snackBar = SnackBar(content: Text(message));
      NotificationsService.messengerKey.currentState?.showSnackBar(snackBar); */
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seguridad Unica',
      initialRoute: "checking",
      navigatorKey: NotificationsService.navigatorKey,
      scaffoldMessengerKey: NotificationsService.messengerKey,
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
        'checking': (_) => CheckAuthScreen(),
        'dash': (_) => DashBoardScreen(),
        'autorizaInvita': (_) => InvitaAutorizaScreen(),
        'autorizaInicio': (_) => InicioAutorizaScreen(),
        'servicioInicio': (_) => InicioServicioScreen(),
        'invitarServicio': (_) => InvitaServicioScreen(),
        'notificacionInicio': (_) => NotificacionInicioScreen(),
        'evniarNotificacion': (_) => EnviarNotificacionScreen(),
        'deliveryInicio': (_) => DeliveryInicioScreen(),
        'invitarDeliveryInicio': (_) => InvitarDeliveryScreen(),
        'eventoInicio': (_) => EventoInicioScreen(),
        'invitarEventoInicio': (_) => InvitarEventoScreen(),
        'mascotaInicio': (_) => MascotaInicioScreen(),
        'mascotaEditar': (_) => MascotaEditarScreen(),
        'servicio': (_) => InvitaAutorizaScreen(),
        'dash2': (_) => DashScreen(),
        'detalleautorizacion': (_) => DetalleAutorizacionScreen(),
        'inicioSelfie': (_) => InicioSelfieScreen()
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(elevation: 0),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(elevation: 0)),
    );
  }
}
