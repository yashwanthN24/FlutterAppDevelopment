class QuizQuestion {
  const QuizQuestion(this.question, this.answers);

  final String question;
  final List<String> answers;

  List<String> getShuffledanswers() {
    final List<String> shuffled = List.of(answers);
    shuffled.shuffle(); // shuffles the list in place  
    // final means cantassign a new list but can modify existing list 
    return shuffled;
  }
}
