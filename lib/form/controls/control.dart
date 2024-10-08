import 'package:flutter/material.dart';
import 'package:school_erp/config/frappe_palette.dart';

import 'package:school_erp/config/palette.dart';
import 'package:school_erp/form/controls/read_only.dart';
import 'package:school_erp/form/controls/text.dart';
import 'package:school_erp/model/common.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/model/doctype_response.dart';
import 'package:school_erp/widgets/custom_expansion_tile.dart';
import 'package:school_erp/widgets/section.dart';

import '../../config/palette.dart';

import './data.dart';
import './date.dart';
import './datetime.dart';
import './float.dart';
import './int.dart';
import './select.dart';
import './small_text.dart';
import './text_editor.dart';
import './time.dart';
import 'currency.dart';

Widget makeControl({
  required DoctypeField field,
  OnControlChanged? onControlChanged,
  Map? doc,
  bool decorateControl = true,
}) {
  Widget control;

  switch (field.fieldtype) {
    // case "Link":
    //   {
    //     control = LinkField(
    //       doctypeField: field,
    //       doc: doc,
    //       onControlChanged: onControlChanged,
    //     );
    //   }
    //   break;

    // case "Autocomplete":
    //   {
    //     control = AutoComplete(
    //       doctypeField: field,
    //       doc: doc,
    //       onControlChanged: onControlChanged,
    //     );
    //   }
    //   break;

    // case "Table":
    //   {
    //     control = CustomTable(
    //       doctypeField: field,
    //       doc: doc,
    //     );
    //   }
    //   break;

    case "Select":
      {
        control = Select(
          doc: doc,
          doctypeField: field,
          onControlChanged: onControlChanged,
        );
      }
      break;

    // case "MultiSelect":
    //   {
    //     control = MultiSelect(
    //       doctypeField: field,
    //       doc: doc,
    //       onControlChanged: onControlChanged,
    //     );
    //   }
    //   break;

    // case "Table MultiSelect":
    //   {
    //     control = MultiSelect(
    //       doctypeField: field,
    //       doc: doc,
    //       onControlChanged: onControlChanged,
    //     );
    //   }
    //   break;

    case "Small Text":
      {
        control = SmallText(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Text":
      {
        control = ControlText(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Data":
      {
        control = Data(
          doc: doc,
          doctypeField: field,
        );
      }
      break;

    case "Read Only":
      {
        control = ReadOnly(
          doc: doc,
          doctypeField: field,
        );
      }
      break;

    // case "Check":
    //   {
    //     control = Check(
    //       doctypeField: field,
    //       doc: doc,
    //       onControlChanged: onControlChanged,
    //     );
    //   }
    //   break;

    case "Text Editor":
      {
        control = TextEditor(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Datetime":
      {
        control = DatetimeField(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Float":
      {
        control = Float(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Currency":
      {
        control = Currency(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Int":
      {
        control = Int(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Time":
      {
        control = Time(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    case "Date":
      {
        control = Date(
          doctypeField: field,
          doc: doc,
        );
      }
      break;

    // case "Signature":
    //   {
    //     control = customSignature.Signature(
    //       doc: doc,
    //       doctypeField: field,
    //     );
    //   }
    //   break;

    // case "Barcode":
    //   {
    //     control = FormBuilderBarcode(
    //       doctypeField: field,
    //       doc: doc,
    //     );
    //   }
    //   break;

    default:
      control = Container();
      break;
  }
  if (decorateControl) {
    return buildDecoratedControl(
      control: control,
      field: field,
    );
  } else {
    return Padding(
      padding: Palette.fieldPadding,
      child: control,
    );
  }
}

Widget buildDecoratedControl({
  required Widget control,
  required DoctypeField field,
}) {
  return Padding(
    padding: Palette.fieldPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            if (field.fieldtype != "Check")
              Padding(
                padding: Palette.labelPadding,
                child: Text(
                  field.label ?? "",
                  style: TextStyle(
                    // color: Palette.f,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            SizedBox(width: 4),
            if (field.reqd == 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '*',
                  style: TextStyle(
                    color: FrappePalette.red,
                  ),
                ),
              ),
          ],
        ),
        control
      ],
    ),
  );
}

List<Widget> generateLayout({
  required List<DoctypeField> fields,
  required OnControlChanged onControlChanged,
  Map? doc,
}) {
  List<Widget> collapsibles = [];
  List<Widget> widgets = [];
  List<Widget> sections = [];

  List<String> collapsibleLabels = [];
  List<String> sectionLabels = [];

  var isCollapsible = false;
  var isSection = false;

  int cIdx = 0;
  int sIdx = 0;

  // var dependsOnFields =
  //     fields.where((field) => field.dependsOn != null).map((field) {
  //   if (field.dependsOn!.startsWith("eval:")) {
  //     return field.dependsOn!.split(".")[1].split("===")[0];
  //   } else {
  //     return "";
  //   }
  // }).toList();

  fields.forEach((field) {
    var val;
    var defaultValDoc = {};

    // var attachListener =
    //     dependsOnFields.indexOf(field.fieldname) == -1 ? false : true;

    if (doc != null) {
      val = doc[field.fieldname];
    } else {
      val = field.defaultValue;

      if (val == '__user') {
        val = Config().userId;
      }

      defaultValDoc = {
        field.fieldname: val,
      };
    }

    if (val is List) {
      if (val.isEmpty) {
        val = null;
      }
    }

    if (field.fieldtype == "Section Break") {
      if (sections.length > 0) {
        widgets.add(
          sectionLabels[sIdx] != ''
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: ListTileTheme(
                    tileColor: Colors.white,
                    child: CustomExpansionTile(
                      maintainState: true,
                      initiallyExpanded: true,
                      title: Text(
                        sectionLabels[sIdx],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [...sections],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: Section(
                    title: sectionLabels[sIdx],
                    children: [...sections],
                  ),
                ),
        );

        sIdx += 1;
        sections.clear();
      } else if (collapsibles.length > 0) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: ListTileTheme(
              tileColor: Colors.white,
              child: CustomExpansionTile(
                maintainState: true,
                title: Text(
                  collapsibleLabels[cIdx],
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Container(
                      color: Colors.white,
                      child: Column(
                        children: [...collapsibles],
                      ))
                ],
              ),
            ),
          ),
        );
        cIdx += 1;
        collapsibles.clear();
      }

      if (field.collapsible == 1) {
        isSection = false;
        isCollapsible = true;
        collapsibleLabels.add(field.label!);
      } else {
        isCollapsible = false;
        isSection = true;
        sectionLabels.add(field.label != null ? field.label! : '');
      }
    } else if (isSection) {
      var firstField = sections.isEmpty;
      if (firstField) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
            ),
            child: makeControl(
              field: field,
              doc: doc,
              // onControlChanged: attachListener ? onControlChanged : null,
            ),
          ),
        );
      } else {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: makeControl(
              field: field,
              doc: doc,
              // onControlChanged: attachListener ? onControlChanged : null,
            ),
          ),
        );
      }
    } else if (isCollapsible) {
      collapsibles.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
          ),
          child: makeControl(
            doc: doc ?? defaultValDoc,
            field: field,
            // onControlChanged: attachListener ? onControlChanged : null,
          ),
        ),
      );
    } else {
      widgets.add(
        Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
          ),
          color: Colors.white,
          child: makeControl(
            field: field,
            doc: doc ?? defaultValDoc,
            // onControlChanged: attachListener ? onControlChanged : null,
          ),
        ),
      );
    }
  });

  if (sections.length > 0) {
    widgets.add(
      sectionLabels[sIdx] != ''
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: 10.0,
              ),
              child: ListTileTheme(
                tileColor: Colors.white,
                child: CustomExpansionTile(
                  maintainState: true,
                  initiallyExpanded: true,
                  title: Text(
                    sectionLabels[sIdx],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [...sections],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Section(
                title: sectionLabels[sIdx],
                children: [...sections],
              ),
            ),
    );

    sIdx += 1;
    sections.clear();
  }

  if (collapsibles.length > 0) {
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: ListTileTheme(
          tileColor: Colors.white,
          child: CustomExpansionTile(
            maintainState: true,
            title: Text(
              collapsibleLabels[cIdx],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [...collapsibles],
                ),
              )
            ],
          ),
        ),
      ),
    );
    cIdx += 1;
    collapsibles.clear();
  }

  return widgets;
}
