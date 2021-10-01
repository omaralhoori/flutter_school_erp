import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/model/doctype_response.dart';

import 'base_control.dart';
import 'base_input.dart';

// appended control due to naming conflict with Text widget
class ControlText extends StatelessWidget with Control, ControlInput {
  final DoctypeField doctypeField;

  final Key? key;
  final Map? doc;

  const ControlText({
    required this.doctypeField,
    this.key,
    this.doc,
  });

  @override
  Widget build(BuildContext context) {
    List<String? Function(dynamic)> validators = [];

    var f = setMandatory(doctypeField);

    if (f != null) {
      validators.add(
        f(context),
      );
    }

    return FormBuilderTextField(
      key: key,
      initialValue: doc != null ? doc![doctypeField.fieldname] : null,
      name: doctypeField.fieldname,
      decoration: Palette.formFieldDecoration(
        label: doctypeField.label,
      ),
      validator: FormBuilderValidators.compose(validators),
    );
  }
}
