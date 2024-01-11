import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/user_account_page.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/home_body.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/home_buttomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageLayout extends ConsumerWidget {
  const HomePageLayout({super.key, required this.userData});
  
  final List<AuthUserAttribute> userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: HomePageBody(userData: userData),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          
          if(index != 2) {
            //08-29-2023: GEU - Changes the Bottom Nav Bar state and clears the Search Bar
            ref.read(searchField.notifier).update((state) => TextEditingController(text: ''));
            ref.read(searchInput.notifier).state = '';
            ref.read(pageindex.notifier).state = index;
          }
          
          else {
            //05-02-2023: GEU - Navigation for Account Information Page
            navigateToAccountDisplay(context, userData);
          }
        }
      )
    );
  }

  //Page Navigation to Account Display Page
  
  void navigateToAccountDisplay(BuildContext context, List<AuthUserAttribute> currUser) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:(context, animation, secondaryAnimation) {
          return AccountDisplayPage(
            currUser: currUser,
            userState: true,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
    
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      )
    );
  }
}