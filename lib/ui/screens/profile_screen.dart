// 📄 profile_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/ui/widgets/custom_textformfield.dart';
import 'package:zunoa/providers/profile_provider.dart';
import 'package:intl/intl.dart';
import 'base_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedGender = 'Male';

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppTheme.primaryColor,
                onPrimary: Colors.white,
                surface: AppTheme.surfaceLight,
                onSurface: Colors.black87,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                ),
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseDatabase.instance
            .ref("users/$uid/profileImage")
            .set(base64Image);
        ref
            .read(profileProvider.notifier)
            .updateProfileImage('data:image/png;base64,$base64Image');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref.read(profileProvider.notifier).fetchProfileData();
      final profile = ref.read(profileProvider);
      _fullNameController.text = profile.fullName ?? '';
      _nickNameController.text = profile.nickName ?? '';
      _emailController.text = profile.email ?? '';
      _phoneController.text = profile.phone ?? '';
      _dobController.text = profile.dob ?? '';
      _selectedGender = profile.gender ?? 'Male';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = ref.watch(profileProvider);

    final isFormComplete =
        _fullNameController.text.isNotEmpty &&
        _nickNameController.text.isNotEmpty &&
        _selectedGender.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text("My Profile", style: theme.textTheme.titleLarge),
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        actions: [
          TextButton(
            onPressed:
                isFormComplete
                    ? () async {
                      await ref
                          .read(profileProvider.notifier)
                          .updateProfileData(
                            fullName: _fullNameController.text,
                            nickName: _nickNameController.text,
                            gender: _selectedGender,
                            dob: _dobController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            profileImageUrl: profile.profileImageUrl,
                          );
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const BaseScreen()),
                        );
                      }
                    }
                    : null,
            child: Text(
              "Save",
              style: theme.textTheme.labelLarge?.copyWith(
                color: isFormComplete ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      profile.profileImageUrl != null
                          ? MemoryImage(
                            base64Decode(
                              profile.profileImageUrl!.split(',').last,
                            ),
                          )
                          : null,
                  backgroundColor: theme.colorScheme.surface,
                  child:
                      profile.profileImageUrl == null
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          )
                          : null,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.indigo),
                    onPressed: _pickProfileImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            CustomTextFormField(
              controller: _fullNameController,
              label: "Full Name",
              hintText: "Enter your full name",
              prefixIcon: Icons.person,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _nickNameController,
              label: "Nick Name",
              hintText: "Enter your nickname",
              prefixIcon: Icons.tag,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                _buildGenderChip("Male"),
                _buildGenderChip("Female"),
                _buildGenderChip("Others"),
              ],
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _selectDate,
              child: AbsorbPointer(
                child: CustomTextFormField(
                  controller: _dobController,
                  label: "Date of Birth",
                  hintText: "DD/MM/YYYY",
                  prefixIcon: Icons.cake,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _emailController,
              label: "Email",
              hintText: "Enter your email",
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _phoneController,
              label: "Phone Number",
              hintText: "Enter your phone number",
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderChip(String label) {
    final bool isSelected = _selectedGender == label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      onSelected: (_) => setState(() => _selectedGender = label),
      backgroundColor: Colors.grey.shade200,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
