import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Used in Bottom Navigation Menu
final pageindex = StateProvider.autoDispose<int>((ref) => 0);

//Used in Search Operations
final searchInput = StateProvider.autoDispose<String>((ref) => '');
final searchField = StateProvider.autoDispose<TextEditingController>((ref) => TextEditingController());

//Used for storing passwords in local usage
final secureStorage = StateProvider.autoDispose<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

//Used for file attachments
final attachmentFile = StateProvider.autoDispose<FilePickerResult?>((ref) => null);