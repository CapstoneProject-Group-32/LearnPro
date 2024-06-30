import 'package:google_generative_ai/google_generative_ai.dart';

class AIQuizService {
  final model = GenerativeModel(
      model: "gemini-1.5-pro-latest",
      apiKey: "AIzaSyCVvMSw88d29co-TsEBuREFbXFsaRmrwLU");

  Future<String> generateQuizContent(String flashcardContent) async {
    final prompt = """
    Imagine you are a quiz generator. Create a quiz based on the given content:
    $flashcardContent
    Ensure the JSON output is a valid array and properly formatted. Here is an example of the expected structure:
    [
      {
        "id": "1",
        "questionText": "Sample question?",
        "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
        "correctOptionIndex":" 0"
      },
      ...
    ]
""";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(
      content,
      generationConfig: GenerationConfig(
          temperature: 0.6,
          responseMimeType: "application/json",
          topP: 0.95,
          topK: 64),
    );
    return response.text ?? 'No content generated';
  }
}
