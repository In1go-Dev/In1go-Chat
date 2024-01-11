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


/** This is an auto generated class representing the Room type in your schema. */
class Room extends amplify_core.Model {
  static const classType = const _RoomModelType();
  final String id;
  final String? _room_name;
  final String? _creator_id;
  final bool? _isGroup;
  final String? _message_sender;
  final String? _latest_message;
  final String? _message_type;
  final String? _message_timestamp;
  final List<Message>? _contents;
  final List<RoomUser>? _members;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RoomModelIdentifier get modelIdentifier {
      return RoomModelIdentifier(
        id: id
      );
  }
  
  String? get room_name {
    return _room_name;
  }
  
  String? get creator_id {
    return _creator_id;
  }
  
  bool get isGroup {
    try {
      return _isGroup!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get message_sender {
    return _message_sender;
  }
  
  String? get latest_message {
    return _latest_message;
  }
  
  String? get message_type {
    return _message_type;
  }
  
  String? get message_timestamp {
    return _message_timestamp;
  }
  
  List<Message>? get contents {
    return _contents;
  }
  
  List<RoomUser>? get members {
    return _members;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Room._internal({required this.id, room_name, creator_id, required isGroup, message_sender, latest_message, message_type, message_timestamp, contents, members, createdAt, updatedAt}): _room_name = room_name, _creator_id = creator_id, _isGroup = isGroup, _message_sender = message_sender, _latest_message = latest_message, _message_type = message_type, _message_timestamp = message_timestamp, _contents = contents, _members = members, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Room({String? id, String? room_name, String? creator_id, required bool isGroup, String? message_sender, String? latest_message, String? message_type, String? message_timestamp, List<Message>? contents, List<RoomUser>? members}) {
    return Room._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      room_name: room_name,
      creator_id: creator_id,
      isGroup: isGroup,
      message_sender: message_sender,
      latest_message: latest_message,
      message_type: message_type,
      message_timestamp: message_timestamp,
      contents: contents != null ? List<Message>.unmodifiable(contents) : contents,
      members: members != null ? List<RoomUser>.unmodifiable(members) : members);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Room &&
      id == other.id &&
      _room_name == other._room_name &&
      _creator_id == other._creator_id &&
      _isGroup == other._isGroup &&
      _message_sender == other._message_sender &&
      _latest_message == other._latest_message &&
      _message_type == other._message_type &&
      _message_timestamp == other._message_timestamp &&
      DeepCollectionEquality().equals(_contents, other._contents) &&
      DeepCollectionEquality().equals(_members, other._members);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Room {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("room_name=" + "$_room_name" + ", ");
    buffer.write("creator_id=" + "$_creator_id" + ", ");
    buffer.write("isGroup=" + (_isGroup != null ? _isGroup!.toString() : "null") + ", ");
    buffer.write("message_sender=" + "$_message_sender" + ", ");
    buffer.write("latest_message=" + "$_latest_message" + ", ");
    buffer.write("message_type=" + "$_message_type" + ", ");
    buffer.write("message_timestamp=" + "$_message_timestamp" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Room copyWith({String? room_name, String? creator_id, bool? isGroup, String? message_sender, String? latest_message, String? message_type, String? message_timestamp, List<Message>? contents, List<RoomUser>? members}) {
    return Room._internal(
      id: id,
      room_name: room_name ?? this.room_name,
      creator_id: creator_id ?? this.creator_id,
      isGroup: isGroup ?? this.isGroup,
      message_sender: message_sender ?? this.message_sender,
      latest_message: latest_message ?? this.latest_message,
      message_type: message_type ?? this.message_type,
      message_timestamp: message_timestamp ?? this.message_timestamp,
      contents: contents ?? this.contents,
      members: members ?? this.members);
  }
  
  Room copyWithModelFieldValues({
    ModelFieldValue<String?>? room_name,
    ModelFieldValue<String?>? creator_id,
    ModelFieldValue<bool>? isGroup,
    ModelFieldValue<String?>? message_sender,
    ModelFieldValue<String?>? latest_message,
    ModelFieldValue<String?>? message_type,
    ModelFieldValue<String?>? message_timestamp,
    ModelFieldValue<List<Message>?>? contents,
    ModelFieldValue<List<RoomUser>?>? members
  }) {
    return Room._internal(
      id: id,
      room_name: room_name == null ? this.room_name : room_name.value,
      creator_id: creator_id == null ? this.creator_id : creator_id.value,
      isGroup: isGroup == null ? this.isGroup : isGroup.value,
      message_sender: message_sender == null ? this.message_sender : message_sender.value,
      latest_message: latest_message == null ? this.latest_message : latest_message.value,
      message_type: message_type == null ? this.message_type : message_type.value,
      message_timestamp: message_timestamp == null ? this.message_timestamp : message_timestamp.value,
      contents: contents == null ? this.contents : contents.value,
      members: members == null ? this.members : members.value
    );
  }
  
  Room.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _room_name = json['room_name'],
      _creator_id = json['creator_id'],
      _isGroup = json['isGroup'],
      _message_sender = json['message_sender'],
      _latest_message = json['latest_message'],
      _message_type = json['message_type'],
      _message_timestamp = json['message_timestamp'],
      _contents = json['contents'] is List
        ? (json['contents'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => Message.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _members = json['members'] is List
        ? (json['members'] as List)
          .where((e) => e?['serializedData'] != null)
          .map((e) => RoomUser.fromJson(new Map<String, dynamic>.from(e['serializedData'])))
          .toList()
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'room_name': _room_name, 'creator_id': _creator_id, 'isGroup': _isGroup, 'message_sender': _message_sender, 'latest_message': _latest_message, 'message_type': _message_type, 'message_timestamp': _message_timestamp, 'contents': _contents?.map((Message? e) => e?.toJson()).toList(), 'members': _members?.map((RoomUser? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'room_name': _room_name,
    'creator_id': _creator_id,
    'isGroup': _isGroup,
    'message_sender': _message_sender,
    'latest_message': _latest_message,
    'message_type': _message_type,
    'message_timestamp': _message_timestamp,
    'contents': _contents,
    'members': _members,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RoomModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RoomModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ROOM_NAME = amplify_core.QueryField(fieldName: "room_name");
  static final CREATOR_ID = amplify_core.QueryField(fieldName: "creator_id");
  static final ISGROUP = amplify_core.QueryField(fieldName: "isGroup");
  static final MESSAGE_SENDER = amplify_core.QueryField(fieldName: "message_sender");
  static final LATEST_MESSAGE = amplify_core.QueryField(fieldName: "latest_message");
  static final MESSAGE_TYPE = amplify_core.QueryField(fieldName: "message_type");
  static final MESSAGE_TIMESTAMP = amplify_core.QueryField(fieldName: "message_timestamp");
  static final CONTENTS = amplify_core.QueryField(
    fieldName: "contents",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Message'));
  static final MEMBERS = amplify_core.QueryField(
    fieldName: "members",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'RoomUser'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Room";
    modelSchemaDefinition.pluralName = "Rooms";
    
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
      key: Room.ROOM_NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Room.CREATOR_ID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Room.ISGROUP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Room.MESSAGE_SENDER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Room.LATEST_MESSAGE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Room.MESSAGE_TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Room.MESSAGE_TIMESTAMP,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Room.CONTENTS,
      isRequired: false,
      ofModelName: 'Message',
      associatedKey: Message.ROOM_ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Room.MEMBERS,
      isRequired: false,
      ofModelName: 'RoomUser',
      associatedKey: RoomUser.ROOM
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

class _RoomModelType extends amplify_core.ModelType<Room> {
  const _RoomModelType();
  
  @override
  Room fromJson(Map<String, dynamic> jsonData) {
    return Room.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Room';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Room] in your schema.
 */
class RoomModelIdentifier implements amplify_core.ModelIdentifier<Room> {
  final String id;

  /** Create an instance of RoomModelIdentifier using [id] the primary key. */
  const RoomModelIdentifier({
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
  String toString() => 'RoomModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RoomModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}