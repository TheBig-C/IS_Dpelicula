import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/widgets/loading_spinner.dart';
import 'package:is_dpelicula/widgets/user_image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> profileData = {
    'name': '',
    'phone': '',
    'address': '',
  };

  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    FirebaseStorage storage = FirebaseStorage.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C1C27), // Azul oscuro
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Editar Perfil',
            style: TextStyle(
              color: const Color(0xfff4b33c), // Naranja
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(user?.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            data['image_url'] == null || data['image_url'] == ''
                                ? UserImagePicker(_pickedImage)
                                : UserImagePicker(
                                    _pickedImage,
                                    defaultImage: data['image_url'],
                                  ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          initialValue: data['email'] ?? '',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          cursorColor: Theme.of(context).primaryColor,
                          enabled: false,
                          style: TextStyle(
                            color: Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 18,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) => email != null && email.isEmpty
                              ? 'Email can\'t be empty'
                              : null,
                          decoration: _inputDecoration('Email', context),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: data['name'] ?? '',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          cursorColor: Theme.of(context).primaryColor,
                          onSaved: (value) {
                            profileData['name'] = value!.trim();
                          },
                          style: TextStyle(
                            color: Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 18,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => name != null && name.isEmpty
                              ? 'Name can\'t be empty'
                              : null,
                          decoration: _inputDecoration('Nombre', context),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: data['phone'] ?? '',
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.phone,
                          cursorColor: Theme.of(context).primaryColor,
                          onSaved: (value) {
                            profileData['phone'] = value!.trim();
                          },
                          style: TextStyle(
                            color: Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 18,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (phone) {
                            if (phone != null && phone.isEmpty) {
                              return 'Phone number can\'t be empty';
                            } else if (num.tryParse(phone!) == null) {
                              return 'Phone number must be a number';
                            }
                            return null;
                          },
                          decoration: _inputDecoration('Telefono', context),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: data['address'] ?? '',
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: Theme.of(context).primaryColor,
                          onSaved: (value) {
                            profileData['address'] = value!.trim();
                          },
                          style: TextStyle(
                            color: Color(0xfff4b33c).withOpacity(0.7),
                            fontSize: 18,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (address) =>
                              address != null && address.isEmpty
                                  ? 'Address can\'t be empty'
                                  : null,
                          decoration: _inputDecoration('Direccion', context),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              final isValid = formKey.currentState!.validate();

                              if (!isValid) return;

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              );
                              formKey.currentState!.save();

                              try {
                                final ref = storage
                                    .ref()
                                    .child('user_image')
                                    .child('${user!.uid}.jpg');

                                if (_userImageFile != null) {
                                  await ref.putFile(_userImageFile!);
                                  final url = await ref.getDownloadURL();
                                  profileData['image_url'] = url;
                                }

                                await users.doc(user.uid).update(profileData);

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                context.goNamed('profile');
                              } on FirebaseException catch (e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                showTopSnackBar(
                                  Overlay.of(context) as OverlayState,
                                  CustomSnackBar.error(
                                    message: e.toString(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(180, 50),
                            ),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const LoadingSpinner();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText, BuildContext context) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle: TextStyle(color: Color(0xfff4b33c), fontSize: 22),
      labelStyle: TextStyle(
        color: Color(0xfff4b33c).withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c).withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c)),
        borderRadius: BorderRadius.circular(16),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c).withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
