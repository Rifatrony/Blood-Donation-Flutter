import 'package:blood_donation_app/app/module/blood_request/view/receive_request_view.dart';
import 'package:blood_donation_app/app/module/blood_request/view/send_request_view.dart';
import 'package:blood_donation_app/app/module/notification/view/notification_view.dart';
import 'package:blood_donation_app/app/module/profile/view/profile_view.dart';
import 'package:blood_donation_app/app/module/signup/view/signup_view.dart';
import 'package:blood_donation_app/app/route/routes.dart';
import 'package:get/get.dart';

import '../module/blood_request/view/blood_request_view.dart';
import '../module/donate/view/donate_view.dart';
import '../module/donor/view/donor_details.dart';
import '../module/donor/view/donor_view.dart';
import '../module/home/view/home_view.dart';
import '../module/login/view/login_view.dart';
import '../module/splash/view/splash_view.dart';


class AppPages {
  static const INITIAL = RouteName.splash;

  static final routes = [
    GetPage(
      name: RouteName.splash,
      page: () => const SplashView(),
      // binding: SplashBindings(),
    ),

    GetPage(
      name: RouteName.login,
      page: () => LoginView(),
      transition: Transition.fade,
      // binding: LoginBindings(),
    ),

    GetPage(
      name: RouteName.signup,
      page: () => SignUpView(),
      transition: Transition.fade,
      // binding: LoginBindings(),
    ),

    GetPage(
      name: RouteName.home,
      page: () => const HomeView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.donor,
      page: () => const DonorView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.donorDetails,
      page: () => const DonorDetailsView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.donate,
      page: () => const DonateView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.bloodRequest,
      page: () => const BloodRequestView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.sendRequest,
      page: () => const SendRequestView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.receiveRequest,
      page: () => const ReceiveRequestView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.notification,
      page: () => const NotificationView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

    GetPage(
      name: RouteName.profile,
      page: () => const ProfileView(),
      transition: Transition.fade,
      // binding: HomeBindings(),
    ),

  ];
}