class Config {
  final String value;

  Config({
    required this.value,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      value: json['value'],
    );
  }
}
