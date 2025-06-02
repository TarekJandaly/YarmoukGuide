// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ypu_dashboard/Constant/colors.dart';
import 'package:ypu_dashboard/Constant/text_styles.dart';

class TextInputCustomSearch extends StatefulWidget {
  TextInputCustomSearch({
    this.icon,
    this.type,
    this.controller,
    this.hint,
    this.isrequierd = false,
    this.validator,
    this.ispassword = false,
    this.onSearch,
    this.enable = true,
    this.line = 1,
  });

  Icon? icon;
  TextInputType? type;
  bool isrequierd = false;
  String? hint;
  bool? ispassword;
  final Function(String)? onSearch;
  int? line;
  String? Function(String?)? validator;
  bool enable;
  TextEditingController? controller;

  @override
  State<TextInputCustomSearch> createState() => _TextInputCustomSearchState();
}

class _TextInputCustomSearchState extends State<TextInputCustomSearch> {
  bool? visiblepassword = true;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.controller ?? TextEditingController();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    widget.onSearch?.call(query);
    FocusScope.of(context).unfocus(); // لتسكير الكيبورد بعد البحث
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
        controller: _searchController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator ??
            (value) {
              if (widget.isrequierd && (value == null || value.isEmpty)) {
                return "This field is required";
              }
              return null;
            },
        maxLines: widget.line,
        onChanged: (value) {
          widget.onSearch?.call(value); // 🔥 هذا أهم شي
        },
        keyboardType: widget.type,
        style: TextStyles.inputtitle,
        obscureText: widget.ispassword! ? visiblepassword! : false,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        cursorColor: AppColors.active,
        enabled: widget.enable,
        onEditingComplete: _performSearch,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppColors.active),
          suffixIcon: IconButton(
            icon: Icon(Icons.send, color: AppColors.active),
            onPressed: _performSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: widget.enable ? AppColors.basic : AppColors.grey50,
          label: Row(
            children: [
              Text(widget.hint ?? '', style: TextStyles.inputtitle),
              if (widget.isrequierd) Gap(10),
              if (widget.isrequierd)
                Text("*",
                    style: TextStyles.inputtitle.copyWith(color: AppColors.red))
            ],
          ),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }
}
