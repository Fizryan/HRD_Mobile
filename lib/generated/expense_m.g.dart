// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/expense_m.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseStatusAdapter extends TypeAdapter<ExpenseStatus> {
  @override
  final int typeId = 2;

  @override
  ExpenseStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseStatus.pending;
      case 1:
        return ExpenseStatus.approved;
      case 2:
        return ExpenseStatus.rejected;
      default:
        return ExpenseStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseStatus obj) {
    switch (obj) {
      case ExpenseStatus.pending:
        writer.writeByte(0);
        break;
      case ExpenseStatus.approved:
        writer.writeByte(1);
        break;
      case ExpenseStatus.rejected:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseCategoryAdapter extends TypeAdapter<ExpenseCategory> {
  @override
  final int typeId = 3;

  @override
  ExpenseCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExpenseCategory.operational;
      case 1:
        return ExpenseCategory.marketing;
      case 2:
        return ExpenseCategory.technology;
      case 3:
        return ExpenseCategory.employeeWelfare;
      default:
        return ExpenseCategory.operational;
    }
  }

  @override
  void write(BinaryWriter writer, ExpenseCategory obj) {
    switch (obj) {
      case ExpenseCategory.operational:
        writer.writeByte(0);
        break;
      case ExpenseCategory.marketing:
        writer.writeByte(1);
        break;
      case ExpenseCategory.technology:
        writer.writeByte(2);
        break;
      case ExpenseCategory.employeeWelfare:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpenseAdapter extends TypeAdapter<Expense> {
  @override
  final int typeId = 4;

  @override
  Expense read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expense(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as ExpenseCategory,
      amount: fields[3] as double,
      date: fields[4] as DateTime,
      status: fields[5] as ExpenseStatus,
      requestedByUsername: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Expense obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.requestedByUsername);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
