import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveUserProfile({required String name, String? photoUrl}) async {
    await _firestore.collection('users').doc(_uid).set({
      'name': name,
      if (photoUrl != null) 'photoUrl': photoUrl,
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final doc = await _firestore.collection('users').doc(_uid).get();
    return doc.exists ? doc.data() : null;
  }

  // Future<String> uploadProfilePhoto(File imageFile) async {
  //   final ref = FirebaseStorage.instance
  //       .ref()
  //       .child('profile_photos')
  //       .child('$_uid.jpg');
  //   await ref.putFile(imageFile);
  //   return await ref.getDownloadURL();
  // }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  String? _profilePhotoUrl;
  ImagePicker? _picker;
  bool _isLoading = false;
  bool _isImagePickerInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeImagePicker();
    _loadUserData();
  }

  Future<void> _initializeImagePicker() async {
    try {
      _picker = ImagePicker();
      setState(() {
        _isImagePickerInitialized = true;
      });
    } catch (e) {
      setState(() {
        _isImagePickerInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await UserService().getUserProfile();
      setState(() {
        _nameController.text = userData?['name'] ?? '';
        if (userData?['photoUrl'] != null) {
          _profilePhotoUrl = userData!['photoUrl'];
        }
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await UserService().saveUserProfile(
        name: _nameController.text.trim(),
        photoUrl: _profilePhotoUrl,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    if (!_isImagePickerInitialized || _picker == null) {
      await _initializeImagePicker();
      if (_picker == null) return;
    }
    try {
      final XFile? image = await _picker!.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        // Upload to Firebase Storage and save URL in Firestore
        // final photoUrl = await UserService().uploadProfilePhoto(
        //   _selectedImage!,
        // );
        // setState(() {
        //   _profilePhotoUrl = photoUrl;
        // });
        await UserService().saveUserProfile(
          name: _nameController.text.trim(),
          // photoUrl: photoUrl,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Handle error as before
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Profile Management',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Photo Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (_profilePhotoUrl != null
                                        ? NetworkImage(_profilePhotoUrl!)
                                        : null)
                                    as ImageProvider?,
                          child:
                              (_selectedImage == null &&
                                  _profilePhotoUrl == null)
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _showImageSourceDialog,
                    child: const Text(
                      'Change Profile Photo',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Username Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
