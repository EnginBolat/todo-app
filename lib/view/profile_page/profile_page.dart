import 'package:flutter/material.dart';
import 'package:todo_app/service/shared/shared_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SharedService service = SharedService();
  String? name;
  String? surname;
  bool isLoading = false;

  void getDatas() async {
    changeIsLoading();
    name = await service.getName();
    surname = await service.getSurname();
    Future.delayed(const Duration(seconds: 2));
    changeIsLoading();
  }

  void changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    getDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$name $surname".toUpperCase(),
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        service.deleteUserInfo();
                      },
                      child: const Text("Dataları Sil"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
