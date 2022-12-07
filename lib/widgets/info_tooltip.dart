import 'package:flutter/material.dart';

class InfoTooltip extends StatefulWidget {
  final String message;
  const InfoTooltip({super.key, required this.message});

  @override
  State<InfoTooltip> createState() => _InfoTooltipState();
}

class _InfoTooltipState extends State<InfoTooltip> {
  final tooltip = GlobalKey<TooltipState>();

  @override
  void dispose() {
    tooltip.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: tooltip,
      message: widget.message,
      triggerMode: TooltipTriggerMode.manual,
      showDuration: const Duration(seconds: 5),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(2),
        child: InkWell(
          onTap: () {
            tooltip.currentState?.ensureTooltipVisible();
          },
          child: const Icon(
            Icons.question_mark_rounded,
            size: 12,
          ),
        ),
      ),
    );
  }
}
