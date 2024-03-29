import 'package:expiry/app/bloc/authentication/authentication_bloc.dart';
import 'package:expiry/models/profile.dart';
import 'package:expiry/utils/constant.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/sign-up/cubit/signup/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../widgets/text_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  static const String routeName = '/sign-up';

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormBuilderState>();

  onSignUp() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map<String, dynamic> data = Map.from(_formKey.currentState?.value ?? {});
      data.addAll({'id': ''});
      final profile = Profile.fromJson(data);
      context.read<SignUpCubit>().signUp(profile, data['password']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<SignUpCubit, StateHelper<Profile>>(
      listener: (context, state) {
        state.listener(loaded: () {
          context.read<AuthenticationBloc>().add(UpdateProfile(profile: state.data!));
          Navigator.popUntil(context, (route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up successfully!'),
            ),
          );
        }, error: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        });
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: kPaddingListView,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign Up',
                  style: textTheme.headline4,
                ),
                Text(
                  'sign up and get a variety of interesting features.',
                  style: textTheme.subtitle2,
                ),
                kVerticalLargeBox,
                AppTextField(
                  name: 'first_name',
                  title: 'First Name',
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                AppTextField(
                  name: 'last_name',
                  title: 'Last Name',
                  validators: [
                    FormBuilderValidators.required(),
                  ],
                ),
                AppTextField(
                  name: 'email',
                  title: 'Email',
                  validators: [
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required(),
                  ],
                ),
                AppTextField(
                  name: 'password',
                  title: 'Password',
                  obscureText: true,
                  validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ],
                ),
                kVerticalMediumBox,
                BlocBuilder<SignUpCubit, StateHelper<Profile>>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status != Status.loading ? onSignUp : null,
                      child: const Text('Sign up'),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
