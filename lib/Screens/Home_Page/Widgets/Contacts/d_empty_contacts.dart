import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:flutter/material.dart';


class AddContactFutureBuilder extends StatelessWidget {
  const AddContactFutureBuilder({super.key, required this.currentUserId});

  final String currentUserId;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prepareAddContacts(),
      initialData: null,
      builder:(context, snapshot) {
        return const Center(
          child: Text('You have no contacts')
        );
      }
    );
  }

  Future<void> prepareAddContacts() async {      //09-22-2023: GEU - Adding new contacts for the user
    try{
      final userRecord = await Amplify.DataStore.query(User.classType, where: User.ID.eq(currentUserId));
      
      safePrint('User has ----- ${userRecord.length}');
      if(userRecord.isNotEmpty && userRecord.first.account_status == 0) {    //Checks if the user has a record and if their account status is new
        await autoAddContacts(userRecord.first);
      }
    } on DataStoreException catch(error) {
      safePrint('Error: ${error.message}');
    }
  }

  Future<void> autoAddContacts(User senderAccount) async {
    try {
      List<User> resultingMembers = await Amplify.DataStore.query(User.classType);

      if(resultingMembers.isNotEmpty && resultingMembers.length > 1) {     //Checks if there are other accounts recorded in the database

        User currUser = resultingMembers.singleWhere((element) => element.id == senderAccount.id);
        resultingMembers.removeWhere((element) => element.id == currUser.id);
        resultingMembers.insert(0, currUser);
        
        List<RoomUser> relationships = await Amplify.DataStore.query(RoomUser.classType, where: RoomUser.USER.eq(senderAccount.id));

        if(relationships.isEmpty) {          //Checks if the account has contact records with other accounts
          for(var user in resultingMembers) {
            safePrint('User ID ----- ${user.id}');

            if(currUser.id != user.id) {          //Checks if the user record's id is not the signed in account's id
              safePrint('Auto Add Contacts - User: ${user.id}');

              final modifiedUser = (senderAccount.account_status == 0) ? updateRecordStatus(user) : user;    //If the account status is new, change its status
              Room chatroom = Room(creator_id: senderAccount.id, isGroup: false);
              RoomUser senderContact = RoomUser(user: senderAccount, room: chatroom);
              RoomUser recipientContact = RoomUser(user: modifiedUser, room: chatroom);
              
              if(senderAccount.account_status == 0) await Amplify.DataStore.save(modifiedUser);     //Saves the modifed records of the logged account to the database
              await Amplify.DataStore.save(chatroom);          //Saves the Chat Room record to the database
              await Amplify.DataStore.save(senderContact);          //Saves the relationship record between the signed user and the chat room to the database
              await Amplify.DataStore.save(recipientContact);          //Saves the relationship record between the other account and the chat room to the database
            }
          }
        }
      }
      
      safePrint('Passed on Auto Add Contacts');
    } on DataStoreException catch (e) {
      safePrint('This is the error ---- ${e.message}');
    } on NetworkException catch (n) {
      safePrint('This is the error ---- ${n.message}');
    } on SocketException catch (s) {
      safePrint('This is the error ---- ${s.message}');
    }
  }

  User updateRecordStatus(User userRecord) {
    return User(
      id: userRecord.id,
      email: userRecord.email,
      username: userRecord.username,
      given_name: userRecord.given_name,
      middle_name: userRecord.middle_name,
      family_name: userRecord.family_name,
      account_status: 1,
      principal_id: userRecord.principal_id,
      principal_name: userRecord.principal_name
    );
  }
}