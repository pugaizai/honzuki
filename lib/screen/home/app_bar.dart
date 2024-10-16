import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:honzuki/http/api.dart';
import 'package:honzuki/service/navigation.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar(
      {super.key,
      required this.onSearchTap,
      required this.onAddTap,
      required this.onAvatarTap});

  final Function() onSearchTap;
  final Function() onAddTap;
  final Function() onAvatarTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = getColorScheme(context);

    useEffect(() {
      API.getUserInfo(ref);
      return null;
    }, []);
    return SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: 42,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: colorScheme.surfaceContainerHighest
                                .withOpacity(0.5)),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.person),
                              onPressed: () {
                                onAvatarTap();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                onSearchTap();
                              },
                            ),
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    child: GestureDetector(
                                      child: Text("搜索书名或作者",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: colorScheme.secondary
                                                  .withOpacity(0.8))),
                                      onTap: () {
                                        onSearchTap();
                                      },
                                    ))),
                            VerticalDivider(
                              thickness: 1.2,
                              indent: 8,
                              endIndent: 8,
                              color: colorScheme.secondary.withOpacity(0.1),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                onAddTap();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Divider(
                    color: colorScheme.secondary.withOpacity(0.05),
                    height: 1,
                  ),
                )
              ],
            )));
  }

  @override
  Size get preferredSize => const Size.fromHeight(71);
}
