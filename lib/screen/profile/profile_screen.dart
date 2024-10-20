import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:honzuki/http/api.dart';
import 'package:honzuki/screen/profile/profile_provider.dart';
import 'package:honzuki/screen/profile/switch_card.dart';
import 'package:honzuki/screen/profile/tap_card.dart';
import 'package:honzuki/theme/extend.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(configProvider);
    final profile = ref.watch(profileProvider);
    useEffect(() {
      Future(() {
        API.getUserInfo(ref);
      });
      return null;
    }, []);
    var backgroundColor =
        Theme.of(context).extension<ExtendColors>()!.elevationBackground;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: '返回',
            onPressed: () {
              context.pop();
            },
          ),
          backgroundColor: backgroundColor,
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
                child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: TapCard(
                      title: profile.nickname!,
                      subtitle: "${profile.rank!}\t/\t${profile.score!}积分",
                      onTap: () {
                        API.getUserSign(ref);
                      },
                      trailing: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.water_drop,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ))),
              SliverToBoxAdapter(
                  child: SwitchCard(
                title: "繁体中文",
                subtitle: "切换到繁体中文（注意！这会清除你的书籍缓存）",
                value: config.zhHant,
                onChanged: (value) {
                  // 添加一个微小的延时，避免重构时引起的闪烁掉帧
                  Future.delayed(const Duration(milliseconds: 120)).then((_) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(zhHant: value));
                  });
                  clearCache();
                },
              )),
              SliverToBoxAdapter(
                  child: SwitchCard(
                title: "颜色跟随",
                subtitle: "根据系统模式自动打开或关闭暗色主题",
                value: config.autoDarkMode,
                onChanged: (value) {
                  // 添加一个微小的延时，避免重构时引起的闪烁掉帧
                  Future.delayed(const Duration(milliseconds: 120)).then((_) {
                    ref
                        .read(configProvider.notifier)
                        .update(config.copyWith(autoDarkMode: value));
                  });
                },
              )),
              if (!config.autoDarkMode)
                SliverToBoxAdapter(
                    child: SwitchCard(
                  title: "深色模式",
                  subtitle: "也许能让你熬夜的时候舒适一点",
                  value: config.isDarkMode,
                  onChanged: (value) {
                    // 添加一个微小的延时，避免重构时引起的闪烁掉帧
                    Future.delayed(const Duration(milliseconds: 120)).then((_) {
                      ref
                          .read(configProvider.notifier)
                          .update(config.copyWith(isDarkMode: value));
                    });
                  },
                )),
              SliverToBoxAdapter(
                  child: SwitchCard(
                title: "壁纸主题",
                subtitle: "Material You主题可根据当前壁纸派生自定义配色主题（限Android12+）",
                value: config.dynamicColor,
                onChanged: (value) {
                  // 添加一个微小的延时，避免重构时引起的闪烁掉帧
                  Future.delayed(const Duration(milliseconds: 120)).then((_) =>
                      ref
                          .read(configProvider.notifier)
                          .update(config.copyWith(dynamicColor: value)));
                },
              )),
              if (!config.dynamicColor)
                SliverToBoxAdapter(
                    child: TapCard(
                  title: "颜色样式",
                  subtitle: "选择一组你喜欢的颜色组合，将之应用到APP内",
                  onTap: () {
                    GoRouter.of(context).push("/palette");
                  },
                  trailing: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.palette,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )),
              SliverToBoxAdapter(
                  child: TapCard(
                      title: "清除缓存",
                      subtitle: "移除图书的章节和目录缓存（这理应不会移除你的阅读进度）",
                      onTap: () {
                        clearCache();
                      },
                      trailing: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ))),
              SliverToBoxAdapter(
                  child: TapCard(
                      title: "意见反馈",
                      subtitle: "无论你有什么意见和建议，都欢迎找我聊聊。当然，这不代表一定会被实现。",
                      onTap: () {
                        launchUrl(Uri.parse(
                            'https://github.com/pugaizai/honzuki/issues/new'));
                      },
                      trailing: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.lightbulb,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ))),
              SliverToBoxAdapter(
                  child: TapCard(
                title: "退出登录",
                titleColor: Theme.of(context).colorScheme.error,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                subtitle: "你的历史数据会被保留，除非额外点一下清除缓存。",
                subTitleColor:
                    Theme.of(context).colorScheme.error.withOpacity(1),
                onTap: () async {
                  Directory appDataDir = await getApplicationSupportDirectory();
                  final cookieJar =
                      PersistCookieJar(storage: FileStorage(appDataDir.path));
                  cookieJar.deleteAll();
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context).go("/login");
                },
                trailing: IconButton.filled(
                    onPressed: () async {
                      Directory appDataDir =
                          await getApplicationSupportDirectory();
                      final cookieJar = PersistCookieJar(
                          storage: FileStorage(appDataDir.path));
                      cookieJar.deleteAll();
                      // ignore: use_build_context_synchronously
                      GoRouter.of(context).go("/login");
                    },
                    style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error),
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.onError,
                    )),
              )),
            ]))));
  }
}
