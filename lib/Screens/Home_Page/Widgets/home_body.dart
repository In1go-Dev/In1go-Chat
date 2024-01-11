import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/a_contact_list_streambuilder.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/home_appbar.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageBody extends ConsumerWidget {
  const HomePageBody({super.key, required this.userData});

  final List<AuthUserAttribute> userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
          height: 300,
          color: Theme.of(context).primaryColor,
        ),
        
        Column(
          children: [
            MainPageAppBar(
              initials: userData[2].value.substring(0, 2),
              titleName: 'Conversations',
              //account: () => navigateToAccountDisplay(context, userData),
            ),
            
            const SearchField(),
    
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45)
                  )
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)
                  ),
                  child: ContactListBuilder(
                    currentUserId: userData.first.value,
                    username: userData[2].value,
                  )
                )
              )
            )
          ]
        ),
      ]
    );
  }
}