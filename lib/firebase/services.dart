import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // alias firebase_auth
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ordering_system/model/menu.dart';
import 'package:ordering_system/model/user.dart' as custom_user; // alias your custom User model

class FirebaseServices extends ChangeNotifier {
  List<MenuItem> _menuItems = [];
  List<MenuItem> get menuItems => _menuItems;
  List<custom_user.User> _users = []; // use custom_user.User for your custom User model
  List<custom_user.User> get users => _users;

  // USERS
  Future<void> fetchUsers() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();

      _users = snapshot.docs.map((doc) {
        return custom_user.User(
          id: doc.id,
          firstName: doc['firstName'] ?? '',
          lastName: doc['lastName'] ?? '',
          email: doc['email'] ?? '',
          role: doc['role'] ?? '',
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> addUser(String firstName, String lastName, String email, String password, String role) async {
    try {
      firebase_auth.UserCredential userCredential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': role,
      });
      await fetchUsers();
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<void> editUser(custom_user.User user, String role) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'role': role,
      });

      await fetchUsers();
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // MENU
  Future<void> fetchMenuItems() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('menu').get();

      _menuItems = snapshot.docs.map((doc) {
        return MenuItem(
          id: doc.id,
          type: doc['type'] ?? '',
          name: doc['name'] ?? '',
          price: (doc['price'] ?? 0.0).toDouble(),
          imageUrl: doc['image'] ?? '',
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching menu items: $e');
    }
  }

  Future<void> addMenuItem(String type, String name, double price, String imageFilePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('menu/$name.jpg');
      await storageRef.putFile(File(imageFilePath));
      final imageUrl = await storageRef.getDownloadURL();

      final docRef = await FirebaseFirestore.instance.collection('menu').add({
        'type': type,
        'name': name,
        'price': price,
        'image': imageUrl,
      });

      await fetchMenuItems();
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  Future<void> deleteMenuItem(String menuItemId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('menu').doc(menuItemId).get();

      if (docSnapshot.exists) {
        String imageUrl = docSnapshot['image'];

        await FirebaseFirestore.instance.collection('menu').doc(menuItemId).delete();

        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();

        await fetchMenuItems();
      }
    } catch (e) {
      print('Error deleting menu item: $e');
    }
  }

  Future<void> updateMenuItem(MenuItem menuItem, String type, String name, double price, String imageFilePath) async {
    try {
      String imageUrl = menuItem.imageUrl;

      if (imageFilePath.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.ref().child('menu/$name.jpg');
        await storageRef.putFile(File(imageFilePath));
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('menu').doc(menuItem.id).update({
        'type': type,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
      });

      await fetchMenuItems();
    } catch (e) {
      print('Error updating menu item: $e');
    }
  }
}
