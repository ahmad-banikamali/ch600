import 'package:ch600/data/models/device.dart';
import 'package:ch600/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';

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
    getSimCardCount();

    super.initState();
  }

  Future<int?> getSimCardCount() async {
    if(await Permission.phone.request().isGranted) {
      SimInfo simInfo = await SimNumber.getSimData();
      return simInfo.cards.length;
    }
    else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSimCardCount(),
      initialData: null,
      builder: (w, s) {
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                  decoration: InputDecoration(
                    label: Text(
                      deviceName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black),
                    ),
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                  decoration: InputDecoration(
                      label: Text(
                    devicePhone,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  )),
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
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black),
                  decoration: InputDecoration(
                      label: Text(
                    changePassword,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.black),
                  )),
                  validator: (value) {
                    return null;
                  },
                  onSaved: (s) {
                    password = s!;
                  },
                ),
              ),
              if (s.data !=null && s.data! > 1)
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
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.black),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                              key: _dropdownButtonKey,
                              elevation: 0,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.black),
                              value: defaultSimCard,
                              items: const [
                                DropdownMenuItem(
                                  value: "1",
                                  child: Text("سیم یک"),
                                ),
                                DropdownMenuItem(
                                  value: "2",
                                  child: Text("سیم دو"),
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.all(Radius.circular(8))),

                child: TextButton(

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

                  child: Text(accept,  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground, fontSize: 15)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
