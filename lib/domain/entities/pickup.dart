enum PickupStatus { pending, picked, expired, abnormal }

enum PickupSource { smsAuto, pasteImport, manual }

class Pickup {
  const Pickup({
    required this.code,
    this.stationName,
    this.expireAt,
    this.status = PickupStatus.pending,
    this.source = PickupSource.manual,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String code;
  final String? stationName;
  final DateTime? expireAt;
  final PickupStatus status;
  final PickupSource source;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Pickup copyWith({
    String? code,
    String? stationName,
    DateTime? expireAt,
    PickupStatus? status,
    PickupSource? source,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pickup(
      code: code ?? this.code,
      stationName: stationName ?? this.stationName,
      expireAt: expireAt ?? this.expireAt,
      status: status ?? this.status,
      source: source ?? this.source,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
