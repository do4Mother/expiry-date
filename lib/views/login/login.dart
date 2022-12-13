import 'package:expiry/utils/constant.dart';
import 'package:expiry/views/login/widgets/social_button.dart';
import 'package:expiry/views/sign-up/sign-up.dart';
import 'package:expiry/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String routeName = '/login';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: kPaddingListView,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign In',
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
              ElevatedButton(
                onPressed: () {},
                child: const Text('Sign in'),
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
    );
  }
}
