import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:honzuki/screen/reader/reader_provider.dart';

class MenuBottom extends StatefulHookConsumerWidget {
  const MenuBottom({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuBottomState();
}

class _MenuBottomState extends ConsumerState<MenuBottom>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readerMenuStateProvider);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    useEffect(() {
      if (state.bottomBarHeight == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(readerMenuStateProvider.notifier).setBottomBarHeight(
              context.findRenderObject()!.paintBounds.size.height);
        });
      }
      return null;
    }, [state]);

    return AnimatedPositioned(
      bottom: state.menuBottomVisible ? 0 : -state.bottomBarHeight,
      left: 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(bottom: bottomPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Wrap(
            children: [
              Row(children: [
                Flexible(
                    child: Center(
                  child: IconButton(
                      onPressed: () {
                        ref.read(readerMenuStateProvider.notifier).dispatch(
                            menuTopVisible: ref
                                .read(readerMenuStateProvider)
                                .menuCatalogVisible,
                            menuCatalogVisible: !ref
                                .read(readerMenuStateProvider)
                                .menuCatalogVisible,
                            menuThemeVisible: false,
                            menuTextVisible: false,
                            menuConfigVisible: false);
                        // ref
                        //     .read(readerMenuStateProvider.notifier)
                        //     .toggleBottomAndTop();
                      },
                      icon: Icon(Icons.menu_outlined)),
                )),
                Flexible(
                    child: Center(
                  child: IconButton(
                      onPressed: () {
                        ref.read(readerMenuStateProvider.notifier).dispatch(
                            menuTopVisible: ref
                                .read(readerMenuStateProvider)
                                .menuThemeVisible,
                            menuCatalogVisible: false,
                            menuThemeVisible: !ref
                                .read(readerMenuStateProvider)
                                .menuThemeVisible,
                            menuTextVisible: false,
                            menuConfigVisible: false);
                      },
                      icon: Icon(Icons.palette_outlined)),
                )),
                Flexible(
                    child: Center(
                  child: IconButton(
                      onPressed: () {
                        ref.read(readerMenuStateProvider.notifier).dispatch(
                            menuTopVisible: ref
                                .read(readerMenuStateProvider)
                                .menuTextVisible,
                            menuCatalogVisible: false,
                            menuThemeVisible: false,
                            menuTextVisible: !ref
                                .read(readerMenuStateProvider)
                                .menuTextVisible,
                            menuConfigVisible: false);
                      },
                      icon: Icon(Icons.font_download_outlined)),
                )),
                Flexible(
                    child: Center(
                  child: IconButton(
                      onPressed: () {
                        ref.read(readerMenuStateProvider.notifier).dispatch(
                            menuTopVisible: ref
                                .read(readerMenuStateProvider)
                                .menuConfigVisible,
                            menuCatalogVisible: false,
                            menuThemeVisible: false,
                            menuTextVisible: false,
                            menuConfigVisible: !ref
                                .read(readerMenuStateProvider)
                                .menuConfigVisible);
                      },
                      icon: Icon(Icons.settings_outlined)),
                )),
              ])
            ],
          )),
    );
  }
}
