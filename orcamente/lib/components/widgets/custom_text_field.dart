import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Function(String)? onChanged;
  final bool formatMoney;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool showCounter;
  final String? errorText;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.onChanged,
    this.formatMoney = false,
    this.validator,
    this.maxLength,
    this.showCounter = false,
    this.errorText,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    // Add listener for real-time validation
    if (widget.validator != null) {
      widget.controller.addListener(_validateInput);
    }
  }

  @override
  void dispose() {
    if (widget.validator != null) {
      widget.controller.removeListener(_validateInput);
    }
    super.dispose();
  }

  void _validateInput() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      if (error != _validationError) {
        setState(() {
          _validationError = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null || _validationError != null;
    final errorMessage = widget.errorText ?? _validationError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          inputFormatters:
              widget.formatMoney
                  ? [
                    MoneyInputFormatter(
                      leadingSymbol: 'R\$',
                      useSymbolPadding: true,
                    ),
                  ]
                  : widget.maxLength != null
                  ? [LengthLimitingTextInputFormatter(widget.maxLength)]
                  : [],
          keyboardType:
              widget.keyboardType ??
              (widget.formatMoney
                  ? TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text),
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: hasError ? Colors.red : Colors.grey,
            ),
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                    : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            counterText: widget.showCounter ? null : '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: Colors.red),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
