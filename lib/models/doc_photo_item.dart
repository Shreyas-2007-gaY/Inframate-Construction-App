class DocPhotoItem {
  String id;
  String title;
  String category;
  String photoUrl;
  String uploadDate;

  DocPhotoItem({
    required this.id,
    required this.title,
    required this.category,
    required this.photoUrl,
    required this.uploadDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'category': category,
    'photoUrl': photoUrl, 'uploadDate': uploadDate,
  };

  factory DocPhotoItem.fromJson(Map<String, dynamic> json) => DocPhotoItem(
    id: json['id'], title: json['title'], category: json['category'],
    photoUrl: json['photoUrl'], uploadDate: json['uploadDate'],
  );
}
