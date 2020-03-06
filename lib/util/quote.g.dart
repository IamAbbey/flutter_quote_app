// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final typeId = 0;

  @override
  Quote read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      quoteId: fields[0] as int,
      quoteAuthor: fields[2] as String,
      quoteBody: fields[1] as String,
      quoteTag: (fields[3] as List)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.quoteId)
      ..writeByte(1)
      ..write(obj.quoteBody)
      ..writeByte(2)
      ..write(obj.quoteAuthor)
      ..writeByte(3)
      ..write(obj.quoteTag);
  }
}
