class PostFakeModel {
  List<PostData>? data;
  int? total;
  int? page;
  int? limit;

  PostFakeModel({this.data, this.total, this.page, this.limit});

  PostFakeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PostData>[];
      json['data'].forEach((v) {
        data!.add(PostData.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['page'] = page;
    data['limit'] = limit;
    return data;
  }
}

class PostData {
  String? id;
  String? image;
  int? likes;
  List<String>? tags;
  String? text;
  String? publishDate;
  Owner? owner;

  PostData(
      {this.id,
      this.image,
      this.likes,
      this.tags,
      this.text,
      this.publishDate,
      this.owner});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    likes = json['likes'];
    tags = json['tags'].cast<String>();
    text = json['text'];
    publishDate = json['publishDate'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['likes'] = likes;
    data['tags'] = tags;
    data['text'] = text;
    data['publishDate'] = publishDate;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    return data;
  }
}

class Owner {
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? picture;

  Owner({this.id, this.title, this.firstName, this.lastName, this.picture});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['picture'] = picture;
    return data;
  }

  String getFullOwnerName() {
    return "$title $firstName $lastName";
  }
}
