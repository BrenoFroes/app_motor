class Survey {
  int id;
  int user;
  int vehicle;
  String local;
  String createdDate;

  Survey({this.id, this.user, this.vehicle, this.local, this.createdDate});

  // Converte um objeto JSON em um objeto Survey
  Survey.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    vehicle = json['vehicle'];
    local = json['local'];
    createdDate = json['createdDate'];
  }

  // Converte um objeto Survey em um objeto JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['vehicle'] = this.vehicle;
    data['local'] = this.local;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
