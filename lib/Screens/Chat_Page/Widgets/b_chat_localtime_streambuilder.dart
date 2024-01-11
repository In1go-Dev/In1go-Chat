import 'package:app_1gochat/Screens/Chat_Page/Widgets/c_chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class ChatLocalTimeStreamBuilder extends ConsumerWidget {
  const ChatLocalTimeStreamBuilder({super.key, required this.username, required this.currentUserId, required this.recipient, required this.scrollController});

  final String username;
  final String recipient;
  final String currentUserId;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<String>(
      stream: getLocalTimeZone(),
      builder:(context, result) {
        if(result.hasData && result.data!.isNotEmpty) {

          return LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: ChatList(
                  username: username,
                  currentUserId: currentUserId,
                  recipient: recipient,
                  currentTimeZone: result.data!,
                  scrollController: scrollController,
                )
              );
            }
          );
        }

        else if(result.hasError) {
          return const SizedBox.expand(
            child: Center(
              child: Text('There was an error in the loading of data'),
            )
          );
        }

        return const SizedBox.expand();
      }
    );
  }

  Stream<String> getLocalTimeZone() async* {
    String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    yield currentTimeZone;
  }
}