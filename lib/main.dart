import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/screens/intro_screens/startup/splash_screen.dart';
import 'package:dar_elteb/shared/bloc_observer.dart';
import 'package:dar_elteb/shared/network/local/cache_helper.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/shared/network/remote/dio_helper.dart';
import 'package:dar_elteb/tech_lib/tech_cubit/tech_cubit.dart';
import 'package:dar_elteb/translations/codegen_loader.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator.adaptive(),
    );
  };
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DioHelper.init();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  deviceToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('deviceToken : $deviceToken ');
  }

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('icon_logo');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  if (Platform.isAndroid){
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (Platform.isAndroid){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,

                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    }

    if (kDebugMode) {
      print('onMessage message.data.toString() ${message.data.toString()}');
    }
    if (message.data['message'] == 'ReservationScreen') {
      if (kDebugMode) {
        print('message Reservation Screen');
      }
    }
  });

  void permission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    if (kDebugMode) {
      print(
          'onMessageOpenedApp event.data.toString() ${event.data.toString()}');
    }
    if (event.data['message'] == 'ReservationScreen') {
      if (kDebugMode) {
        print('message Reservation Screen');
      }
    }
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  BlocOverrides.runZoned(
    () {
      if (Platform.isIOS || Platform.isAndroid) {
        /// IOS || Android check permission
        permission();
      }
      runApp(
        EasyLocalization(
          path: 'assets/translations',
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          fallbackLocale: const Locale('en'),
          assetLoader: const CodegenLoader(),
          child: const MyApp(
            startWidget: SplashScreen(),
          ),
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('on background message');
    print(message.data.toString());
  }
  // showToast(msg: 'on background message', state: ToastState.success);
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    Key? key,
    required this.startWidget,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit()
            ..getCarouselData()
            ..getOnboarding(),
        ),
        BlocProvider(create: (BuildContext context) => AppTechCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates +
            [
              CountryLocalizations.delegate,
            ],
        home: startWidget,
      ),
    );
  }
}
