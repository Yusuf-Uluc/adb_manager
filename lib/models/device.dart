import 'dart:convert';

class Device {
  final String name;
  final String ipv4;

  Device({
    required this.name,
    required this.ipv4,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ipv4': ipv4,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      name: map['name'],
      ipv4: map['ipv4'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Device.fromJson(String source) => Device.fromMap(json.decode(source));

  Device copyWith({
    String? name,
    String? ipv4,
  }) {
    return Device(
      name: name ?? this.name,
      ipv4: ipv4 ?? this.ipv4,
    );
  }

  @override
  String toString() => 'Device(name: $name, ipv4: $ipv4)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Device && other.name == name && other.ipv4 == ipv4;
  }

  @override
  int get hashCode => name.hashCode ^ ipv4.hashCode;
}
