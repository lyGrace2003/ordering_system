import 'package:firebase_auth/firebase_auth.dart'  as firebase_auth;
import 'package:flutter/material.dart';
import 'package:ordering_system/auth/authcontroller.dart';
import 'package:ordering_system/dialog/dialog.dart';
import 'package:ordering_system/firebase/services.dart';
import 'package:ordering_system/model/user.dart' as custom_user;
import 'package:ordering_system/util/app_style.dart';
import 'package:provider/provider.dart';

class CustomerMenuScreen extends StatefulWidget {
  static const String route = '/customermenu';

  static const String name = 'CustomerMenuScreen';
  const CustomerMenuScreen({super.key});

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> {
  late TextEditingController searchController;
  firebase_auth.User? currentUser;
  custom_user.User? currentUserinfo;

  void initState() {
    super.initState();
    searchController = TextEditingController();
    _initialize();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _initialize() {
    _getCurrentUser();
    Provider.of<FirebaseServices>(context, listen: false).fetchMenuItems();
  }

  void _getCurrentUser() {
    currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _loadCurrentUser();
    }
  }

  Future<void> _loadCurrentUser() async {
    if (currentUser != null) {
      try {
        custom_user.User user = await Provider.of<FirebaseServices>(context, listen: false).findUser(currentUser!);
        setState(() {
          currentUserinfo = user;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: SizedBox(
        height: 40,
        child: Center(
          child: Text("Hi ${currentUserinfo?.firstName ?? ''} ${currentUserinfo?.lastName ?? ''}", style: mRegular.copyWith(color: mBlack, fontSize: 18),),
        )
      ),
      actions: [
        IconButton(
          onPressed: () {
            WaitingDialog.show(context, future: AuthController.I.logout());
          },
          icon: const Icon(Icons.logout),
        ),
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          const SizedBox(height: 50,),
          Row(
            children: [],
          ), 
          const SizedBox(height: 20),
          Text("Menu", style: mMedium.copyWith(color: mBlack,fontSize: 25, letterSpacing: 2),)
          ],
        ),
        ),
    );
  }
}