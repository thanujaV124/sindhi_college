import 'package:sindhi_college/screens/wrapper.dart';
import 'package:sindhi_college/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sindhi_college/models/user.dart';
import 'package:sindhi_college/services/database.dart';
import 'package:sindhi_college/utils/constants.dart';

class EnterDetails extends StatefulWidget {
  final UserData userData;
  // ignore: use_key_in_widget_constructors
  const EnterDetails({required this.userData});

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  // final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _fullName;

  String? _branch;

  String? _section;


  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _db = DatabaseService();
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: 'Enter Details'.text.make(),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 'Complete This last step to navigate to home page'
                    //     .text
                    //     .bold
                    //     .make()
                    //     .p16(),
                    TextFormField(
                      maxLength: 30,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Full Name',
                          labelText: 'Full Name',
                          enabledBorder: enabledBorder,
                          fillColor: fillColor,
                          counter: SizedBox.shrink()),
                      onChanged: (val) {
                        // entryController.text = val;
                        setState(() {
                          _fullName = val.toUpperCase();
                        });
                      },
                      // controller: nameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'This field is required';
                        } else if (!RegExp(r"[A-Za-z\s]+$")
                            .hasMatch(val.toUpperCase())) {
                          return 'Special characters & numbers not allowed';
                        } else if (!val.contains(RegExp(r"[A-Za-z]+$"))) {
                          return 'Invalid name';
                        } else if (val.length < 4) {
                          return 'Enter Valid Name';
                        }

                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Select Branch',
                          enabledBorder: enabledBorder,
                          fillColor: fillColor),
                      items: <String>[
                        'BCA',
                        'BCOM',
                        'BBA',
                        
                      ].map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _branch = value),
                      validator: (value) {
                        if (value == null) {
                          return 'select sem';
                        }
                      },
                    ).pLTRB(0, 5, 0, 12),
                    DropdownButtonFormField<String>(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Select section',
                          enabledBorder: enabledBorder,
                          fillColor: fillColor),
                      items: <String>[
                        'A',
                        'B',
                        'C',
                      ].map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _section = value),
                      validator: (value) {
                        if (value == null) {
                          return 'select sem';
                        }
                      },
                    ),
                    ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.grey,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius:
                              //       BorderRadius.circular(8),
                              // ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                    
                                             Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Wrapper()));
                                dynamic result =
                                    await DatabaseService(branch: _branch)
                                        .updateUserData(
                                            widget.userData.usn,
                                            _fullName!,
                                            widget.userData.sem!,
                                            _section!,
                                            _branch!);

                                
                              
                              }
                            },
                            child: 'SUBMIT'.text.white.make().p16().px1())
                        .p(20),
                  ],
                ),
              ).p16(),
            ),
          );
  }
}
