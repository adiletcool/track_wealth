class PostModel {
  final int? id;
  final String? title;
  final String? body;

  PostModel({this.id, this.title, this.body});

  PostModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        body = json['body'];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': title,
      'body': body,
    };
  }
}
