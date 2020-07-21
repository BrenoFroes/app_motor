class Vehicle {
  int id;
  String plate;
  int year;
  String model;
  int mileage;
  String fuelType;
  bool turbo;

  Vehicle(
      {this.id,
      this.plate,
      this.year,
      this.model,
      this.mileage,
      this.fuelType,
      this.turbo});

  // Converte um objeto JSON em um objeto Survey
  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plate = json['plate'];
    year = json['year'];
    model = json['model'];
    mileage = json['mileage'];
    fuelType = json['fuelType'];
    turbo = json['turbo'];
  }

  // Converte um objeto Survey em um objeto JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plate'] = this.plate;
    data['year'] = this.year;
    data['model'] = this.model;
    data['mileage'] = this.mileage;
    data['fuelType'] = this.fuelType;
    data['turbo'] = this.turbo;
    return data;
  }
}
