import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/MyTransactionController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/AppBars.dart';
import '../../utils/styleUtil.dart';
import '../commonUi/CommonUi.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<StatefulWidget> createState() => ContactUsScreenState();
}
final _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController subjectController = TextEditingController();
TextEditingController msgController = TextEditingController();
class ContactUsScreenState extends State<ContactUsScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200)).then((_) {
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<MyTransactionController>(builder: (context, loginData, _) {
      return Scaffold(
        appBar: myStatusBar(),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 3, 15),
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "Contact Us",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontFamily: "sb",
                                fontSize: 18),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            scrollPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding:
                              const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              hintText: 'Full Name',
                              hintStyle: const TextStyle(
                                fontFamily: 'sb',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  color: myprimarycolor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            scrollPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding:
                              const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              hintText: 'Email id',
                              hintStyle: const TextStyle(
                                fontFamily: 'sb',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  color: myprimarycolor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            scrollPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              counterText: "",
                              hintText: 'Mobile Number',
                              hintStyle: const TextStyle(
                                fontFamily: 'sb',
                              ),
                              contentPadding:
                              const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  color: myprimarycolor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                          child: TextFormField(
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            scrollPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            controller: subjectController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding:
                              const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              hintText: 'Subject',
                              hintStyle: const TextStyle(
                                fontFamily: 'sb',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  color: myprimarycolor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
                          child: TextFormField(
                            minLines: 3, // any number you need (It works as the rows for the textarea)
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            scrollPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            controller: msgController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding:
                              const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              hintText: 'Message',
                              hintStyle: const TextStyle(
                                fontFamily: 'sb',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  color: myprimarycolor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                String userName = nameController.text.trim().toString();
                                String userEmail = emailController.text.trim().toString();
                                String userMobile = mobileController.text.trim().toString();
                                String userSubject = subjectController.text.trim().toString();
                                String userMsg = msgController.text.trim().toString();
                                if (userName.isEmpty) {
                                  showToast('Please enter your name');
                                  return;
                                }
                                if (userEmail.isEmpty) {
                                  showToast('Please enter your email id.');
                                  return;
                                }
                                if (!validateEmailId(userEmail)) {
                                  showToast('Please enter a valid email id.');
                                  return;
                                }
                                if (userMobile.isEmpty) {
                                  showToast('Please enter your mobile no.');
                                  return;
                                }
                                if (userMobile.length != 10) {
                                  showToast('Please enter a valid mobile no.');
                                  return;
                                }
                                if (userSubject.isEmpty) {
                                  showToast('Please enter subject.');
                                  return;
                                }
                                if (userSubject.isEmpty) {
                                  showToast('Please enter message.');
                                  return;
                                }
                                Map<String, String> userData = {
                                  'name': userName,
                                  'phone': userMobile,
                                  'subject': userSubject,
                                  'message': userMsg,
                                  'email': userEmail,
                                };
                                // showToast(loginData.toString());
                                loginData.getContactUs(context, userData);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'sb',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
