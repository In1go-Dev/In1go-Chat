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


/** This is an auto generated class representing the Message type in your schema. */
class Message extends amplify_core.Model {
  static const classType = const _MessageModelType();
  final String id;
  final String? _content;
  final String? _sender_id;
  final String? _sender_name;
  final String? _message_type;
  final String? _attachment;
  final int? _isDelivered;
  final bool? _isDeleted;
  final String? _timestamp;
  final String? _room_id;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MessageModelIdentifier get modelIdentifier {
      return MessageModelIdentifier(
        id: id
      );
  }
  
  String? get content {
    return _content;
  }
  
  String get sender_id {
    try {
      return _sender_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get sender_name {
    try {
      return _sender_name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get message_type {
    try {
      return _message_type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get attachment {
    return _attachment;
  }
  
  int get isDelivered {
    try {
      return _isDelivered!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isDeleted {
    try {
      return _isDeleted!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get room_id {
    try {
      return _room_id!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Message._internal({required this.id, content, required sender_id, required sender_name, required message_type, attachment, required isDelivered, required isDeleted, required timestamp, required room_id, createdAt, updatedAt}): _content = content, _sender_id = sender_id, _sender_name = sender_name, _message_type = message_type, _attachment = attachment, _isDelivered = isDelivered, _isDeleted = isDeleted, _timestamp = timestamp, _room_id = room_id, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Message({String? id, String? content, required String sender_id, required String sender_name, required String message_type, String? attachment, required int isDelivered, required bool isDeleted, required String timestamp, required String room_id}) {
    return Message._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      content: content,
      sender_id: sender_id,
      sender_name: sender_name,
      message_type: message_type,
      attachment: attachment,
      isDelivered: isDelivered,
      isDeleted: isDeleted,
      timestamp: timestamp,
      room_id: room_id);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
      id == other.id &&
      _content == other._content &&
      _sender_id == other._sender_id &&
      _sender_name == other._sender_name &&
      _message_type == other._message_type &&
      _attachment == other._attachment &&
      _isDelivered == other._isDelivered &&
      _isDeleted == other._isDeleted &&
      _timestamp == other._timestamp &&
      _room_id == other._room_id;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Message {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("sender_id=" + "$_sender_id" + ", ");
    buffer.write("sender_name=" + "$_sender_name" + ", ");
    buffer.write("message_type=" + "$_message_type" + ", ");
    buffer.write("attachment=" + "$_attachment" + ", ");
    buffer.write("isDelivered=" + (_isDelivered != null ? _isDelivered!.toString() : "null") + ", ");
    buffer.write("isDeleted=" + (_isDeleted != null ? _isDeleted!.toString() : "null") + ", ");
    buffer.write("timestamp=" + "$_timestamp" + ", ");
    buffer.write("room_id=" + "$_room_id" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Message copyWith({String? content, String? sender_id, String? sender_name, String? message_type, String? attachment, int? isDelivered, bool? isDeleted, String? timestamp, String? room_id}) {
    return Message._internal(
      id: id,
      content: content ?? this.content,
      sender_id: sender_id ?? this.sender_id,
      sender_name: sender_name ?? this.sender_name,
      message_type: message_type ?? this.message_type,
      attachment: attachment ?? this.attachment,
      isDelivered: isDelivered ?? this.isDelivered,
      isDeleted: isDeleted ?? this.isDeleted,
      timestamp: timestamp ?? this.timestamp,
      room_id: room_id ?? this.room_id);
  }
  
  Message copyWithModelFieldValues({
    ModelFieldValue<String?>? content,
    ModelFieldValue<String>? sender_id,
    ModelFieldValue<String>? sender_name,
    ModelFieldValue<String>? message_type,
    ModelFieldValue<String?>? attachment,
    ModelFieldValue<int>? isDelivered,
    ModelFieldValue<bool>? isDeleted,
    ModelFieldValue<String>? timestamp,
    ModelFieldValue<String>? room_id
  }) {
    return Message._internal(
      id: id,
      content: content == null ? this.content : content.value,
      sender_id: sender_id == null ? this.sender_id : sender_id.value,
      sender_name: sender_name == null ? this.sender_name : sender_name.value,
      message_type: message_type == null ? this.message_type : message_type.value,
      attachment: attachment == null ? this.attachment : attachment.value,
      isDelivered: isDelivered == null ? this.isDelivered : isDelivered.value,
      isDeleted: isDeleted == null ? this.isDeleted : isDeleted.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      room_id: room_id == null ? this.room_id : room_id.value
    );
  }
  
  Message.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _content = json['content'],
      _sender_id = json['sender_id'],
      _sender_name = json['sender_name'],
      _message_type = json['message_type'],
      _attachment = json['attachment'],
      _isDelivered = (json['isDelivered'] as num?)?.toInt(),
      _isDeleted = json['isDeleted'],
      _timestamp = json['timestamp'],
      _room_id = json['room_id'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'content': _content, 'sender_id': _sender_id, 'sender_name': _sender_name, 'message_type': _message_type, 'attachment': _attachment, 'isDelivered': _isDelivered, 'isDeleted': _isDeleted, 'timestamp': _timestamp, 'room_id': _room_id, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'content': _content,
    'sender_id': _sender_id,
    'sender_name': _sender_name,
    'message_type': _message_type,
    'attachment': _attachment,
    'isDelivered': _isDelivered,
    'isDeleted': _isDeleted,
    'timestamp': _timestamp,
    'room_id': _room_id,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MessageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final SENDER_ID = amplify_core.QueryField(fieldName: "sender_id");
  static final SENDER_NAME = amplify_core.QueryField(fieldName: "sender_name");
  static final MESSAGE_TYPE = amplify_core.QueryField(fieldName: "message_type");
  static final ATTACHMENT = amplify_core.QueryField(fieldName: "attachment");
  static final ISDELIVERED = amplify_core.QueryField(fieldName: "isDelivered");
  static final ISDELETED = amplify_core.QueryField(fieldName: "isDeleted");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final ROOM_ID = amplify_core.QueryField(fieldName: "room_id");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Message";
    modelSchemaDefinition.pluralName = "Messages";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["room_id"], name: "byRoom")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.CONTENT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.SENDER_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.SENDER_NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.MESSAGE_TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.ATTACHMENT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.ISDELIVERED,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.ISDELETED,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.TIMESTAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Message.ROOM_ID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _MessageModelType extends amplify_core.ModelType<Message> {
  const _MessageModelType();
  
  @override
  Message fromJson(Map<String, dynamic> jsonData) {
    return Message.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Message';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Message] in your schema.
 */
class MessageModelIdentifier implements amplify_core.ModelIdentifier<Message> {
  final String id;

  /** Create an instance of MessageModelIdentifier using [id] the primary key. */
  const MessageModelIdentifier({
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
  String toString() => 'MessageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MessageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}