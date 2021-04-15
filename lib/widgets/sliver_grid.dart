import 'package:flutter/material.dart';

class SliverGridWidget extends StatelessWidget {

  const SliverGridWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.child_friendly, size: 48, color: Colors.amber,),
                    Divider(),
                    Text('Grid ${index + 1}')
                  ],
                ),
              );
            }
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
      ),
    );
  }
}
