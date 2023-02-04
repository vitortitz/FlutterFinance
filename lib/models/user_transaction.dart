class UserTransaction {
  String? type;
  String? description;
  String? category;
  DateTime? date;
  double? value;

  UserTransaction(
      this.type, this.description, this.date, this.value, this.category);

  Map<String, dynamic> toJson() => {
        'type': type,
        'description': description,
        'date': date,
        'value': value,
        'category': category
      };
}
