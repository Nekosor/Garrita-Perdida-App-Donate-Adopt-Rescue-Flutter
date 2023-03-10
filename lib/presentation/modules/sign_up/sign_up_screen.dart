import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queen_validators/queen_validators.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/styles/colors.dart';
import '../../../shared/constants.dart';
import '../login/login_screen.dart';
import 'cubit/sign_up_cubit.dart';
import 'cubit/sign_up_states.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNoController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit, SignUpStates>(
        listener: (BuildContext context, state) {
          if (state is CreateUserSuccessState) {
            navigateAndFinish(context, LoginScreen());
          }
        },
        builder: (BuildContext context, Object? state) {
          return Scaffold(
            //resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BuildHeader(title: 'Registrate'),
                        sizedBox12,
                        const BuildSecondHeader(
                            title: 'Agrega tus datos para registrarte'),
                        sizedBox28,
                        DefaultTextFormField(
                          context: context,
                          hintText: 'nombre',
                          validator: qValidator([
                             IsRequired(),
                          ]),
                          controller: nameController,
                          type: TextInputType.name,
                        ),
                        sizedBox12,
                        DefaultTextFormField(
                          context: context,
                          hintText: 'correo electronico',
                          validator: qValidator([
                             IsRequired(),
                            const IsEmail(),
                          ]),
                          controller: emailController,
                          type: TextInputType.emailAddress,
                        ),
                        sizedBox12,
                        DefaultTextFormField(
                          context: context,
                          hintText: 'Nro. de celular',
                          validator: qValidator([
                            IsRequired(),
                            IsEgyptianPhone(),
                          ]),
                          controller: mobileNoController,
                          type: TextInputType.number,
                        ),
                        sizedBox12,
                        DefaultTextFormField(
                          context: context,
                          hintText: 'Distrito',
                          validator: qValidator([
                            IsRequired(),
                          ]),
                          controller: addressController,
                          type: TextInputType.streetAddress,
                        ),
                        sizedBox12,
                        DefaultTextFormField(
                          context: context,
                          hintText: 'Password',
                          validator: qValidator([
                           IsRequired(),
                             MinLength(6),
                          ]),
                          controller: passwordController,
                          type: TextInputType.text,
                        ),
                        sizedBox12,
                        DefaultTextFormField(
                          context: context,
                          hintText: 'Confirmar Password',
                          validator: (String? value) {
                            if (value != passwordController.text) {
                              return 'La Password tiene que ser igual';
                            }
                          },
                          controller: confirmPasswordController,
                          type: TextInputType.text,
                        ),
                        sizedBox15,
                        BuildCondition(
                          condition: state is! RegisterUserLoadingsState,
                          builder: (context) => DefaultButton(
                            color: mainColor,
                            title: 'Registrar',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                SignUpCubit.get(context).registerUser(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: mobileNoController.text,
                                  address: addressController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          ),
                          fallback: (context) =>
                              const CircularProgressIndicator(),
                        ),
                        sizedBox15,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const BuildSecondHeader(
                              title: 'Ya tienes una cuenta?',
                            ),
                            DefaultTextButton(
                              child: 'Login',
                              onPressed: () {
                                navigateTo(context, LoginScreen());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
