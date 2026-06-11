/*
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    brand: Mapped[str] = mapped_column(String(100), nullable=False)
    model: Mapped[str] = mapped_column(String(100), nullable=False)
    engine_cc: Mapped[int] = mapped_column(Integer, nullable=False)
    model_year: Mapped[int] = mapped_column(Integer, nullable=False)
    fuel_type: Mapped[str] = mapped_column(String(50), nullable=False)
    expected_mileage: Mapped[float] = mapped_column(Float, nullable=False)
    tank_capacity: Mapped[float] = mapped_column(Float, nullable=False)
    reserve_capacity: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    image: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    # Moderation fields
    status: Mapped[str] = mapped_column(String(20), default="pending", nullable=False)  # pending, active, rejected
    submitted_by: Mapped[Optional[int]] = mapped_column(ForeignKey("users.id"), nullable=True)  # NULL for system bikes
    admin_note: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    # Legacy field - keep for backward compatibility
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
 */

import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@Entity(tableName: "bikes", indices: [Index(value: ["id"], unique: true)])
class BikeEntity {
  @PrimaryKey(autoGenerate: true)
  int? localId;

  final int id;
  final String brand;
  final String model;
  final int engineCc;
  final int modelYear;
  final String fuelType;
  final double expectedMileage;
  final double tankCapacity;
  final double? reserveCapacity;
  final String? image;

  final int? submittedBy;
  final String? adminNote;

  final bool isActive;
  final String createdAt;
  final String updatedAt;

  BikeEntity({
    this.localId,
    required this.id,
    required this.brand,
    required this.model,
    required this.engineCc,
    required this.modelYear,
    required this.fuelType,
    required this.expectedMileage,
    required this.tankCapacity,
    this.reserveCapacity,
    this.image,
    this.submittedBy,
    this.adminNote,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}