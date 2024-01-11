/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _email;
  final String? _username;
  final String? _given_name;
  final String? _middle_name;
  final String? _family_name;
  final String? _profile_image;
  final int? _account_status;
  final String? _principal_id;
  final String? _principal_name;
  final List<RoomUser>? _memberships;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get username {
    try {
      return _username!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get given_name {
    try {
      return _given_name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get middle_name {
    return _middle_name;
  }
  
  String get family_name {
    try {
      return _family_name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get profile_image {
    return _profile_image;
  }
  
  int get account_status {
    try {
      return _account_status!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get principal_id {
    return _principal_id;
  }
  
  String? get principal_name {
    return _principal_name;
  }
  
  List<RoomUser>? get memberships {
    return _memberships;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, required email, required username, required given_name, middle_name, required family_name, profile_image, required account_status, principal_id, principal_name, memberships, createdAt, updatedAt}): _email = email, _username = username, _given_name = given_name, _middle_name = middle_name, _family_name = family_name, _profile_image = profile_image, _account_status = account_status, _principal_id = principal_id, _principal_name = principal_name, _memberships = memberships, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, required String email, required String username, required String given_name, String? middle_name, required String family_name, String? profile_image, required int account_status, String? principal_id, String? principal_name, List<RoomUser>? memberships}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      email: email,
      username: username,
      given_name: given_name,
      middle_name: middle_name,
      family_name: family_name,
      profile_image: profile_image,
      account_status: account_status,
      principal_id: principal_id,
      principal_name: principal_name,
      memberships: memberships != null ? List<RoomUser>.unmodifiable(memberships) : memberships);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _email == other._email &&
      _username == other._username &&
      _given_name == other._given_name &&
      _middle_name == other._middle_name &&
      _family_name == other._family_name &&
      _profile_image == other._profile_image &&
      _account_status == other._account_status &&
      _principal_id == other._principal_id &&
      _principal_name == other._principal_name &&
      DeepCollectionEquality().equals(_memberships, other._memberships);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("username=" + "$_username" + ", ");
    buffer.write("given_name=" + "$_given_name" + ", ");
    buffer.write("middle_name=" + "$_middle_name" + ", ");
    buffer.write("family_name=" + "$_family_name" + ", ");
    buffer.write("profile_image=" + "$_profile_image" + ", ");
    buffer.write("account_status=" + (_account_status != null ? _account_status!.toString() : "null") + ", ");
    buffer.write("principal_id=" + "$_principal_id" + ", ");
    buffer.write("principal_name=" + "$_principal_name" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? email, String? username, String? given_name, String? middle_name, String? family_name, String? profile_image, int? account_status, String? principal_id, String? principal_name, List<RoomUser>? memberships}) {
    return User._internal(
      id: id,
      email: email ?? this.email,
      username: username ?? this.username,
      given_name: given_name ?? this.given_name,
      middle_name: middle_name ?? this.middle_name,
      family_name: family_name ?? this.family_name,
      profile_image: profile_image ?? this.profile_image,
      account_status: account_status ?? this.account_status,
      principal_id: principal_id ?? this.principal_id,
      principal_name: principal_name ?? this.principal_name,
      memberships: memberships ?? this.memberships);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String>? email,
    ModelFieldValue<String>? username,
    ModelFieldValue<String>? given_name,
    ModelFieldValue<String?>? middle_name,
    ModelFieldValue<String>? family_name,
    ModelFieldValue<String?>? profile_image,
    ModelFieldValue<int>? account_status,
    ModelFieldValue<String?>? principal_id,
    ModelFieldValue<String?>? principal_name,
    ModelFieldValue<List<RoomUser>?>? memberships
  }) {
    return User._internal(
      id: id,
      email: email == null ? this.email : email.value,
      username: username == null ? this.username : username.value,
      given_name: given_name == null ? this.given_name : given_name.value,
      middle_name: middle_name == null ? this.middle_name : middle_name.value,
      family_name: family_name == null ? this.family_name : family_name.value,
      profile_image: profile_image == null ? this.profile_image : profile_image.value,
      account_status: account_status == null ? this.account_status : account_status.value,
      principal_id: principal_id == null ? this.principal_id : principal_id.value,
      principal_name: principal_name == null ? this.principal_name : principal_name.value,
      memberships: memberships == null ? this.memberships : memberships.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _email = json['email'],
      _username = json['username'],
      _given_name = json['given_name'],
      _middle_name = json['middle_name'],
      _family_name = json['family_name'],
      _profile_image = json['profile_image'],
      _account_status = (json['account_status'] as num?)?.toInt(),
      _principal_id = json['principal_id'],
      _principal_name = json['principal_name'],
      _memberships = json['memberships'] is List
        ? (json['memberships'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => RoomUser.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'email': _email, 'username': _username, 'given_name': _given_name, 'middle_name': _middle_name, 'family_name': _family_name, 'profile_image': _profile_image, 'account_status': _account_status, 'principal_id': _principal_id, 'principal_name': _principal_name, 'memberships': _memberships?.map((RoomUser? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'email': _email,
    'username': _username,
    'given_name': _given_name,
    'middle_name': _middle_name,
    'family_name': _family_name,
    'profile_image': _profile_image,
    'account_status': _account_status,
    'principal_id': _principal_id,
    'principal_name': _principal_name,
    'memberships': _memberships,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final USERNAME = amplify_core.QueryField(fieldName: "username");
  static final GIVEN_NAME = amplify_core.QueryField(fieldName: "given_name");
  static final MIDDLE_NAME = amplify_core.QueryField(fieldName: "middle_name");
  static final FAMILY_NAME = amplify_core.QueryField(fieldName: "family_name");
  static final PROFILE_IMAGE = amplify_core.QueryField(fieldName: "profile_image");
  static final ACCOUNT_STATUS = amplify_core.QueryField(fieldName: "account_status");
  static final PRINCIPAL_ID = amplify_core.QueryField(fieldName: "principal_id");
  static final PRINCIPAL_NAME = amplify_core.QueryField(fieldName: "principal_name");
  static final MEMBERSHIPS = amplify_core.QueryField(
    fieldName: "memberships",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RoomUser'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.USERNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.GIVEN_NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.MIDDLE_NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.FAMILY_NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PROFILE_IMAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.ACCOUNT_STATUS,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PRINCIPAL_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PRINCIPAL_NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.MEMBERSHIPS,
      isRequired: false,
      ofModelName: 'RoomUser',
      associatedKey: RoomUser.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}