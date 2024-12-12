import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe/auth/auth_service.dart';
import 'package:recipe/const/app_styles.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final authService = AuthService();

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
              top: height * 0.45,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: height * 0.5,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSizes.spaceBetweenWidget),
                      const Text(
                        "Sign in Your Account",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.heading,
                      ),
                      const SizedBox(height: AppSizes.spaceBetweenWidget * 2),
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
        height: height * 0.5,
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

  Widget _buildSocialMediaButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton("assets/auth/apple.png", "Apple"),
        const SizedBox(width: AppSizes.spaceBetweenWidget),
        _buildSocialButton("assets/auth/google.png", 'Google'),
        // const SizedBox(width: AppSizes.spaceBetweenWidget),
        // _buildSocialButton("assets/auth/facebook.png", 'Facebook'),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Google') authService.googleSignIn();
        if (title == 'Apple') authService.appleSignIn();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.inputColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(assetPath, height: 30),
            SizedBox(
                width: 200,
                child: Text("Continue with $title", style: AppTextStyles.body))
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpPrompt() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        SizedBox(width: 10),
        Text(
          "Skip",
          style: AppTextStyles.textSign,
        ),
      ],
    );
  }
}
