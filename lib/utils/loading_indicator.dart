import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool visibility;
  const LoadingIndicator({
    required this.visibility,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
        visible: visibility,
        child: Center(
          child: SizedBox(
            height: 200,
            child: Column(
              children: const [
                Spacer(),
                CircularProgressIndicator.adaptive(),
                Spacer()
              ],
            ),
          ),
        ),
      );
}

showSnackBar(
  context,
  String message,
) async =>
    await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ))
        .closed;
