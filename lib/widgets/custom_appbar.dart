import 'dart:math';

import 'package:ch9_customscrollview_slivers/widgets/persistent_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final double maxHeight = 200;
  final double minHeight = 50;
  final double marginItemInSliversBar = 20;
  BehaviorSubject<bool> _isCollapsed = BehaviorSubject<bool>.seeded(false);

  ScrollController _controller = ScrollController();

  void _onCollapsed(bool isCollapsed) {
    _isCollapsed.add(isCollapsed);
  }

  @override
  void dispose() {
    super.dispose();
    _isCollapsed.close();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            _snapAppbar();
            return false;
          },
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: [
              SliverAppBar(
                pinned: true,
                stretch: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: Header(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  maxWidth: maxWidth,
                  marginItemInSliversBar: marginItemInSliversBar,
                  onCollapsed: _onCollapsed,
                ),
                expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
              ),
              StreamBuilder(
                  stream: _isCollapsed.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bool _opacity = snapshot.data as bool;
                      return SliverAnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _opacity ? 1.0 : 0.0,
                        sliver: _opacity
                            ? SliverPersistentHeader(
                                pinned: true,
                                delegate: PersistentHeader(
                                  widget: Text("Balance"),
                                ),
                              )
                            : SliverToBoxAdapter(
                                child: Container(),
                              ),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Text("Index $index");
                  },
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    "List is empty",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _snapAppbar() {
    final scrollDistance = maxHeight - minHeight;

    if (_controller.offset > 0 && _controller.offset < scrollDistance) {
      final double snapOffset =
          _controller.offset / scrollDistance > 0.5 ? scrollDistance : 0;

      print(snapOffset);

      Future.microtask(() => _controller.animateTo(snapOffset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn));
    }
  }
}

class Header extends StatefulWidget {
  final double maxHeight;
  final double minHeight;
  final double maxWidth;
  final double marginItemInSliversBar;
  final Function(bool) onCollapsed;

  Header(
      {Key key,
      this.maxHeight,
      this.minHeight,
      this.maxWidth,
      this.marginItemInSliversBar,
      this.onCollapsed})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final int sizeIconMaximum = 50;

  final int sizeIconMinimum = 30;

  final int sizeAvatar = 50;

  final int paddingContentTop = 8;

  BehaviorSubject<bool> _onCollapsed = BehaviorSubject.seeded(true);

  @override
  void dispose() {
    super.dispose();
    _onCollapsed.close();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);

        _onCollapsed.add(constraints.maxHeight == 56);
        widget.onCollapsed(constraints.maxHeight == 56);

        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(
                  IntTween(begin: 0, end: 30).evaluate(animation).toDouble(),
                ),
              ),
              child: StreamBuilder(
                stream: _onCollapsed.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                  bool collapsed = snapshot.data;
                    return collapsed ? Image(
                      image: AssetImage('assets/images/app_bar_collapsed.png'),
                      fit: BoxFit.fill,
                    ) : Image(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill,
                    );
                  }
                  return Container();
                }
              ),
            ),
            _buildTop(animation),
            _buildFeature(animation),
          ],
        );
      },
    );
  }

  Padding _buildFeature(Animation<double> animation) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              IntTween(begin: 0, end: 20).evaluate(animation).toDouble()),
      child: Align(
          alignment: AlignmentTween(
                  begin: Alignment.topLeft, end: Alignment.bottomCenter)
              .evaluate(animation),
          child: Container(
            transform: Matrix4.translationValues(0,
                IntTween(begin: 0, end: 30).evaluate(animation).toDouble(), 0),
            margin: EdgeInsets.only(
                left: IntTween(begin: sizeAvatar, end: 0)
                    .evaluate(animation)
                    .toDouble(),
                top: IntTween(
                        begin: ((sizeAvatar +
                                paddingContentTop -
                                sizeIconMinimum) ~/
                            2),
                        end: 0)
                    .evaluate(animation)
                    .toDouble()),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(40, 45)),
                color: ColorTween(begin: null, end: Colors.green)
                    .evaluate(animation)),
            width: IntTween(
                    begin: 3 * sizeIconMinimum + 10 * 3, end: widget.maxWidth.toInt())
                .evaluate(animation)
                .toDouble(),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.ac_unit,
                        size: IntTween(
                                begin: sizeIconMinimum, end: sizeIconMaximum)
                            .evaluate(animation)
                            .toDouble(),
                        color: ColorTween(begin: Colors.white, end: Colors.blue)
                            .evaluate(animation),
                      ),
                      Text(
                        "Feature 1",
                        style: TextStyleTween(
                                begin: TextStyle(fontSize: 0),
                                end: TextStyle(fontSize: 18))
                            .evaluate(animation),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.ac_unit,
                        size: IntTween(
                                begin: sizeIconMinimum, end: sizeIconMaximum)
                            .evaluate(animation)
                            .toDouble(),
                      ),
                      Text(
                        "Feature 2",
                        style: TextStyleTween(
                                begin: TextStyle(fontSize: 0),
                                end: TextStyle(fontSize: 18))
                            .evaluate(animation),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.ac_unit,
                        size: IntTween(
                                begin: sizeIconMinimum, end: sizeIconMaximum)
                            .evaluate(animation)
                            .toDouble(),
                      ),
                      Text(
                        "Feature 3",
                        style: TextStyleTween(
                                begin: TextStyle(fontSize: 0),
                                end: TextStyle(fontSize: 18))
                            .evaluate(animation),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Align _buildTop(Animation<double> animation) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(paddingContentTop.toDouble()),
        child: Row(
          children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    "https://icdn.dantri.com.vn/thumb_w/640/2019/06/09/hot-girl-nong-nghiepdocx-1560089042698.jpeg")),
            SizedBox(
              width: 20,
            ),
            Text(
              "Jonh Cloe",
              style: TextStyleTween(
                      begin: TextStyle(fontSize: 0),
                      end: TextStyle(fontSize: 18))
                  .evaluate(animation),
            )
          ],
        ),
      ),
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - widget.minHeight) / (widget.maxHeight - widget.minHeight);

    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;

    return expandRatio;
  }
}
