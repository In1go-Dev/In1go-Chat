import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/general_functions.dart';
import 'package:app_1gochat/Providers/fetch_user_provider.dart';
import 'package:app_1gochat/Screens/General/Widgets/custom_loadingerrorlayout.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/home_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageDisplay extends ConsumerStatefulWidget {
  const HomePageDisplay({super.key});

  @override
  ConsumerState<HomePageDisplay> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePageDisplay> {
  Widget? homePageFutureBuilder;

  @override
  Widget build(BuildContext context) {
    if(homePageFutureBuilder != null) {
      return homePageFutureBuilder!;
    }
    else{
      return const SizedBox.expand();
    }
  }

  Widget mainBuild() {
    return FutureBuilder<List<AuthUserAttribute>?>(
      future: ref.read(authUserProvider).checkCurrentUser(),
      builder: (context, userState) {
        
        if(userState.connectionState == ConnectionState.done && userState.hasData && userState.data!.first.value.isNotEmpty){
          final userData = userState.data!;

          return PopScope(
            canPop: false,
            onPopInvoked: (check) async {
              putAppInBackground();
            },
            child: HomePageLayout(userData: userData)
          );
        }

        else if(userState.connectionState == ConnectionState.done && (userState.hasData && userState.data!.first.value.isEmpty)) {
          return ErrorScreen(reload: () => setState(() {
            homePageFutureBuilder = mainBuild();
          }));
        }

        else if(userState.hasError) {      
          return ErrorScreen(reload: () => setState(() {
            homePageFutureBuilder = mainBuild();
          }));
        }

        return const PopScope(
          canPop: false,
          child: Scaffold(
            body: SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              )
            )
          )
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    homePageFutureBuilder = mainBuild();
  }
}