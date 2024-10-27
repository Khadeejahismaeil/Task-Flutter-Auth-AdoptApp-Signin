import 'package:adopt_app/providers/pets_provider.dart';
import 'package:adopt_app/widgets/pet_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adopt"),
      ),
      drawer: Drawer(
        child: Consumer<AuthProvider>(
          builder: (context, auth, _) => ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: auth.isAuth
                    ? Text('Welcome, ${auth.user?.username ?? ''}')
                    : Text('Welcome! Please sign in.'),
              ),
              if (auth.isAuth)
                ListTile(
                  title: const Text('Sign Out'),
                  trailing: const Icon(Icons.logout),
                  onTap: () {
                    auth.signout();
                  },
                )
              else ...[
                ListTile(
                  title: const Text('Sign In'),
                  trailing: const Icon(Icons.login),
                  onTap: () {
                    GoRouter.of(context).push('/signin');
                  },
                ),
                ListTile(
                  title: const Text('Sign Up'),
                  trailing: const Icon(Icons.how_to_reg),
                  onTap: () {
                    GoRouter.of(context).push('/signup');
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push('/add');
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Add a new Pet"),
                ),
              ),
            ),
            FutureBuilder(
              future:
                  Provider.of<PetsProvider>(context, listen: false).getPets(),
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    return const Center(
                      child: Text('An error occurred'),
                    );
                  } else {
                    return Consumer<PetsProvider>(
                      builder: (context, petsProvider, child) =>
                          GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio:
                                    MediaQuery.of(context).size.width /
                                        (MediaQuery.of(context).size.height),
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: petsProvider.pets.length,
                              itemBuilder: (context, index) =>
                                  PetCard(pet: petsProvider.pets[index])),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
