library dropdown_formfield;

import 'package:flutter/material.dart';

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final EdgeInsets contentPadding;
  final bool enabled;

  DropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText = 'Please select one option',
      this.value,
      this.dataSource,
      this.textField,
      this.valueField,
      this.onChanged,
      this.filled = true,
      this.enabled = true,
      this.contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 0)})
      : super(
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Align(
              alignment: Alignment.center,
              child: Container(
//                height: 120,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.red,
                        contentPadding: contentPadding,
                      ),
                      child: DropdownButtonHideUnderline(
                          child: enabled
                              ? DropdownButton<dynamic>(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                  ),
                                  hint: Text(
                                    hintText,
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                  value: value == '' ? null : value,
                                  onChanged: (dynamic newValue) {
                                    state.didChange(newValue);
                                    onChanged(newValue);
                                  },
                                  items: dataSource.map((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item[valueField],
                                      child: Text(item[textField]),
                                    );
                                  }).toList(),
                                )
                              : DropdownButton<dynamic>(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                  ),
                                  hint: Text(
                                    hintText,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: value == '' ? null : value,
                                  onChanged: (dynamic newValue) {
                                    state.didChange(newValue);
                                    onChanged(newValue);
                                  },
                                  items: [],
                                )),
                    ),
                    SizedBox(height: state.hasError ? 5.0 : 0.0),
                    Text(
                      state.hasError ? state.errorText : '',
                      style: TextStyle(
                          color: Colors.redAccent.shade700,
                          fontSize: state.hasError ? 12.0 : 0.0),
                    ),
                  ],
                ),
              ),
            );
          },
        );
}
