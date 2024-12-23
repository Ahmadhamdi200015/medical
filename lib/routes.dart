
import 'package:get/get.dart';
import 'package:medicall/view/screen/admin/admin_advice.dart';
import 'package:medicall/view/screen/admin/admin_analytics.dart';
import 'package:medicall/view/screen/admin/admin_home.dart';
import 'package:medicall/view/screen/admin/admin_specialty.dart';
import 'package:medicall/view/screen/doctor/doctor_home_screen.dart';
import 'package:medicall/view/screen/home_page.dart';
import 'package:medicall/view/screen/login_page.dart';
import 'package:medicall/view/screen/patient/details_page.dart';
import 'package:medicall/view/screen/patient/patient_home.dart';
import 'package:medicall/view/screen/signup_page.dart';


import 'core/constant/route.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
      name: "/", page: () => const LoginPage()),

  GetPage(name:AppRoute.login, page:()=>const LoginPage()),

GetPage(name:AppRoute.signPage, page:()=>const SignupPage()),
  GetPage(name:AppRoute.homePage, page:()=>const HomePage()),
  GetPage(name:AppRoute.adminHome, page:()=>const AdminHome()),
  GetPage(name:AppRoute.detailsPage, page:()=>const DetailsPage()),
  GetPage(name:AppRoute.patientHome, page:()=>const PatientHome()),
  GetPage(name:AppRoute.homeScreen, page:()=>const DoctorHomeScreen()),
  GetPage(name:AppRoute.adminSpecialty, page:()=>const AdminSpecialty()),
  GetPage(name:AppRoute.adminAnalytics, page:()=>const AdminAnalytics()),


  GetPage(name:AppRoute.adminAdvice, page:()=>const AdminAdvice()),
















];
