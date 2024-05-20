import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeAIService {
  final model = GenerativeModel(model: 'gemini-pro', apiKey: "AIzaSyCVvMSw88d29co-TsEBuREFbXFsaRmrwLU");

  Future<String> generateFlashcardContent(String subject, String topic, String points) async {
    final prompt = 'Create a flashcard for $subject on the topic $topic covering these points: $points.';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text?? 'No content generated';
  }


}

