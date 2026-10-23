class Summery {
  const Summery({
    required this.question_index,
    required this.question,
    required this.user_answer,
    required this.correct_answer,
  });

  final int question_index;
  final String question, user_answer, correct_answer;
}
