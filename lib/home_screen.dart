import 'package:flutter/material.dart';
import 'package:staniapp/src/UserInformation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const route = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>?> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = UserInfo().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Flutter-Symfony Rest API'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.hasError || snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Flutter-Symfony Rest API'),
              ),
              body: Center(
                child: Text(
                  'Failed to fetch user info.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            );
          } else {
            final userInfo = snapshot.data!;
            final email = userInfo['email'];
            final firstname = userInfo['firstname'];
            final lastname = userInfo['lastname'];
         return Scaffold(
              appBar: AppBar(
                title: Text('Flutter-Symfony Rest API'),
              ),
              body: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome $firstname $lastname!',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Email: $email',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
