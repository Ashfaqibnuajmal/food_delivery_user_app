import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:food_user_app/features/home/logic/bloc/ai_chat_event.dart';
import 'package:food_user_app/features/home/logic/bloc/ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final String apiKey = "AIzaSyBY5c6Xoy95ohk65AsuTNMIeLlfqcMe8SQ";
  late GenerativeModel model;

  final List<String> allowedKeywords = [
    // 🧑‍🍳 Cooking Actions
    "cook", "recipe", "boil", "bake", "grill", "fry", "steam", "roast", "saute",
    "blend", "mix", "stir", "knead", "whisk", "chop", "slice", "dice", "peel",
    "marinate", "season", "toss", "simmer", "toast", "serve", "prepare",
    "measure", "heat", "microwave", "pressure cook", "instant pot", "slow cook",

    // 🍗 Foods & Dishes
    "meal", "food", "dish", "snack", "breakfast", "lunch", "dinner", "supper",
    "curry", "gravy", "rice", "biryani", "pulao", "fried rice", "noodles",
    "pasta", "pizza", "burger", "sandwich", "wrap", "roll", "omelette", "egg",
    "chicken", "mutton", "fish", "beef", "pork", "shrimp", "paneer", "tofu",
    "vegetable", "salad", "soup", "dal", "roti", "chapati", "paratha",
    "idli", "dosa", "uttapam", "upma", "poha", "vada", "pakora", "samosa",
    "chutney", "pickle", "puri", "bhaji", "sabzi", "korma", "tikka", "masala",
    "butter chicken", "chana", "rajma", "kebab", "cutlet", "pav bhaji",
    "momos", "spring roll", "fried chicken", "shawarma", "pancake", "waffle",

    // 🍰 Sweets & Desserts
    "sweet", "dessert", "cake", "cupcake", "cookie", "brownie", "pastry",
    "ice cream", "pudding", "custard", "laddu", "barfi", "halwa", "gulab jamun",
    "rasgulla", "jalebi", "payasam", "kheer", "cheesecake", "muffin",

    // 🥦 Ingredients
    "salt", "sugar", "flour", "oil", "butter", "ghee", "milk", "cream",
    "onion", "tomato", "garlic", "ginger", "chili", "pepper", "turmeric",
    "coriander", "cumin", "cardamom", "clove", "cinnamon", "mustard",
    "fenugreek",
    "basil", "oregano", "thyme", "parsley", "mint", "lemon", "vinegar",
    "soy sauce", "sauce", "ketchup", "mayonnaise", "yogurt", "cheese",
    "bread", "rice flour", "maida", "corn", "beans", "peas", "potato",
    "carrot", "spinach", "broccoli", "mushroom", "cabbage", "eggplant",
    "cauliflower", "zucchini",

    // 🌍 Cuisines
    "indian", "chinese", "italian", "thai", "mexican", "american",
    "arabic", "japanese", "korean", "continental", "south indian",
    "north indian", "kerala", "tamil", "malabar", "hyderabadi",

    // 🧂 Other related words
    "taste", "flavor", "spice", "herb", "ingredient", "kitchen", "utensil",
    "pan", "pot", "oven", "stove", "recipe book", "food blog", "chef",
    "restaurant", "hotel", "menu", "order", "serve", "plating", "presentation",
    "garnish", "nutrition", "calories", "diet", "healthy", "protein", "fiber",
    "vegan", "vegetarian", "non-veg", "gluten free", "low carb", "sugar free",
    "spicy", "sweet", "savory", "tangy", "crunchy", "crispy", "juicy", "sauce",
  ];

  AiChatBloc() : super(const AiChatInitial()) {
    model = GenerativeModel(model: 'gemini-2.5-pro', apiKey: apiKey);
    on<GenerateContentEvent>((event, emit) async {
      final updatedMessages = List<Map<String, dynamic>>.from(state.messages)
        ..add({'text': event.prompt, 'isUser': true});
      bool allowed = allowedKeywords.any(
        (keyword) => event.prompt.toLowerCase().contains(keyword.toLowerCase()),
      );

      if (!allowed) {
        updatedMessages.add({
          'text':
              " Sorry, only food and cooking-related questions are allowed. Please try asking something about recipes, ingredients, or cooking methods.",
          'isUser': false,
        });
        emit(AiChatLoaded(messages: updatedMessages));
        return; // Stop further processing
      }
      emit(
        AiChatLoading(messages: updatedMessages, loadingStage: "Thinking..."),
      );
      await Future.delayed(const Duration(seconds: 3));
      emit(
        AiChatLoading(messages: updatedMessages, loadingStage: "Analyzing..."),
      );
      await Future.delayed(const Duration(seconds: 3));
      emit(AiChatLoading(messages: updatedMessages, loadingStage: "Typing..."));
      await Future.delayed(const Duration(seconds: 3));
      try {
        final content = [Content.text(event.prompt)];
        final response = await model.generateContent(content);

        if (response.candidates.isNotEmpty) {
          updatedMessages.add({'text': response.text ?? "", 'isUser': false});
        } else {
          updatedMessages.add({'text': "No response found.", 'isUser': false});
        }

        emit(AiChatLoaded(messages: updatedMessages));
      } catch (error) {
        updatedMessages.add({
          'text': "Error: ${error.toString()}",
          'isUser': false,
        });
        emit(AiChatError(error: error.toString(), messages: updatedMessages));
      }
    });
  }
}
