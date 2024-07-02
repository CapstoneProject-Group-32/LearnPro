import 'package:google_generative_ai/google_generative_ai.dart';

class AIQuizService {
  final model = GenerativeModel(
      model: "gemini-1.5-pro-latest",
      apiKey: "AIzaSyCVvMSw88d29co-TsEBuREFbXFsaRmrwLU");

  Future<String> generateQuizContent(String flashcardContent) async {
    final prompt = """
    Imagine you are a professional quiz generator. Your task is to create a set of 10 quizzes based on the provided flashcard content. Each quiz should consist of  questions that are engaging and creative, ensuring the following criteria are met:

1. **Content-Based Questions:** Generate questions that accurately reflect the core information of the flashcard content.
2. **Concise Options:** Ensure that each answer option is concise, with a word count not exceeding 12 words.
3. **Variety and Creativity:** Vary the types of questions to include multiple-choice, true/false, and matching pairs to enhance engagement.
4. **Clear and Understandable:** Make sure the questions and options are clear, avoiding ambiguity.
5. **Educational Value:** The quizzes should be educational and help users reinforce their understanding of the content.
6. **Consistent Difficulty:** Maintain a consistent difficulty level across all questions, appropriate for the target audience.
7. **Diverse Topics:** If the flashcard content covers multiple topics, ensure that the questions cover a diverse range of these topics.

Here is the flashcard content:
    $flashcardContent

Please generate 10 quizzes that adhere to these guidelines.

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
