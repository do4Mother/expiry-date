import 'package:expiry/models/profile.dart';
import 'package:expiry/utils/constant.dart';
import 'package:expiry/utils/state_helper.dart';
import 'package:expiry/views/login/cubit/login/login_cubit.dart';
import 'package:expiry/views/login/widgets/social_button.dart';
import 'package:expiry/views/sign-up/sign-up.dart';
import 'package:expiry/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../app/bloc/authentication/authentication_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();

  onLogin() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final data = _formKey.currentState?.value ?? {};
      context.read<LoginCubit>().login(data['email'], data['password']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<LoginCubit, StateHelper<Profile>>(
      listener: (context, state) {
        state.listener(loaded: () {
          context.read<AuthenticationBloc>().add(UpdateProfile(profile: state.data!));
          Navigator.popUntil(context, (route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successfully!'),
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
                  'Login',
                  style: textTheme.headline4,
                ),
                Text(
                  'login easily using email or social media and get a variety of interesting features.',
                  style: textTheme.subtitle2,
                ),
                kVerticalLargeBox,
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
                  ],
                ),
                kVerticalMediumBox,
                BlocBuilder<LoginCubit, StateHelper<Profile>>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.status != Status.loading ? onLogin : null,
                      child: const Text('Login'),
                    );
                  },
                ),
                kVerticalMediumBox,
                Center(
                  child: Text(
                    'Or',
                    style: textTheme.bodySmall,
                  ),
                ),
                kVerticalMediumBox,
                SocialButton(
                  name: 'Google',
                  onPressed: () {},
                  image: Image.asset('assets/images/google-logo.png'),
                ),
                kVerticalSmallBox,
                SocialButton(
                  name: 'Facebook',
                  onPressed: () {},
                  image: Image.asset('assets/images/facebook-logo.png'),
                ),
                kVerticalMediumBox,
                Row(
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () => context.push(SignUpView.routeName),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                kVerticalTinyBox,
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Ink(
                        child: Text(
                          'Forgot your password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                kVerticalGiantBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
