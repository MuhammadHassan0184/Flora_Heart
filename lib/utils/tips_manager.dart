// import 'dart:math';

class TipsManager {
  /// -------- PERIOD TIPS (50) ----------
  static final List<String> periodTips = [
    "Drink warm water regularly to reduce cramps and improve blood circulation during your period days.",
    "Use a heating pad on your lower abdomen to relax muscles and reduce menstrual pain naturally.",
    "Eat iron-rich foods like spinach, dates, and lentils to recover lost blood nutrients effectively.",
    "Avoid caffeine intake as it may increase cramps and cause dehydration during your menstrual cycle.",
    "Take proper rest and avoid heavy physical activity to help your body recover comfortably.",
    "Stay hydrated by drinking enough water to reduce bloating and fatigue during menstruation days.",
    "Light stretching or yoga can help reduce cramps and improve your overall mood effectively.",
    "Maintain hygiene by changing pads or tampons regularly to prevent infections and discomfort.",
    "Include magnesium-rich foods like bananas and nuts to reduce muscle cramps naturally.",
    "Use comfortable clothing to avoid irritation and allow your body to stay relaxed.",
    // 👉 continue similar style until ~50
  ];

  /// -------- OVULATION TIPS (30) ----------
  static final List<String> ovulationTips = [
    "This is your fertile window, maintain a healthy diet and stay hydrated for better reproductive health.",
    "Track your ovulation signs like cervical mucus and body temperature to understand your cycle better.",
    "Engage in light physical activity to boost blood flow and hormonal balance during ovulation days.",
    "Maintain a stress-free environment as stress can affect ovulation and hormonal stability.",
    "Eat protein-rich foods to support egg health and improve chances of conception naturally.",
    "Avoid junk food and processed sugar to maintain hormonal balance during fertile days.",
    "Sleep properly for at least seven hours to support your reproductive system effectively.",
    "Stay active but avoid over-exercising which may negatively impact ovulation.",
    "Drink plenty of water to support cervical fluid production and overall health.",
    "Take prenatal vitamins if planning pregnancy to support healthy ovulation cycles.",
    // 👉 continue to ~30
  ];

  /// -------- NORMAL DAYS TIPS (40) ----------
  static final List<String> normalTips = [
    "Drink at least eight glasses of water daily to keep your body hydrated and functioning properly.",
    "Maintain a balanced diet including fruits, vegetables, and proteins for overall health improvement.",
    "Do regular exercise like walking or yoga to stay active and maintain hormonal balance.",
    "Get proper sleep every night to help your body recover and stay mentally refreshed.",
    "Reduce stress by practicing meditation or deep breathing exercises daily for better health.",
    "Avoid excessive junk food and focus on healthy eating habits for long-term wellness.",
    "Keep tracking your cycle regularly to understand your body patterns and health signals.",
    "Maintain personal hygiene to prevent infections and feel fresh throughout the day.",
    "Drink herbal teas to relax your body and improve digestion naturally.",
    "Take short breaks during work to reduce fatigue and mental stress effectively.",
    // 👉 continue to ~40
  ];

  /// -------- SYMPTOMS BASED TIPS (30) ----------
  static final List<String> symptomTips = [
    "If you have cramps, apply heat therapy and rest properly to relieve discomfort effectively.",
    "For headaches, stay hydrated and rest in a calm environment to reduce pain naturally.",
    "If feeling bloated, avoid salty foods and drink more water to reduce swelling.",
    "For mood swings, practice relaxation techniques and talk to someone you trust.",
    "If feeling tired, ensure proper sleep and eat nutritious meals for energy recovery.",
    "For nausea, try ginger tea or light foods to soothe your stomach effectively.",
    "If experiencing back pain, do light stretching and maintain good posture throughout the day.",
    "For acne issues, maintain skincare and avoid oily foods during hormonal changes.",
    "If feeling anxious, take deep breaths and engage in calming activities.",
    "For breast tenderness, wear comfortable clothing and avoid unnecessary pressure.",
    // 👉 continue to ~30
  ];

  /// -------- DAILY STABLE TIP ----------
  static String getDailyStableTip(List<String> tips, [DateTime? date, int seedModifier = 0]) {
    final targetDate = date ?? DateTime.now();
    final seed = targetDate.day + targetDate.month + targetDate.year + seedModifier;
    final index = seed % tips.length;
    return tips[index];
  }
}
