import 'package:ch600/data/models/device.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';

class AddNewDevice extends StatefulWidget {
  final void Function(MapEntry<dynamic, Device>) onSaveClick;
  final MapEntry<dynamic, Device>? deviceMapEntry;

  const AddNewDevice({
    this.deviceMapEntry,
    required this.onSaveClick,
    super.key,
  });

  @override
  State<AddNewDevice> createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownButtonKey = GlobalKey();

  var defaultSimCard = "1";
  var password = "";
  var phone = "";
  var name = "";

  void openDropdown() {
    _dropdownButtonKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    var device = widget.deviceMapEntry?.value;
    defaultSimCard = device?.defaultSimCard ?? "1";
    password = device?.password ?? "";
    phone = device?.phone ?? "";
    name = device?.name ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: null,
            title: TextFormField(
              initialValue: name,
              autofocus: true,
              style: const TextStyle(color: Colors.red),
              decoration: InputDecoration(
                label: Text(deviceName),
              ),
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'لطفا نام دستگاه را وارد کنید';
                }
                return null;
              },
              onSaved: (s) {
                name = s!;
              },
            ),
          ),
          ListTile(
            onTap: null,
            title: TextFormField(
              initialValue: phone,
              style: const TextStyle(color: Colors.red),
              decoration: InputDecoration(label: Text(devicePhone)),
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'لطفا شماره تلفن دستگاه را وارد کنید';
                }
                return null;
              },
              onSaved: (s) {
                phone = s!;
              },
            ),
          ),
          ListTile(
            onTap: null,
            title: TextFormField(
              initialValue: password,
              style: const TextStyle(color: Colors.red),
              decoration: InputDecoration(label: Text(changePassword)),
              validator: (value) {
                return null;
              },
              onSaved: (s) {
                password = s!;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: openDropdown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    chooseSimCard,
                    style: const TextStyle(color: Colors.red),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                        key: _dropdownButtonKey,
                        elevation: 0,
                        style: const TextStyle(color: Colors.red),
                        value: defaultSimCard,
                        items: const [
                          DropdownMenuItem(
                            value: "1",
                            child: Text("sim one"),
                          ),
                          DropdownMenuItem(
                            value: "2",
                            child: Text("sim two"),
                          )
                        ],
                        onChanged: (z) {
                          setState(() {
                            defaultSimCard = z!;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() == false) return;

              _formKey.currentState?.save();
              widget.onSaveClick(MapEntry(
                  widget.deviceMapEntry?.key,
                  Device(
                      name: name,
                      phone: phone,
                      defaultSimCard: defaultSimCard,
                      password: password)));
            },
            child: Text(accept),
          ),
        ],
      ),
    );
  }
}
