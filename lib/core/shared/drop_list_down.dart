
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DropListDown extends StatefulWidget {
  final TextEditingController dropDownSelectedName;
  final TextEditingController dropDownSelectedId;
  final String title;
  final String hint;
  final List<SelectedListItem>? listData;
  final String? Function(String?)? validator;
  final bool? enabled;

  const DropListDown({
    required this.enabled,
    required this.title,
    required this.hint,
    this.listData,
    super.key,
    required this.dropDownSelectedName,
    required this.dropDownSelectedId,
    required this.validator
  });

  @override
  State<DropListDown> createState() => _DropListDownState();
}

class _DropListDownState extends State<DropListDown> {

  void showDropList() {
    DropDownState(
      DropDown(
        isDismissible: true,
        bottomSheetTitle: const Text(
          "Choose Category",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        clearButtonChild: const Text(
          'Clear',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: widget.listData!,
        onSelected: (List<dynamic> selectedList) {
          SelectedListItem selectedListItem = selectedList[0];
          widget.dropDownSelectedName.text = selectedListItem.name;
          widget.dropDownSelectedId.text = selectedListItem.value!;
        },
      ),
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.title),
      const SizedBox(
        height: 5.0,
      ),
      TextFormField(
        enabled:widget.enabled ,
        validator: widget.validator,
        controller: widget.dropDownSelectedName,
        cursorColor: Colors.black,
        onTap: () {
          FocusScope.of(context).unfocus();
          showDropList();
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: widget.hint,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      )
    ]);
  }
}
