import 'dart:async';

import 'package:flutter/material.dart';
import 'package:volleyspeech/models/rate_action.dart';

class RateActionListTile extends StatefulWidget {
  final RateAction rateAction;
  final Duration deleteDuration;
  final void Function(RateAction) deleteItem;
  final void Function(RateAction) onTimeout;

  const RateActionListTile(
      {super.key,
      required this.rateAction,
      required this.deleteItem,
      required this.deleteDuration,
      required this.onTimeout});

  @override
  State<RateActionListTile> createState() => _RateActionListTileState();
}

class _RateActionListTileState extends State<RateActionListTile> {
  late Timer _timer;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      final elapsed = DateTime.now().difference(widget.rateAction.createdAt);
      setState(() {
        _progress =
            elapsed.inMilliseconds / widget.deleteDuration.inMilliseconds;
        if (_progress >= 1.0) {
          _timer.cancel();
          widget.onTimeout(widget.rateAction);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.rateAction.action ?? 'Action ERROR',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            'Players: ${(widget.rateAction.playerNumbers ?? []).join(', ')}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.rateAction.rating == 1
                    ? Icons.plus_one
                    : widget.rateAction.rating == 0
                        ? Icons.numbers
                        : Icons.exposure_minus_1,
                size: 30.0,
                color: widget.rateAction.rating == 1
                    ? Colors.green
                    : widget.rateAction.rating == 0
                        ? Colors.black54
                        : Colors.red,
              ),
              IconButton.outlined(
                  onPressed: () => widget.deleteItem(widget.rateAction),
                  icon: const Icon(Icons.delete),
              )
            ],
          ),
          onTap: () => widget.onTimeout(widget.rateAction),
        ),
        LinearProgressIndicator(value: _progress),
      ],
    );
  }
}
