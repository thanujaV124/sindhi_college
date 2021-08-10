import 'package:sindhi_college/services/auth.dart';
import 'package:sindhi_college/services/database.dart';
import 'package:sindhi_college/utils/constants.dart';
import 'package:sindhi_college/utils/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //

  //
  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //Text Field
  String? usn;
  int? sem;
  String? email;
  String? password;
  String error = '';
  @override
  Widget build(BuildContext context) {
    var enabledBorder = OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor));
    var fillColor = Theme.of(context).cardColor;
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Theme.of(context).backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: backgroundImage,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: logo,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 0,
                                  blurRadius: 16,
                                  offset: Offset(
                                      0, 16), // changes position of shadow
                                ),
                              ],
                            ),
                          ).p12(),
                          Container(
                            child: 'Register'
                                .text
                                .xl5
                                .fontWeight(FontWeight.bold)
                                .make(),
                          ).py16(),
                          Container(
                            child: 'Create account'.text.base.make(),
                          ).py1(),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                'Already Registered?/'.text.base.make(),
                                InkWell(
                                  child: 'Login Here'
                                      .text
                                      .base
                                      .color(Theme.of(context).primaryColor)
                                      .underline
                                      .make(),
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                ),
                              ],
                            ).py12(),
                          ).py1(),
                          Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  inputFormatters: [
                                    BlacklistingTextInputFormatter(
                                        new RegExp(r"\s\b|\b\s"))
                                  ],
                                  maxLength: 8,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: textInputDecoration.copyWith(
                                      hintText: 'Enter USN',
                                      labelText: 'USN',
                                      enabledBorder: enabledBorder,
                                      fillColor: fillColor,
                                      counter: SizedBox.shrink()),
                                  onChanged: (val) async {
                                    setState(() {
                                      usn = val;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'This field is required';
                                    } else if (!RegExp(r"[a-zA-Z]+[0-9]{7}")
                                        .hasMatch(val.toUpperCase())) {
                                      return 'Enter valid USN';
                                    } else if (val.length > 11) {
                                      return 'Enter valid USN';
                                    }

                                    return null;
                                  },
                                ).px32().py12().w64(context),
                                Container(
                                  width: 90,
                                  child: DropdownButtonFormField(
                                    decoration: textInputDecoration.copyWith(
                                        fillColor: fillColor,
                                        enabledBorder: enabledBorder,
                                        hintText: 'sem'),
                                    items: <int>[
                                      1,
                                      2,
                                      3,
                                      4,
                                      5,
                                      6,
                                    ].map<DropdownMenuItem<int>>((int? value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        setState(() => sem = value as int),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'select sem';
                                      }
                                    },
                                  ),
                                )
                              ]),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter Email',
                              fillColor: fillColor,
                              labelText: 'Email',
                              enabledBorder: enabledBorder,
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'This field is required';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ).px32().py12(),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter Password',
                              fillColor: fillColor,
                              labelText: 'Password',
                              enabledBorder: enabledBorder,
                            ),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'This field is required';
                              } else if (val.length < 6) {
                                return 'Password mush be greater than 6 charecters';
                              }
                              return null;
                            },
                          ).px32().py12(),
                          ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      print(usn);
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _db
                                          .checkUsn(usn!.toLowerCase());

                                      if (result == true) {
                                        dynamic authResult = await _auth
                                            .registerWithEmailAndPassword(
                                                email!,
                                                password!,
                                                usn!.toLowerCase(),
                                                sem!);
                                        if (authResult == null) {
                                          setState(() {
                                            error =
                                                'The email address is already in use by another account';
                                            loading = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          error =
                                              'USN is already registered or Not available for registration';
                                          loading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: 'REGISTER'
                                      .text
                                      .sm
                                      .bold
                                      .white
                                      .make()
                                      .p16()
                                      .px1())
                              .p16(),
                          error.text.red500.center.make().px24().py12()
                        ],
                      ).p12().py64(),
                    ).pOnly(bottom: 40),
                  ),
                ),
              ),
            ),
          );
  }
}
