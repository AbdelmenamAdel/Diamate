class ChatbotQResponseModel {
  final String signal;
  final String? answer;
  final List<SourceChunk>? sourceChunks;

  const ChatbotQResponseModel({
    required this.signal,
    this.answer,
    this.sourceChunks,
  });
  factory ChatbotQResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatbotQResponseModel(
      signal: json["Signal"] ?? '',
      answer: json["answer"],
      sourceChunks: json["source_chunks"] != null
          ? List<SourceChunk>.from((json["source_chunks"] as List).map((x) => SourceChunk.fromJson(x)))
          : null,
    );
  }
}

class SourceChunk {
  final String text;
  final String fileId;
  final double score;
  final Map<String, dynamic> metaData;

  const SourceChunk({
    required this.text,
    required this.fileId,
    required this.score,
    required this.metaData,
  });
  factory SourceChunk.fromJson(Map<String, dynamic> json) {
    return SourceChunk(
      text: json["text"]?.toString() ?? '',
      fileId: json["file_id"]?.toString() ?? '',
      score: (json["score"] as num?)?.toDouble() ?? 0.0,
      metaData: json["metadata"] as Map<String, dynamic>? ?? {},
    );
  }
}

// {
//   "Signal": "Chat Response Generated Successfully",
//   "answer": "Type 2 diabetes symptoms include increased thirst, frequent urination, and fatigue...",
//   "source_chunks": [
//     {
//       "text": "Common symptoms of type 2 diabetes include...",
//       "file_id": "a1b2c3d4_diabetes_info.txt",
//       "score": 0.92,
//       "metadata": {}
//     }
//   ]
// }
