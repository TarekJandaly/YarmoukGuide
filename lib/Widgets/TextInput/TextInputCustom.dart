// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:unity_test/Constant/colors.dart';
import 'package:unity_test/Constant/text_styles.dart';

class TextInputCustom extends StatefulWidget {
  Icon? icon;
  TextInputType? type;
  bool isrequierd = false;
  String? hint;
  bool? ispassword;
  int? line;
  String? Function(String?)? validator;
  bool enable;
  TextEditingController? controller;

  TextInputCustom(
      {this.icon,
      this.type,
      this.controller,
      this.hint,
      this.isrequierd = false,
      this.validator,
      this.ispassword = false,
      this.enable = true,
      this.line = 1});

  @override
  State<TextInputCustom> createState() => _TextInputCustomState();
}

class _TextInputCustomState extends State<TextInputCustom> {
  bool? visiblepassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 7,
            color: AppColors.black.withAlpha(50),
            offset: Offset(0, 3.5),
          )
        ],
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        validator: widget.validator ??
            (value) {
              if (widget.isrequierd) {
                if (value!.isEmpty || value == '') {
                  return widget.isrequierd ? "This field is required" : '';
                }
                return null;
              } else {
                return null;
              }
            },
        maxLines: widget.line,
        keyboardType: widget.type,
        style: TextStyles.inputtitle,
        obscureText: widget.ispassword! ? visiblepassword! : false,
        onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
        cursorColor: AppColors.active,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: widget.enable ? AppColors.basic : AppColors.grey50,
          prefixIcon: widget.icon,
          suffixIcon: widget.ispassword!
              ? visiblepassword!
                  ? GestureDetector(
                      onTap: () => setState(() {
                        visiblepassword = !visiblepassword!;
                      }),
                      child: Icon(
                        Icons.visibility_off_rounded,
                        color: AppColors.secondery,
                        size: 20,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => setState(() {
                        visiblepassword = !visiblepassword!;
                      }),
                      child: Icon(
                        Icons.visibility,
                        color: AppColors.secondery,
                        size: 20,
                      ),
                    )
              : null,
          enabled: widget.enable,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          label: Row(
            children: [
              Expanded(
                child: Text(
                  widget.hint!,
                  style: TextStyles.inputtitle,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              if (widget.isrequierd) Gap(10),
              if (widget.isrequierd)
                Text(
                  "*",
                  style: TextStyles.inputtitle.copyWith(color: AppColors.red),
                )
            ],
          ),
          labelStyle: TextStyles.inputtitle,
          contentPadding: EdgeInsets.all(8),
          isDense: true,
        ),
      ),
    );
  }
}
