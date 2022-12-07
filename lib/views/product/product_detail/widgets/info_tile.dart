import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.hideBorder = false,
    this.useColumn = false,
  });

  final String title;
  final String subtitle;
  final bool useColumn;
  final bool hideBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: hideBorder
              ? BorderSide.none
              : BorderSide(
                  width: 0.5,
                  color: Colors.grey.shade200,
                ),
        ),
      ),
      child: Visibility(
        visible: !useColumn,
        replacement: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontWeight: FontWeight.w200,
                color: Colors.black.withOpacity(0.8),
              ),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
              ),
            ),
            Expanded(
              child: Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
