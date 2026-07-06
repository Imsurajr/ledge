import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ledge/features/auth/presentation/widgets/add_user_dialog.dart';
import 'package:ledge/features/auth/presentation/widgets/loading_column.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  void getUsers() {
    context.read<AuthCubit>().getUsers();
  }

  /// this code block below means
  @override
  void initState() {
    /// once the screen gets built
    super.initState();

    /// call the get users from bloc
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        /// listener we will use to show snackbars
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is UserCreatedState) {
          /// now no matter what state the screen is in as soon as we call get users the body's state is GettingUsersState will get
          /// triggered and again circular indicator will be shown while the list loads
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          /// state based messages
          body: state is GettingUsersState
              ? LoadingColumn(message: 'Fetching Users')
              : state is CreatingUserState
              ? LoadingColumn(message: 'Creating User')
              : state is UsersLoadedState
              ? Center(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      /// getting a single user from list
                      final user = state.users[index];
                      return ListTile(
                        leading: Image.network(user.avatar),
                        title: Text(user.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        subtitle: Text(user.createdAt.substring(10), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                      );
                    },
                    itemCount: state.users.length,
                  ),
                )
              : SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) =>
                    AddUserDialog(nameController: nameController),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        );
      },
    );
  }
}
