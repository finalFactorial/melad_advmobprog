import 'package:flutter/material.dart';
import '../constants.dart';
import 'custom_button.dart';
import 'custom_font.dart';
import 'custom_textformfield.dart';

class CustomDialogs {
  static void showCreatePostModal(BuildContext context, {required Function(String body) onPostCreated}) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomFont(
                    text: 'Create Post',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=12'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomFont(
                        text: 'Mark Zuckerberg',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.public, size: 12, color: FBColors.textSecondary),
                            SizedBox(width: 4),
                            CustomFont(
                              text: 'Public',
                              fontSize: 12,
                              color: FBColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: controller,
                hintText: "What's on your mind?",
                maxLines: 4,
                isFilled: false,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Post',
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    onPostCreated(controller.text.trim());
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  static void showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CustomFont(text: title, fontWeight: FontWeight.bold, fontSize: 18),
          content: CustomFont(text: message, fontSize: 14),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CustomFont(text: 'Cancel', color: FBColors.textSecondary),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: FBColors.primaryBlue),
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const CustomFont(text: 'Confirm', color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }
}