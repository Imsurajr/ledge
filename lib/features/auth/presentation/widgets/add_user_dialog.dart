import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ledge/features/auth/presentation/cubit/auth_cubit.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.nameController});
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Enter Your Name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  /// reading data from user i.e. name controller
                  const avatar =
                      'https://cdn.jsdelivr.net/gh/faker-js/assets-person-portrait/male/512/89.jpg';
                  final name = nameController.text.trim();
                  context.read<AuthCubit>().createUser(
                    createdAt: DateTime.now().toString(),
                    name: name,
                    avatar: avatar,
                  );
                  /// to close the dialog after adding user
                  Navigator.of(context).pop();
                },
                child: Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
