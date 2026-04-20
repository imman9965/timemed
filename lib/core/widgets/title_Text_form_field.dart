import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleTextFormField extends StatefulWidget {
  final String? title;
  final String? hintText;
  final String? labelText;

  final TextEditingController? controller;
  final TextInputType? keyboardType;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;

  final int? maxLength;
  final int? maxLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool filled;
  final Color? fillColor;

  final double? borderRadius;

  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  final List<TextInputFormatter>? inputFormatters;

  const TitleTextFormField({
    super.key,
    this.title,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.filled = false,
    this.fillColor,
    this.borderRadius,
    this.validator,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<TitleTextFormField> createState() => _TitleTextFormFieldState();
}

class _TitleTextFormFieldState extends State<TitleTextFormField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  OutlineInputBorder borderStyle(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
        ],

        /// TextField
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          obscureText: _obscure,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,

          inputFormatters: [
            if (widget.maxLength != null)
              LengthLimitingTextInputFormatter(widget.maxLength),
            ...?widget.inputFormatters,
          ],

          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,

            filled: widget.filled,
            fillColor: widget.fillColor,

            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : widget.suffixIcon,

            border: borderStyle(Colors.black),
            enabledBorder: borderStyle(Colors.black),
            focusedBorder: borderStyle(Theme.of(context).primaryColor),

            // contentPadding: const EdgeInsets.symmetric(
            //   horizontal: 16,
            //   vertical: 14,
            // ),
          ),
        ),
      ],
    );
  }
}
