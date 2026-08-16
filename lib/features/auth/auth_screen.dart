import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authProvider);

      if (authState.isSignUp &&
          _passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match!'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final success = await ref.read(authProvider.notifier).submitAuth(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: authState.isSignUp ? _nameController.text.trim() : null,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authState.isSignUp
                  ? 'Account created successfully! Welcome aboard.'
                  : 'Welcome back! Signed in successfully.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background ambient glowing gradients
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.25),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // Main Center Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Logo & Branding
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_person_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        authState.isSignUp ? 'Create an Account' : 'Welcome Back',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        authState.isSignUp
                            ? 'Sign up to start managing your inventory'
                            : 'Enter your credentials to access your portal',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Sign In / Sign Up Segmented Selector
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (authState.isSignUp) {
                                    ref.read(authProvider.notifier).toggleAuthMode();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: !authState.isSignUp
                                        ? AppColors.primaryGradient
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      color: !authState.isSignUp
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (!authState.isSignUp) {
                                    ref.read(authProvider.notifier).toggleAuthMode();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: authState.isSignUp
                                        ? AppColors.primaryGradient
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: authState.isSignUp
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Error message banner if any
                      if (authState.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.error),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authState.errorMessage!,
                                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Form Fields
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: Column(
                          children: [
                            if (authState.isSignUp) ...[
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  hintText: 'John Doe',
                                  prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted),
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Please enter your name'
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  hintText: '+1 (555) 000-0000',
                                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.textMuted),
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                                hintText: 'name@company.com',
                                prefixIcon: Icon(Icons.mail_outline, color: AppColors.textMuted),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Email is required';
                                if (!v.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),

                            const SizedBox(height: 14),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !authState.isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    authState.isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textMuted,
                                  ),
                                  onPressed: () => ref
                                      .read(authProvider.notifier)
                                      .togglePasswordVisibility(),
                                ),
                              ),
                              validator: (v) => v == null || v.length < 6
                                  ? 'Password must be at least 6 characters'
                                  : null,
                            ),

                            if (authState.isSignUp) ...[
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: !authState.isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(Icons.lock_reset, color: AppColors.textMuted),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      authState.isConfirmPasswordVisible
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.textMuted,
                                    ),
                                    onPressed: () => ref
                                        .read(authProvider.notifier)
                                        .toggleConfirmPasswordVisibility(),
                                  ),
                                ),
                                validator: (v) {
                                  if (v != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Remember Me & Forgot Password Row
                      if (!authState.isSignUp)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: authState.rememberMe,
                                  activeColor: AppColors.primary,
                                  onChanged: (v) => ref
                                      .read(authProvider.notifier)
                                      .toggleRememberMe(v),
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password reset link sent to your email!'),
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.primaryAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // Submit Primary Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 4,
                            shadowColor: AppColors.primary.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  authState.isSignUp ? 'Create Account' : 'Sign In',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Divider "Or continue with"
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR CONTINUE WITH',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Social Login Icons Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              icon: FontAwesomeIcons.google,
                              label: 'Google',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSocialButton(
                              icon: FontAwesomeIcons.apple,
                              label: 'Apple',
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSocialButton(
                              icon: FontAwesomeIcons.github,
                              label: 'GitHub',
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
