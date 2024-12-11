import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe/const/app_styles.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            // Foreground Card
            _buildHeaderImage(height, width),
            Positioned(
              top: height * 0.25,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: height * 0.75,
                padding: const EdgeInsets.only(left: 20, right: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.borderRadiusSecondary),
                    topRight: Radius.circular(AppSizes.borderRadiusSecondary),
                  ),
                  color: AppColors.background,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      const Text(
                        "Sign in Your Account",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading,
                      ),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      _buildInputField(
                        label: "Enter Your Email",
                        icon: Icons.email,
                        isPassword: false,
                      ),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      _buildInputField(
                        label: "Enter Your Password",
                        icon: Icons.lock,
                        isPassword: true,
                        onVisibilityToggle: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        isPasswordVisible: isPasswordVisible,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "Forget Password?",
                            style: AppTextStyles.textSign,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      _buildSignInButton(),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      const Center(child: Text("Or Sign in with")),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      _buildSocialMediaButtons(),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      _buildSignUpPrompt(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(double height, double width) {
    return Positioned(
      child: SizedBox(
        height: height * 0.3,
        width: width,
        child: ClipRRect(
          child: CachedNetworkImage(
            imageUrl:
                "https://media.istockphoto.com/id/1352937979/photo/vegetable-storage.jpg?s=2048x2048&w=is&k=20&c=0nk02sPEhDEYwOWLHpELRCmTpbKBCYmQqwEIuLDfTS0=",
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, progress) => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, size: 40, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 0.4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.iconColor,
            size: AppSizes.iconSize,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: isPassword && !isPasswordVisible,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: AppSizes.iconSize,
                          color: AppColors.iconColor,
                        ),
                        onPressed: onVisibilityToggle,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.button,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Sign In',
          style: AppTextStyles.button,
        ),
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton("assets/auth/apple.png"),
        const SizedBox(width: AppSizes.spaceBetweenWidget),
        _buildSocialButton("assets/auth/google.png"),
        const SizedBox(width: AppSizes.spaceBetweenWidget),
        _buildSocialButton("assets/auth/facebook.png"),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      padding: const EdgeInsets.all(5),
      child: Image.asset(assetPath),
    );
  }

  Widget _buildSignUpPrompt() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        SizedBox(width: 10),
        Text(
          "Sign up",
          style: AppTextStyles.textSign,
        ),
      ],
    );
  }
}
