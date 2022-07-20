// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../../../objbox/model/image_model/image_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 5308121248242648713),
      name: 'ImageModel',
      lastPropertyId: const IdUid(3, 3121391119955178383),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7012247093690064576),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2232878416662428970),
            name: 'url',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3121391119955178383),
            name: 'imageData',
            type: 23,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 5308121248242648713),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    ImageModel: EntityDefinition<ImageModel>(
        model: _entities[0],
        toOneRelations: (ImageModel object) => [],
        toManyRelations: (ImageModel object) => {},
        getId: (ImageModel object) => object.id,
        setId: (ImageModel object, int id) {
          object.id = id;
        },
        objectToFB: (ImageModel object, fb.Builder fbb) {
          final urlOffset = fbb.writeString(object.url);
          final imageDataOffset = fbb.writeListInt8(object.imageData);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, urlOffset);
          fbb.addOffset(2, imageDataOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = ImageModel(
              imageData: const fb.Uint8ListReader(lazy: false)
                  .vTableGet(buffer, rootOffset, 8, Uint8List(0)) as Uint8List,
              url: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [ImageModel] entity fields to define ObjectBox queries.
class ImageModel_ {
  /// see [ImageModel.id]
  static final id =
      QueryIntegerProperty<ImageModel>(_entities[0].properties[0]);

  /// see [ImageModel.url]
  static final url =
      QueryStringProperty<ImageModel>(_entities[0].properties[1]);

  /// see [ImageModel.imageData]
  static final imageData =
      QueryByteVectorProperty<ImageModel>(_entities[0].properties[2]);
}
