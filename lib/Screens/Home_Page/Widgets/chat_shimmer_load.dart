import 'dart:async';

import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/retry_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingDisplay extends ConsumerStatefulWidget {
  const ShimmerLoadingDisplay({super.key, required this.retry});

  final VoidCallback retry;

  @override
  ConsumerState<ShimmerLoadingDisplay> createState() => _ShimmerLoadingDisplayState();
}

class _ShimmerLoadingDisplayState extends ConsumerState<ShimmerLoadingDisplay> {
  StreamController<bool>? _streamController;
  Stream<bool>? _timerStream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<bool>();
    _timerStream = _streamController?.stream;

    Timer(const Duration(minutes: 1), () {
      if (_streamController != null && !_streamController!.isClosed) {
        _streamController?.add(true);
      }
    });
  }

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _timerStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: 15,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder:(context, index) {
              return MaterialButton(
                onPressed: null,
                onLongPress: null,
                elevation: 0,
                padding: const EdgeInsets.all(0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    leading: const CircleAvatar(),
                    title:  Container(
                      width: 100,
                      height: 16.0,
                      color: Colors.white,
                    ),
                    subtitle:  Container(
                      width: 100,
                      height: 12.0,
                      color: Colors.white,
                    ),
                    trailing: (ref.watch(pageindex) == 0) ? Container(
                      width: 35,
                      height: 12.0,
                      color: Colors.white,
                    ) : null,
                  )
                )
              );
            }
          );
        }

        else {
          return Center(
            child: RetryDisplay(
              retry: widget.retry
            )
          );
        }
      }
    );
  }
}