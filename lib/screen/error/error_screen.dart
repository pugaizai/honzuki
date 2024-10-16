import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ErrorScreen extends StatefulHookConsumerWidget {
  const ErrorScreen({required this.err, super.key});
  final String err;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends ConsumerState<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 128),
            child: Text(
              "出错了",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.err,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 16),
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text("返回首页")),
    );
  }
}
