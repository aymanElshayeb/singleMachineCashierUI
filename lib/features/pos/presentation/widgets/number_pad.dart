import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(double) onNumberPressed;
  final Function() onDecimalPointPressed;
  final Function() onBackspacePressed;
  final bool floatingPointMode;

  const NumberPad(
      {super.key,
      required this.onNumberPressed,
      required this.onDecimalPointPressed,
      required this.onBackspacePressed,
      required this.floatingPointMode});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define the padding for the buttons.
    const EdgeInsets buttonPadding = EdgeInsets.all(5.0);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton(1, onNumberPressed, theme, buttonPadding),
            _NumberButton(2, onNumberPressed, theme, buttonPadding),
            _NumberButton(3, onNumberPressed, theme, buttonPadding),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton(4, onNumberPressed, theme, buttonPadding),
            _NumberButton(5, onNumberPressed, theme, buttonPadding),
            _NumberButton(6, onNumberPressed, theme, buttonPadding),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton(7, onNumberPressed, theme, buttonPadding),
            _NumberButton(8, onNumberPressed, theme, buttonPadding),
            _NumberButton(9, onNumberPressed, theme, buttonPadding),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _DecimalPointButton(
                onDecimalPointPressed, theme, buttonPadding, floatingPointMode),
            _NumberButton(0, onNumberPressed, theme, buttonPadding),
            _BackspaceButton(theme, buttonPadding, onBackspacePressed),
          ],
        ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  final int number;
  final Function(double) onNumberPressed;
  final ThemeData theme;
  final EdgeInsets buttonPadding;

  const _NumberButton(
      this.number, this.onNumberPressed, this.theme, this.buttonPadding);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: ElevatedButton(
        onPressed: () {
          // Convert the integer to a double and pass it to the callback.
          final double value = number.toDouble();
          onNumberPressed(value);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.canvasColor,
          backgroundColor: theme.buttonTheme.colorScheme!.onPrimary,
          padding: const EdgeInsets.all(30.0), // Adjust the padding for spacing
        ),
        child: Text(
          number.toString(),
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}

class _DecimalPointButton extends StatelessWidget {
  final Function() onDecimalPointPressed;
  final ThemeData theme;
  final EdgeInsets buttonPadding;
  final bool floatingPointMode;

  const _DecimalPointButton(this.onDecimalPointPressed, this.theme,
      this.buttonPadding, this.floatingPointMode);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: ElevatedButton(
        onPressed: onDecimalPointPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.primaryColorDark,
          backgroundColor: floatingPointMode ? theme.buttonTheme.colorScheme!.onPrimary : Colors.grey,
          padding: buttonPadding,
        ),
        child: Text(
          '.',
          style: TextStyle(
            fontSize: 30.0,
            color: floatingPointMode
                ? Colors.white
                : theme.primaryColor, // Change color when in floating mode
          ),
        ),
      ),
    );
  }
}

class _BackspaceButton extends StatelessWidget {
  final ThemeData theme;
  final EdgeInsets buttonPadding;
  final Function() onBackspacePressed;

  const _BackspaceButton(
      this.theme, this.buttonPadding, this.onBackspacePressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: ElevatedButton(
        onPressed: onBackspacePressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.primaryColorDark,
          backgroundColor: theme.buttonTheme.colorScheme!.onPrimary,
          padding: const EdgeInsets.all(16.0), // Adjust the padding for spacing
        ),
        child: Icon(
          Icons.backspace,
          color: theme.primaryColorDark,
        ),
      ),
    );
  }
}
