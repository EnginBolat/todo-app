import 'package:flutter/material.dart';
import 'package:todo_app/service/shared/shared_service.dart';

import '../../constants/app_padding.dart';
import '../../constants/app_text.dart';
import '../bottom_nav_bar_page/bottom_nav_bar_page.dart';

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
            padding: EdgeInsets.all(AppPadding.maxValue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildImage(),
                _buildSpace(20),
                Text(
                  IntroPageText.welcome,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                _buildSpace(20),
                Text(
                  IntroPageText.canYouTypeYourName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.normal),
                ),
                _buildSpace(50),
                CustomTextField(
                  controller: _nameController,
                  hintText: IntroPageText.yourName,
                ),
                _buildSpace(10),
                CustomTextField(
                  controller: _surnameController,
                  hintText: IntroPageText.yourSurname,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomNavBarPage()));
            } else {
              return;
            }
          },
          child: Text(IntroPageText.letsstart),
        ),
      ),
    );
  }

  SizedBox _buildImage() {
    return SizedBox(
      height: 128,
      width: 128,
      child: Image.asset(
        'lib/assets/images/todo-icon.png',
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
      ),
      controller: controller,
    );
  }
}
