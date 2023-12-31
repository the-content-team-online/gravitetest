import 'dart:async';

import 'package:cash/aatkit/aatkit_banner.dart';
import 'package:cash/aatkit/aatkit_binding.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final AATKitBinding _aatKitBinding = AATKitBinding();

  final Duration stickyBannerReloadInterval = Duration(seconds: 30);
  Widget? _banner;
  bool _showBanner = false;

  List<String> _rewardedAdViews = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                _aatKitBinding
                    .initAATKit()
                    .then((value) => print("[DEBUG] initAATKit success"))
                    .onError((error, stackTrace) {
                  print("[DEBUG] initAATKit failed");
                  print(
                    "[DEBUG] initAATKit\nerr: $error\nstackTrace: $stackTrace",
                  );
                });
              },
              child: const Text("Init AATKit"),
            ),
            OutlinedButton(
              onPressed: () {
                _aatKitBinding.firstBannerLoaded = firstBannerLoaded;

                _aatKitBinding
                    .createBannerCache()
                    .then((value) => print("[DEBUG] createBannerCache success"))
                    .onError((error, stackTrace) {
                  print("[DEBUG] createBannerCache failed");
                  print(
                    "[DEBUG] createBannerCache\nerr: $error\nstackTrace: $stackTrace",
                  );
                });
              },
              child: const Text("Create banner cache"),
            ),
            // if banner is SHOWN
            if (_showBanner)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showBanner = false;
                  });
                },
                child: const Text("Hide banner"),
              ),
            if (_showBanner && _banner != null) _banner!,
            // if banner is NOT SHOWN
            if (!_showBanner)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _showBanner = true;
                  });
                },
                child: const Text("Show banner"),
              ),

            const SizedBox(height: 30),

            OutlinedButton(
              onPressed: () {
                _aatKitBinding.onUserEarnedIncentive = onUserEarnedIncentive;
                _aatKitBinding.createRewardedPlacement().then((value) {
                  print("[DEBUG] createRewardedPlacement success");
                  startRewardedAutoReload();
                }).onError((error, stackTrace) {
                  print(
                    "[DEBUG] createRewardedPlacement\nerr: $error\nstackTrace: $stackTrace",
                  );
                });
              },
              child: const Text("Create rewarded placement"),
            ),
            OutlinedButton(
              onPressed: () {
                _aatKitBinding.showRewarded().then((value) {
                  print("[DEBUG] showRewarded success");
                }).onError((error, stackTrace) {
                  print(
                    "[DEBUG] showRewarded\nerr: $error\nstackTrace: $stackTrace",
                  );
                });
              },
              child: const Text("Show rewarded ad"),
            ),
            Expanded(
              child: rewardedAdList(),
            ),
            // rewardedAdList(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aatKitBinding.destroyBannerCache();
    super.dispose();
  }

  Widget rewardedAdList() {
    print("[DEBUG] listing rewarded views, this be all: $_rewardedAdViews");

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _rewardedAdViews.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 30,
            color: index % 2 == 0 ? Colors.amberAccent : Colors.amber,
            child: Center(child: Text('Rewarded video view #${index + 1}')),
          );
        });
  }

  void startRewardedAutoReload() {
    _aatKitBinding.startRewardedAutoReload().then((value) {
      print("[DEBUG] startRewardedAutoReload success");
    }).onError((error, stackTrace) {
      print(
        "[DEBUG] startRewardedAutoReload\nerr: $error\nstackTrace: $stackTrace",
      );
    });
  }

  void onUserEarnedIncentive(AATKitReward reward) {
    print("[DEBUG] onUserEarnedIncentive"
        "placementName: ${reward.placementName} "
        "rewardName: ${reward.rewardName} "
        "rewardValue: ${reward.rewardValue} ");

    setState(() {
      _rewardedAdViews.add(
        "${reward.rewardName} (${reward.rewardValue})",
      );
    });
  }

  void firstBannerLoaded() {
    print("[DEBUG] first banner loaded");
    _banner = AATKitBanner(key: UniqueKey());

    Timer.periodic(stickyBannerReloadInterval, (timer) {
      print("[DEBUG] reloading sticky banner");
      setState(() => _banner = AATKitBanner(key: UniqueKey()));
    });
  }
}
