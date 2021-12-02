import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/config/palette.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/utils/frappe_alert.dart';
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
          appBar: AppBar(
            title: Text(
              tr("Settings"),
              style: TextStyle(color: Palette.appbarForegroundColor),
            ),
            backgroundColor: Palette.appbarBackgroundColor,
            leading: BackButton(
              color: Palette.appbarForegroundColor,
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/settings_bg.png'))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          tr("Language") + ": ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 2,
                        child: LanguageDropdown(settings: settings),
                      ),
                    ],
                  ),
                ),
                Divider(),
                if (!Config().isGuest)
                  DeleteDevicesButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext _context) {
                            return AlertDialog(
                              title: Text(tr("Warning")),
                              titleTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                              actionsOverflowButtonSpacing: 20,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(_context).pop();
                                    },
                                    child: Text(tr("Cancel"))),
                                TextButton(
                                    onPressed: () {
                                      settings.deleteDevice().then((value) {
                                        if (value) {
                                          FrappeAlert.successAlert(
                                              title: tr("All devices removed"),
                                              context: context);
                                        } else {
                                          FrappeAlert.errorAlert(
                                              title: tr("Something went wrong"),
                                              context: context);
                                        }
                                      });
                                      Navigator.of(_context).pop();
                                    },
                                    child: Text(tr("Continue"))),
                              ],
                              content: Text(tr(
                                  "All your registered devices will not receive notifications unless you signed in again.\nDo you want to proceed?")),
                            );
                          });
                    },
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

class DeleteDevicesButton extends StatelessWidget {
  const DeleteDevicesButton({Key? key, required this.onPressed})
      : super(key: key);
  final Future Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () async {
              this.onPressed();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr("Remove all devices.")),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          tr("This option will remove all devices registered to this account from receiving notifications."),
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Divider()
      ],
    );
  }
}

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({Key? key, required this.settings}) : super(key: key);
  final SettingsViewModel settings;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusColor: Colors.white,
      value: settings.chosenValue ?? context.locale.languageCode,
      //elevation: 5,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        // prefixIcon: FaIcon(FontAwesomeIcons.language),
        prefixIcon: Icon(Icons.language),
        border: InputBorder.none,
      ),
      iconEnabledColor: Colors.black,
      items: settings.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            tr(value),
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Text(
        tr("Language"),
        style: TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onChanged: (value) async {
        await context.setLocale(Locale('$value'));
        settings.chosenValue = value!;
      },
    );
  }
}
