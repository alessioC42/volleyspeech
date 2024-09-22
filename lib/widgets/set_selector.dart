import 'package:flutter/material.dart';

class SetSelector extends StatelessWidget {
  final int currentSet;
  final void Function(int) onSetChange;

  const SetSelector({super.key, required this.currentSet, required this.onSetChange});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Set'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  int setNumber = index + 1;
                  return RadioListTile<int>(
                    title: Text('Set $setNumber'),
                    value: setNumber,
                    groupValue: currentSet + 1,
                    onChanged: (int? value) {
                      if (value != null) {
                        onSetChange(value - 1);
                        Navigator.of(context).pop();
                      }
                    },
                  );
                }),
              ),
            );
          },
        );
      },
      child: Container(
          color: Theme.of(context).colorScheme.tertiary,
          height: 70,
          width: 70,
          child: Center(
              child: Text((currentSet+1).toString(), style: Theme.of(context).textTheme.displayMedium,)
          )
      ),
    );
  }
}