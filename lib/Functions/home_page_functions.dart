import 'package:amplify_flutter/amplify_flutter.dart';


//10-9-2023: GEU - Checks if the Account has a Middle Name. For the current Auth settings, Middle Name informatio is in index "4".

String checkIfMNameisEmpty(List<AuthUserAttribute> userData, int index) {
  bool checkMName = (userData[4].userAttributeKey.key != "middle_name" && userData[4].userAttributeKey.key == "family_name") ? true : false;
  switch (checkMName) {
    case true:
      return userData[index-1].value;
    case false:
      return userData[index].value;
  }
}

//10-9-2023: GEU - Checks if the Account has a Middle Name. If yes, retreive it. Otherwise, return an empty string.

String getMiddleName(List<AuthUserAttribute> userData) {
  bool checkMName = (userData[4].userAttributeKey.key != "middle_name" && userData[4].userAttributeKey.key == "family_name") ? false : true;
  switch (checkMName) {
    case true:
      return userData[4].value;
    case false:
      return '';
  }
}

//Default Latest Message Display if it contains an attachment

String checkAttachmentMessageSource(String messageSource, String currentUserId) {
  if(messageSource != currentUserId) {
    return 'You received an attachment';
  }

  else {
    return 'You sent an attachment';
  }
}