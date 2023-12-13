class UserModel {
  Embedded? eEmbedded;
  Page? page;
  String? error;

  UserModel({this.eEmbedded, this.page, this.error});

  UserModel.fromJson(Map<String, dynamic> json) {
    eEmbedded =
        json['_embedded'] != null ? Embedded.fromJson(json['_embedded']) : null;
    page = json['page'] != null ? Page.fromJson(json['page']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eEmbedded != null) {
      data['_embedded'] = eEmbedded!.toJson();
    }
    if (page != null) {
      data['page'] = page!.toJson();
    }
    return data;
  }

  UserModel.withError(String errorValue)
      : eEmbedded = null,
        page = null,
        error = errorValue;
}

class Embedded {
  List<User>? user;

  Embedded({this.user});

  Embedded.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Page {
  int? size;
  int? totalElements;
  int? totalPages;
  int? number;

  Page({this.size, this.totalElements, this.totalPages, this.number});

  Page.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['size'] = size;
    data['totalElements'] = totalElements;
    data['totalPages'] = totalPages;
    data['number'] = number;
    return data;
  }
}

class User {
  int? id;
  String? token;
  String? type;
  String? nim;
  String? email;
  String? name;
  String? password;
  List<String>? role;
  Links? links;
  String? error;

  User(
      {this.id,
      this.nim,
      this.email,
      this.name,
      this.password,
      this.role,
      this.links});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    token = json['token'];
    type = json['type'];
    nim = json['nim'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    role = json['roles'] == null
        ? []
        : List<String>.from(json["roles"].map((x) => x));
    links = json['_links'] != null ? Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nim'] = nim;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['roles'] = role;
    if (links != null) {
      data['_links'] = links!.toJson();
    }
    return data;
  }

  User.withError(String errorValue)
      : nim = null,
        email = null,
        name = null,
        password = null,
        role = List.empty(),
        error = errorValue;
}

class Links {
  Self? self;
  Self? user;
  Self? nilai;
  Self? roles;
  Self? ips;

  Links({this.self, this.user, this.nilai, this.roles, this.ips});

  Links.fromJson(Map<String, dynamic> json) {
    self = json['self'] != null ? Self.fromJson(json['self']) : null;
    user = json['user'] != null ? Self.fromJson(json['user']) : null;
    nilai = json['nilai'] != null ? Self.fromJson(json['nilai']) : null;
    roles = json['roles'] != null ? Self.fromJson(json['roles']) : null;
    ips = json['ips'] != null ? Self.fromJson(json['ips']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (self != null) {
      data['self'] = self!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (nilai != null) {
      data['nilai'] = nilai!.toJson();
    }
    if (roles != null) {
      data['roles'] = roles!.toJson();
    }
    if (ips != null) {
      data['ips'] = ips!.toJson();
    }
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}
