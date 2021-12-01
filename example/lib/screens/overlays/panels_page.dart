import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../helpers/page.dart';
import '../../helpers/qbutton.dart';

class PanelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                QButton('Bottom', () {
                  QPanel(
                    child: Column(
                      children: [Text('Hi')],
                    ),
                  ).show();
                }),
                QButton('Top', () {
                  QPanel(
                          child: Column(
                            children: [
                              Text('Hi'),
                            ],
                          ),
                          position: QPanelPosition.Top)
                      .show();
                }),
                QButton('Right', () {
                  QPanel(
                          child: Column(
                            children: [
                              Text('Hi'),
                            ],
                          ),
                          position: QPanelPosition.Right)
                      .show();
                }),
                QButton('Left', () {
                  QPanel(
                          child: Column(
                            children: [
                              Text('Hi'),
                            ],
                          ),
                          position: QPanelPosition.Left)
                      .show();
                }),
              ],
            ))));
  }
}
