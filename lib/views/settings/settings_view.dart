import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/views/base_view.dart';
import 'package:school_erp/views/settings/settings_vewmodel.dart';

class SettingsViews extends StatelessWidget {
  const SettingsViews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BaseView<SettingsViewModel>(
      builder: (context, settings, _) {
        // settings.chosenValue = context.locale.languageCode;
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/settings_bg.png'))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * .1,
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        tr("Language") + ": ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      width: size.width * .05,
                    ),
                    Flexible(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        focusColor: Colors.white,
                        value:
                            settings.chosenValue ?? context.locale.languageCode,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          // prefixIcon: FaIcon(FontAwesomeIcons.language),
                          prefixIcon: Icon(Icons.language),
                          border: InputBorder.none,
                        ),
                        iconEnabledColor: Colors.black,
                        items: settings.items
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          tr("Language"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        onChanged: (value) async {
                          await context.setLocale(Locale('$value'));
                          settings.chosenValue = value!;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: Text(
              "${tr("app version")}: ${settings.buildNumber}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        );
      },
    );
  }
}
