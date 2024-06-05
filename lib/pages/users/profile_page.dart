import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:is_dpelicula/cubit/money_cubit.dart';
import 'package:is_dpelicula/widgets/loading_spinner.dart';
import 'package:is_dpelicula/widgets/profile_info.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final formatterCurrency =
      NumberFormat.currency(locale: "id_ID", symbol: "Rp ");

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
        body: SafeArea(
          child: BlocBuilder<MoneyCubit, MoneyState>(
            builder: (context, state) {
              return ListView(children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),
                          FutureBuilder<DocumentSnapshot>(
                              future: users.doc(user?.uid).get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data!.data()
                                      as Map<String, dynamic>;

                                  if ((data['image_url'] == null ||
                                      data['image_url'] == 'null')) {
                                    return const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          './assets/peaceMaker.jpg'),
                                      radius: 60,
                                    );
                                  }

                                  return CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data['image_url']),
                                    radius: 60,
                                  );
                                } else {
                                  return const LoadingSpinner();
                                }
                              }),
                          const SizedBox(height: 16),
                          state.when(
                            selected: (money) {
                              return Text(
                                money != 0
                                    ? formatterCurrency.format(money)
                                    : '',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                          // const SizedBox(height: 6),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     context.goNamed('topup');
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 40, vertical: 12),
                          //   ),
                          //   child: const Text(
                          //     'Top Up',
                          //     style: TextStyle(fontSize: 20),
                          //   ),
                          // ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Informacion de cuenta',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          FutureBuilder<DocumentSnapshot>(
                              future: users.doc(user?.uid).get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  return Column(
                                    children: [
                                      ProfileInfo(
                                          icon: Icons.person_rounded,
                                          title: 'Nombre',
                                          color: data['name'] == null
                                              ? Theme.of(context).primaryColor
                                              : Colors.white70,
                                          text:
                                              data['name'] ?? 'Not filled yet'),
                                      const SizedBox(height: 20),
                                      ProfileInfo(
                                          icon: Icons.email_rounded,
                                          title: 'Email',
                                          color: Colors.white70,
                                          text: data['email']),
                                      const SizedBox(height: 20),
                                      ProfileInfo(
                                          icon: Icons.phone_android_rounded,
                                          title: 'Telefono',
                                          color: data['phone'] == null
                                              ? Theme.of(context).primaryColor
                                              : Colors.white70,
                                          text: data['phone'] ??
                                              'Not filled yet'),
                                      const SizedBox(height: 20),
                                      ProfileInfo(
                                          icon: Icons.home,
                                          title: 'Direccion',
                                          color: data['address'] == null
                                              ? Theme.of(context).primaryColor
                                              : Colors.white70,
                                          text: data['address'] ??
                                              'Not filled yet'),
                                      const SizedBox(height: 30),
                                    ],
                                  );
                                } else {
                                  return const LoadingSpinner();
                                }
                              })
                        ]))
              ]);
            },
          ),
        ));
  }
}
