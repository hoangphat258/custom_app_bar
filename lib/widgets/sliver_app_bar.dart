import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SliverAppBarWidget extends StatefulWidget {
  final Function(bool) onCollapsedAppbar;

  const SliverAppBarWidget({this.onCollapsedAppbar, Key key}) : super(key: key);

  @override
  _SliverAppBarWidgetState createState() => _SliverAppBarWidgetState();
}

class _SliverAppBarWidgetState extends State<SliverAppBarWidget> {
  double top = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: 90,
      forceElevated: true,
      expandedHeight: 200,
      backgroundColor: Colors.brown,
      pinned: true,
      // flexibleSpace: FlexibleSpaceBar(
      //   title: Text("abc"),
      // ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          top = constraints.biggest.height;
          top == 90 ? widget.onCollapsedAppbar(true) : widget.onCollapsedAppbar(false);
          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(16),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Parallax Effect'),
                      GestureDetector(
                        onTap: () => print("Tapped"),
                        child: Stack(
                          children: [
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: top == 90.0 ? 0.0 : 1.0,
                              child: Icon(Icons.favorite, color: Colors.red,),
                            ),
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: top == 90.0 ? 1.0 : 0.0,
                              child: Icon(Icons.error, color: Colors.green,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            background: Image(
              image: AssetImage('assets/images/desk.jpg'),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
