// ignore_for_file: unnecessary_string_interpolations, deprecated_member_use

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
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
    {
      "question": "Lorem ipsum dolor sit amet?",
      "answer":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis eros tortor, blandit ut nunc in, interdum consectetur risus. Fusce bibendum porttitor condimentum. Suspendisse scelerisque eros a condimentum aliquam.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "FAQs",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
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
