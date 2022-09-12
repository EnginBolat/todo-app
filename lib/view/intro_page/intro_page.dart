import 'package:flutter/material.dart';
import 'package:todo_app/service/shared/shared_service.dart';

import '../../constants/app_text.dart';
import '../profile_page/profile_page.dart';

class IntroPage extends StatelessWidget {
  IntroPage({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final SharedService service = SharedService();

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildImage(),
                _buildSpace(50),
                Text(
                  AppText.welcome,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                _buildSpace(20),
                Text(
                  AppText.canYouTypeYourName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
                _buildSpace(50),
                CustomTextField(
                  controller: _nameController,
                  hintText: AppText.yourName,
                ),
                _buildSpace(10),
                CustomTextField(
                  controller: _surnameController,
                  hintText: AppText.yourSurname,
                ),
                _buildSpace(50),
                _customStartButton(deviceHeight, deviceWidth, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ClipRRect _customStartButton(
      double deviceHeight, double deviceWidth, BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        height: deviceHeight * 0.07,
        width: deviceWidth * 0.5,
        child: ElevatedButton(
          onPressed: () {
            if (_surnameController.text.isNotEmpty &&
                _nameController.text.isNotEmpty) {
              service.setName(_nameController.text);
              service.setSurname(_surnameController.text);
              service.setUserLogin();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            } else {
              return;
            }
          },
          child: Text(AppText.letsstart),
        ),
      ),
    );
  }

  SizedBox _buildImage() {
    return SizedBox(
      height: 250,
      width: 250,
      child: Image.network(
        "https://picsum.photos/200",
      ),
    );
  }

  SizedBox _buildSpace(double height) => SizedBox(height: height);
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 15,
      decoration: InputDecoration(
        hintText: hintText,
        hoverColor: Theme.of(context).primaryColor,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
      controller: controller,
    );
  }
}
