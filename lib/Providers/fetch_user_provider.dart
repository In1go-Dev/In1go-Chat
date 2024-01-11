import 'dart:async';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/home_page_functions.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUserProvider = Provider.autoDispose((ref) => UserInfoModel());

class UserInfoModel {

  Future<List<AuthUserAttribute>?> checkCurrentUser() async {
    final Completer<List<AuthUserAttribute>?> completer = Completer<List<AuthUserAttribute>?>();
    try{
      
      if(Amplify.isConfigured) {
        final loggedResult = await Amplify.Auth.fetchUserAttributes();   //Retrieve the current user's data
        await recordChecking(loggedResult);   //Checks the status of the user's record in the cloud database
        safePrint('\nUser is signed in\n');
        completer.complete(loggedResult);
      }

      else {
        completer.completeError(Exception('Amplify is not configured'));
      }

    } on AuthException catch(error) {
      safePrint('User is not signed in');
      completer.completeError(error);
    } on TimeoutException catch(error) {
      safePrint('Functionality timed out');
      completer.completeError(error);
    } on SocketException catch(error) {
      safePrint('Server timed Out');
      completer.completeError(error);
    } on DataStoreException catch(error) {
      safePrint('DataStore Operations failed');
      completer.completeError(error);
    }
    return completer.future;
  }

  Future<void> recordChecking(List<AuthUserAttribute> userData) async {    //07-05-2023: GEU - Check the user's record in the Amplify database
    try{

      //Retrieves the equivalent User record directly from the Database.
      //GraphQL operation is used because Amplify Datastore operations is "local-first" in terms of priority
      final response = await getLoggedUser(userData[0].value, checkIfMNameisEmpty(userData, 6));
      final user = response.data?.items;
      
      if(user != null) {
        if(user.isEmpty) {   //If there is not record in the database, a new record is created and contacts are implemented

          final newUser = User(
            id: userData[0].value,
            email: checkIfMNameisEmpty(userData, 6),    //Checks if the account information has middle name - The lack of one affects the index of other records
            username: userData[2].value,
            given_name: userData[3].value,
            middle_name: getMiddleName(userData),    //Checks if there is a middle name
            family_name: checkIfMNameisEmpty(userData, 5), 
            account_status: 0
          );
          //await saveUserAndAddContacts(newUser);
          await Amplify.DataStore.save(newUser);
        }
        
        else {       //If there is a record...
          User userRecord = user.singleWhere((element) => element!.id == userData[0].value)!;
          //_checkUserRecordAndContactList(userData, userRecord);
          await checkCurrentRecord(userData, userRecord);
        }
      }
    } on Exception catch(e) {
      safePrint('Record Functionality Failed - Error: $e');
    }
  }

  Future<void> checkCurrentRecord(List<AuthUserAttribute> userData, User userRecord) async {
    //If there is more than one record, retrieve the record matching the current user's id

    if(userRecord.email != checkIfMNameisEmpty(userData, 6) || userRecord.username != userData[2].value || userRecord.given_name != userData[3].value || 
    userRecord.middle_name != getMiddleName(userData) || userRecord.family_name != checkIfMNameisEmpty(userData, 5)
    ) {   //If there are any mismatches in the record, update the record with the user's current data

      final updatedUser = User(
        id: userData[0].value, 
        email: checkIfMNameisEmpty(userData, 6),
        username: userData[2].value,
        given_name: userData[3].value,
        middle_name: getMiddleName(userData),
        family_name: checkIfMNameisEmpty(userData, 5),
        account_status: userRecord.account_status,
        profile_image: userRecord.profile_image,
        memberships: userRecord.memberships,
        principal_id: userRecord.principal_id,
        principal_name: userRecord.principal_name
      );
      await Amplify.DataStore.save(updatedUser);
    }

    else {
      safePrint('Record Already Exists');
    }
  }

  Future<GraphQLResponse<PaginatedResult<User>>> getLoggedUser(String id, String email) async {
    final request = ModelQueries.list(User.classType, where: User.ID.eq(id).or(User.ID.eq(email)));
    final response = await Amplify.API.query(request: request).response;
    return response;
  }
}