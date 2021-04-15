import 'package:ch9_customscrollview_slivers/widgets/custom_appbar.dart';
import 'package:ch9_customscrollview_slivers/widgets/persistent_header.dart';
import 'package:ch9_customscrollview_slivers/widgets/sliver_app_bar.dart';
import 'package:ch9_customscrollview_slivers/widgets/sliver_grid.dart';
import 'package:ch9_customscrollview_slivers/widgets/sliver_list.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double top = 0;
  bool opacity = false;
  BehaviorSubject<bool> _opacitySubject = BehaviorSubject<bool>.seeded(false);

  @override
  void initState() {
    super.initState();
  }

  void _onCollapsedAppbar(bool isCollapsed) {
    if (isCollapsed) {
      _opacitySubject.add(true);
    } else {
      _opacitySubject.add(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _opacitySubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomAppBar(),
      //   child: CustomScrollView(
      //     slivers: [
      //       SliverAppBarWidget(onCollapsedAppbar: _onCollapsedAppbar),
      //       StreamBuilder(
      //         stream: _opacitySubject.stream,
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             bool _opacity = snapshot.data as bool;
      //             return SliverAnimatedOpacity(
      //               duration: Duration(milliseconds: 300),
      //               opacity: _opacity ? 1.0 : 0.0,
      //               sliver: _opacity ? SliverPersistentHeader(
      //                 pinned: true,
      //                 delegate: PersistentHeader(
      //                     widget: Text("Balance"),
      //                 ),
      //               ) : SliverToBoxAdapter(
      //                 child: Container(),
      //               ),
      //             );
      //           }
      //           return SliverToBoxAdapter(
      //             child: Container(),
      //           );
      //         }
      //       ),
      //       const SliverListWidget(),
      //       const SliverGridWidget(),
      //     ],
      //   ),
      ),
    );
  }
}
