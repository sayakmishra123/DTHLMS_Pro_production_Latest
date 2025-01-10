class Option {
  final String optionId;
  final String questionId;
  final String sortedOrder;
  final String partialMarks;
  final String optionText;
  final String mCQPartialCorrectMarks;
  final String mCQPartialNegativeMarks;
  final String isCorrect;

  Option({
    required this.optionId,
    required this.questionId,
    required this.sortedOrder,
    required this.partialMarks,
    required this.optionText,
    required this.mCQPartialCorrectMarks,
    required this.mCQPartialNegativeMarks,
    required this.isCorrect
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionId: json['OptionId'].toString()??"0",
      questionId:json["QuestionId"].toString()??"0",
      sortedOrder: json['SortedOrder'].toString()??"0",
      partialMarks: json['PartialMarks'].toString()??"0",
      optionText: json['OptionName'].toString()??"0",
      mCQPartialCorrectMarks: json["MCQPartialCorrectMarks"].toString()??"0",
      mCQPartialNegativeMarks: json["MCQPartialNegativeMarks"].toString()??"0",
      isCorrect:json["IsCorrect"].toString()??"0"
    );
  }
}
//
//
class McqItem {
  final String questionId;
  final String isMultiple;
  final String mCQQuestionType;
  final String sectionId;
  final String sectionName;
  final String questionText;
  final String documnetUrl;
  final String answerExplanation;
  final String answerLink;
  final String answerDocumentId;
  final String answerDocumentUrl;
  final String passageDocumentUrl;
  final String passageLink;
  final String passageDocumentId;
  final String mCQQuestionDocumentId;
  final String mCQQuestionUrl;
  final String mCQQuestionTag;
  final String mCQQuestionMarks;
  final String passageDetails;
  


  final List<Option> options;
  


  

  McqItem( {
    required this.questionId,
    required this.isMultiple,
   required this.sectionId,
   required this.mCQQuestionType,
   required this.sectionName,
   required this.documnetUrl,
    required this.questionText,
   required this.answerExplanation,
    required this.answerLink,
    required  this.answerDocumentId,
    required  this.answerDocumentUrl,
    required   this.passageDocumentUrl,
     required   this.passageLink, 
      required  this.passageDocumentId,
       required this.mCQQuestionDocumentId,
      required   this.mCQQuestionUrl, 
       required  this.mCQQuestionTag, 
       required  this.mCQQuestionMarks,
       required this.passageDetails,

    required this.options,
  });

  factory McqItem.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List;
    List<Option> optionsList = optionsFromJson.map((i) => Option.fromJson(i)).toList();

    return McqItem(
      questionId: json['questionid'].toString(),
      isMultiple: json['isMultiple'].toString(),
      mCQQuestionType: json['MCQQuestionType'].toString(),
      sectionId: json['SectionId'].toString(),
      sectionName: json['SectionName'].toString(),
      documnetUrl: json["documentUrl"].toString(),
      questionText: json['Question'].toString(),
      answerExplanation:json['AnswerExplanation'].toString() ,
      answerLink: json['AnswerLink'].toString(),
      answerDocumentId: json['AnswerDocumentId'].toString(),
      answerDocumentUrl: json['AnswerDocumentUrl'].toString(),
      passageDocumentUrl: json['PassageDocumentUrl'].toString(),
      passageLink: json['PassageLink'].toString(),
      passageDocumentId: json['PassageDocumentId'].toString(),
      mCQQuestionDocumentId: json['MCQQuestionDocumentId'].toString(),
      mCQQuestionUrl: json['MCQQuestionUrl'].toString(),
      mCQQuestionTag: json['MCQQuestionTag'].toString(),  
      mCQQuestionMarks: json['MCQQuestionMarks'].toString(),
      passageDetails: json['PassageDetails'].toString(),
      
      



      
      options: optionsList,
    );
  }

  get answer => null;
}
