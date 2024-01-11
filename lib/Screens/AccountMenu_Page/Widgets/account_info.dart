import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountInformationLayout extends StatelessWidget {
  const AccountInformationLayout({super.key, required this.username, required this.email, required this.fullname});

  final String username;
  final String email;
  final String fullname;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 28), 
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    margin: const EdgeInsets.only(top: 34, bottom: 5),
                    alignment: Alignment.center,
                    child: Text(
                      username,
                      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Divider(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  ListTile(
                    leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.email),
                    ),
                    title: const Text(
                      "Email Address",
                      style: TextStyle(fontSize: 14)
                    ),
                    subtitle: Text(
                      email,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis
                    ),
                    trailing: SizedBox(
                      height: double.infinity,
                      child: IconButton(
                        onPressed: () async => await Clipboard.setData(ClipboardData(text: email)),
                        splashRadius: Material.defaultSplashRadius * 0.5,
                        icon: const Icon(
                          Icons.copy,
                          size: 18,
                        )
                      )
                    ),
                    dense: true,
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey[400],
                  ),

                  ListTile(
                    leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.account_circle),
                    ),
                    title: const Text(
                      "Full Name",
                      style: TextStyle(fontSize: 14)
                    ),
                    subtitle: Text(
                      fullname,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis
                    ),
                    trailing: SizedBox(
                      height: double.infinity,
                      child: IconButton(
                        onPressed: () async => await Clipboard.setData(ClipboardData(text: fullname)),
                        splashRadius: Material.defaultSplashRadius * 0.5,
                        icon: const Icon(
                          Icons.copy,
                          size: 18,
                        )
                      )
                    ),
                    dense:true,
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                  )
                ]
              )
            )
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              child: Center(
                child: CircleAvatar(
                  minRadius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    username.substring(0, 2),
                    style: const TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )
              )
            ),
          )
        ],
      ),
    );
    
    //Padding(
    //  //onPressed: () {},
    //  //elevation: 0,
    //  padding: const EdgeInsets.all(0),
    //  child: ListTile(
    //    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    //    leading: CircleAvatar(
    //      backgroundColor: Theme.of(context).primaryColor,
    //      child: Text((currUser[2].value.isNotEmpty) ? currUser[2].value.substring(0, 2) : '?', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
    //    ),
    //    title: Text(
    //      currUser[2].value,
    //      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
    //    ),
    //    subtitle: Text(
    //      checkIfMNameisEmpty(currUser, 6),
    //      style: const TextStyle(fontSize: 14, color: Colors.black)
    //    ),
    //  )
    //);
  }
}