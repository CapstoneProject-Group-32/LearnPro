import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeAIService {
  final model = GenerativeModel(
      model: "gemini-1.5-pro-latest", apiKey: dotenv.env['APIKEY']!);

  Future<String> generateFlashcardContent(
      String subject, String topic, String points) async {
    final prompt = """
    Imagine you are a teacher that have a great knowledge of about huge variety of subjects in education.
You recommend your students to follow a study method which is creating flash cards to based on the content that they study.
Create few flash cards for me based on the content I have studied. It would be better I could revise my knowledge beginning to end using these flash cards, I have provided you the details about content that I studied below.
Make sure to cover everything that I studied and provide accurate information when you are creating flash card.
I am going to store flash cards you created in a mobile app that I use. I can input a title and a body for the flash card.
So flash cards you create must have two parts, title and the body. A question or a concept or a relevant subtopic to define can be included in the title. A definition or an answer or a short description should be included in the body. The content for the body should be short (less than 80 words). If it was long content for body ,I won’t be able to enter in my mobile app and display.
 Some flash can be question and answer,
some flashcards can be concept and definition. Some flashcards can be sentences and explanation.
Let me explain about the content that I studied
the subject I studied is $subject
the topic under that subject is $topic
under that main topic this is a list of subtopics and points under each of those subtopics. $points
 don’t give any other information in the result only flash cards should be included as I mentioned earlier title and body.





Ensure the JSON output is a valid array and properly formatted. Here is an example of the expected structure:

[
  {"flashcardNumber": 1, "title": "Title 1", "body": "Content 1"},
  {"flashcardNumber": 2, "title": "Title 2", "body": "Content 2"},
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
