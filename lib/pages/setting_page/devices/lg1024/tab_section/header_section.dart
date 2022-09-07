import 'package:flutter/material.dart';

import '../../../../../config/config.dart';
import '../../../../../routes/route_path.dart';

class TabItem {
  final IconData icon;
  final String text;

  TabItem({required this.icon, required this.text});
}

class HeaderSection extends StatelessWidget {
  final List<TabItem> tabs;
  final int activeIndex;
  final Function(int activeIndeex) onChange;
  const HeaderSection({Key? key, required this.tabs, required this.activeIndex, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 80, right: 0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Config.borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => RoutePath.pushHomePage(),
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios),
                  Text('Back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          Text(tabs[activeIndex].text ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          Row(
            children: [
              for (int index = 0; index < tabs.length; index++)
                MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onChange(index),
                      child: Container(
                        width: 70,
                        margin: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: index == activeIndex ? Colors.grey[300] : null,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              tabs[index].icon,
                              color: index == activeIndex ? Colors.black : Colors.grey,
                            ),
                            Text(
                              tabs[index].text,
                              style: TextStyle(color: index == activeIndex ? Colors.black : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ))
            ],
          )
        ],
      ),
    );
  }
}
