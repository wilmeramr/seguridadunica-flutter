import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/screens.dart';
import 'package:flutter_application_1/services/services.dart';
import 'package:flutter_application_1/services/push_notifications_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'controllers/controllers.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  runApp(AppState());
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
      print(badgeCtrl.badge.value);
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
        'invitar': (_) => InvitarScreen(),
        'invitarInicio': (_) => SliderListScreen(),
        'servicioInicio': (_) => ServicioInicioScreen(),
        'invitarServicioInicio': (_) => InvitarServicioScreen(),
        'notificacionInicio': (_) => NotificacionInicioScreen(),
        'evniarNotificacion': (_) => EnviarNotificacionScreen(),
        'deliveryInicio': (_) => DeliveryInicioScreen(),
        'invitarDeliveryInicio': (_) => InvitarDeliveryScreen(),
        'eventoInicio': (_) => EventoInicioScreen(),
        'invitarEventoInicio': (_) => InvitarEventoScreen(),
        'mascotaInicio': (_) => MascotaInicioScreen(),
        'mascotaEditar': (_) => MascotaEditarScreen(),
        'servicio': (_) => InvitarScreen(),
        'dash2': (_) => DashScreen(),
        'slider': (_) => SliderListScreen(),
        'detalleautorizacion': (_) => DetalleAutorizacionScreen()
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: AppBarTheme(elevation: 0),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(elevation: 0)),
    );
  }
}
