// ignore_for_file: unnecessary_string_interpolations, deprecated_member_use

import 'package:floraheart/Widgets/custom_appbar.dart';
import 'package:floraheart/config/Colors/colors.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  int expandedIndex = 1; // default open item (02)

  final List<Map<String, String>> faqList = [
    {
      "question": "What is Flora Heart?",
      "answer":
          "Flora Heart is your personal health companion designed to help you track your menstrual cycle, understand your body's patterns, and stay informed about your reproductive health with ease and privacy.",
    },
    {
      "question": "How does the app predict my next period?",
      "answer":
          "The app uses sophisticated algorithms based on your historical cycle data. The more consistently you log your periods, the more accurate the predictions for your future cycles and fertile windows become.",
    },
    {
      "question": "Is my health data secure and private?",
      "answer":
          "Yes, absolutely. We prioritize your privacy. Your data is encrypted and securely stored. We do not share your personal health information with third parties without your explicit consent.",
    },
    {
      "question": "How do I log a new period?",
      "answer":
          "To log a period, simply go to the Calendar or Today screen and tap on the dates you want to mark. You can also add details about your flow, symptoms, and moods for a more comprehensive record.",
    },
    {
      "question": "Can I track symptoms like cramps or mood changes?",
      "answer":
          "Yes! Flora Heart allows you to log a wide variety of symptoms, moods, and activities daily. This helps you identify patterns and better understand how your cycle affects your overall well-being.",
    },
    {
      "question": "What should I do if my cycle is irregular?",
      "answer":
          "If your cycle is irregular, continue logging your data as accurately as possible. Flora Heart will adapt its predictions based on the variations in your cycle, though predictions may be less certain for irregular cycles.",
    },
    {
      "question": "How can I set up reminders?",
      "answer":
          "You can customize your notifications in the Settings or Profile section. You can set reminders for upcoming periods, ovulation days, or even daily health tips to keep you on track.",
    },
    {
      "question": "Can I export my cycle history for my doctor?",
      "answer":
          "Yes, you can generate a report of your cycle history from the Profile or Trends section, which can be easily shared with your healthcare provider during consultations.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "FAQs"
        ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: faqList.length,
            itemBuilder: (context, index) {
              bool isExpanded = expandedIndex == index;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        expandedIndex = isExpanded
                            ? -1
                            : index; // toggle open/close
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      color: isExpanded
                          ? const Color(0xffFCEBED) // light pink background
                          : Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${(index + 1).toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: isExpanded
                                  ? Colors.red
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  faqList[index]["question"]!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isExpanded
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                                if (isExpanded &&
                                    faqList[index]["answer"]!.isNotEmpty) ...[
                                  SizedBox(height: 12),
                                  Text(
                                    faqList[index]["answer"]!,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.close : Icons.add,
                            color: isExpanded
                                ? Colors.red
                                : Colors.grey.shade600,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index != faqList.length - 1)
                    Divider(height: 1, color: Colors.grey.shade200),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
