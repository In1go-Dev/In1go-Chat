import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 8, left: 20, right: 20),
      child: TextFormField(
        controller: ref.watch(searchField),
        enabled: true,
        decoration: InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0)
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0)
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: (ref.read(searchField).text.isNotEmpty) ? IconButton(
            onPressed: () {
              if (ref.read(searchField).text.isNotEmpty) {
                ref.read(searchInput.notifier).state = '';
                setState(() => ref.read(searchField.notifier).state.clear());
              }
            },
            icon: const Icon(Icons.cancel, color: Colors.grey)
          ) : null
        ),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onChanged: (value) {
          if(context.mounted) {
            ref.read(searchField.notifier).state.text = value;
            ref.read(searchInput.notifier).state = value;
            setState(() {});
          }
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus();
          //ref.read(searchInput.notifier).state = value;
        }
        //onTapOutside: (event) => FocusScope.of(context).unfocus()
      )
    );
  }
}