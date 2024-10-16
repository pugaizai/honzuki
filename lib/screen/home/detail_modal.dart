import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:honzuki/providers/download_provider.dart';
import 'package:honzuki/screen/home/home_provider.dart';

class DetailModal extends HookConsumerWidget {
  const DetailModal(this.controller, this.bookItem, {super.key});
  final BookItem bookItem;
  final FlashController<Object?> controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = bookDownloaderProvider(bookItem.aid);
    final downloader = ref.watch(provider);
    final downloadProgress = useFuture(
        useMemoized(() => downloader.progress, [downloader]),
        initialData: "缓存");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Text(
            bookItem.name,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Text(
              "详情",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            tileColor: Theme.of(context).colorScheme.surface,
            trailing: Icon(
              Icons.details,
            ),
            onTap: () {
              GoRouter.of(context).push("/detail", extra: bookItem);
              controller.dismiss();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              downloadProgress.data!,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            tileColor: Theme.of(context).colorScheme.surface,
            trailing: Icon(
              Icons.download,
            ),
            onTap: () {
              ref.read(provider.notifier).download(bookItem.aid).then((value) {
                if (value == true) {
                  controller.dismiss();
                }
              });
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              "删除",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error),
            ),
            tileColor: Theme.of(context).colorScheme.surface,
            trailing: Icon(
              Icons.delete,
            ),
            onTap: () {
              ref.read(myBooksProvider.notifier).delBook(bookItem.aid);
              controller.dismiss();
            },
          ),
        )
      ],
    );
  }
}
