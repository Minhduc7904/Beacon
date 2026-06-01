// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_group_detail_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMessageGroupDetailCacheCollection on Isar {
  IsarCollection<MessageGroupDetailCache> get messageGroupDetailCaches =>
      this.collection();
}

const MessageGroupDetailCacheSchema = CollectionSchema(
  name: r'MessageGroupDetailCache',
  id: 7410893555417908679,
  properties: {
    r'cacheKey': PropertySchema(
      id: 0,
      name: r'cacheKey',
      type: IsarType.string,
    ),
    r'cacheScopeUserId': PropertySchema(
      id: 1,
      name: r'cacheScopeUserId',
      type: IsarType.string,
    ),
    r'cachedAtUtc': PropertySchema(
      id: 2,
      name: r'cachedAtUtc',
      type: IsarType.dateTime,
    ),
    r'detailJson': PropertySchema(
      id: 3,
      name: r'detailJson',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 4,
      name: r'groupId',
      type: IsarType.string,
    )
  },
  estimateSize: _messageGroupDetailCacheEstimateSize,
  serialize: _messageGroupDetailCacheSerialize,
  deserialize: _messageGroupDetailCacheDeserialize,
  deserializeProp: _messageGroupDetailCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'cacheKey': IndexSchema(
      id: 5885332021012296610,
      name: r'cacheKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'cacheKey',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'cacheScopeUserId': IndexSchema(
      id: 8349032037920063017,
      name: r'cacheScopeUserId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cacheScopeUserId',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _messageGroupDetailCacheGetId,
  getLinks: _messageGroupDetailCacheGetLinks,
  attach: _messageGroupDetailCacheAttach,
  version: '3.1.0+1',
);

int _messageGroupDetailCacheEstimateSize(
  MessageGroupDetailCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheKey.length * 3;
  bytesCount += 3 + object.cacheScopeUserId.length * 3;
  bytesCount += 3 + object.detailJson.length * 3;
  bytesCount += 3 + object.groupId.length * 3;
  return bytesCount;
}

void _messageGroupDetailCacheSerialize(
  MessageGroupDetailCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheKey);
  writer.writeString(offsets[1], object.cacheScopeUserId);
  writer.writeDateTime(offsets[2], object.cachedAtUtc);
  writer.writeString(offsets[3], object.detailJson);
  writer.writeString(offsets[4], object.groupId);
}

MessageGroupDetailCache _messageGroupDetailCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MessageGroupDetailCache();
  object.cacheKey = reader.readString(offsets[0]);
  object.cacheScopeUserId = reader.readString(offsets[1]);
  object.cachedAtUtc = reader.readDateTime(offsets[2]);
  object.detailJson = reader.readString(offsets[3]);
  object.groupId = reader.readString(offsets[4]);
  object.id = id;
  return object;
}

P _messageGroupDetailCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _messageGroupDetailCacheGetId(MessageGroupDetailCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _messageGroupDetailCacheGetLinks(
    MessageGroupDetailCache object) {
  return [];
}

void _messageGroupDetailCacheAttach(
    IsarCollection<dynamic> col, Id id, MessageGroupDetailCache object) {
  object.id = id;
}

extension MessageGroupDetailCacheByIndex
    on IsarCollection<MessageGroupDetailCache> {
  Future<MessageGroupDetailCache?> getByCacheKey(String cacheKey) {
    return getByIndex(r'cacheKey', [cacheKey]);
  }

  MessageGroupDetailCache? getByCacheKeySync(String cacheKey) {
    return getByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<bool> deleteByCacheKey(String cacheKey) {
    return deleteByIndex(r'cacheKey', [cacheKey]);
  }

  bool deleteByCacheKeySync(String cacheKey) {
    return deleteByIndexSync(r'cacheKey', [cacheKey]);
  }

  Future<List<MessageGroupDetailCache?>> getAllByCacheKey(
      List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheKey', values);
  }

  List<MessageGroupDetailCache?> getAllByCacheKeySync(
      List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheKey', values);
  }

  Future<int> deleteAllByCacheKey(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheKey', values);
  }

  int deleteAllByCacheKeySync(List<String> cacheKeyValues) {
    final values = cacheKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheKey', values);
  }

  Future<Id> putByCacheKey(MessageGroupDetailCache object) {
    return putByIndex(r'cacheKey', object);
  }

  Id putByCacheKeySync(MessageGroupDetailCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'cacheKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheKey(List<MessageGroupDetailCache> objects) {
    return putAllByIndex(r'cacheKey', objects);
  }

  List<Id> putAllByCacheKeySync(List<MessageGroupDetailCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheKey', objects, saveLinks: saveLinks);
  }
}

extension MessageGroupDetailCacheQueryWhereSort
    on QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QWhere> {
  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterWhere>
      anyCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheKey'),
      );
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterWhere>
      anyCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheScopeUserId'),
      );
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterWhere>
      anyGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'groupId'),
      );
    });
  }
}

extension MessageGroupDetailCacheQueryWhere on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QWhereClause> {
  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheKey',
        value: [cacheKey],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyNotEqualTo(String cacheKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [cacheKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheKey',
              lower: [],
              upper: [cacheKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyGreaterThan(
    String cacheKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheKey',
        lower: [cacheKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyLessThan(
    String cacheKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheKey',
        lower: [],
        upper: [cacheKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyBetween(
    String lowerCacheKey,
    String upperCacheKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheKey',
        lower: [lowerCacheKey],
        includeLower: includeLower,
        upper: [upperCacheKey],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyStartsWith(String CacheKeyPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheKey',
        lower: [CacheKeyPrefix],
        upper: ['$CacheKeyPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheKey',
        value: [''],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'cacheKey',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'cacheKey',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'cacheKey',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'cacheKey',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdEqualTo(String cacheScopeUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [cacheScopeUserId],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdNotEqualTo(String cacheScopeUserId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeUserId',
              lower: [],
              upper: [cacheScopeUserId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeUserId',
              lower: [cacheScopeUserId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeUserId',
              lower: [cacheScopeUserId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeUserId',
              lower: [],
              upper: [cacheScopeUserId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdGreaterThan(
    String cacheScopeUserId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [cacheScopeUserId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdLessThan(
    String cacheScopeUserId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [],
        upper: [cacheScopeUserId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdBetween(
    String lowerCacheScopeUserId,
    String upperCacheScopeUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [lowerCacheScopeUserId],
        includeLower: includeLower,
        upper: [upperCacheScopeUserId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterWhereClause>
      cacheScopeUserIdStartsWith(String CacheScopeUserIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [CacheScopeUserIdPrefix],
        upper: ['$CacheScopeUserIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [''],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'cacheScopeUserId',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'cacheScopeUserId',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'cacheScopeUserId',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'cacheScopeUserId',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdNotEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdGreaterThan(
    String groupId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [groupId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdLessThan(
    String groupId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [],
        upper: [groupId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdBetween(
    String lowerGroupId,
    String upperGroupId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [lowerGroupId],
        includeLower: includeLower,
        upper: [upperGroupId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdStartsWith(String GroupIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'groupId',
        lower: [GroupIdPrefix],
        upper: ['$GroupIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [''],
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterWhereClause> groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'groupId',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'groupId',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'groupId',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'groupId',
              upper: [''],
            ));
      }
    });
  }
}

extension MessageGroupDetailCacheQueryFilter on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QFilterCondition> {
  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      cacheKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      cacheKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheScopeUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      cacheScopeUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      cacheScopeUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheScopeUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cachedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cachedAtUtcGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cachedAtUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> cachedAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cachedAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detailJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detailJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detailJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detailJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'detailJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'detailJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      detailJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'detailJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      detailJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'detailJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detailJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> detailJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'detailJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
          QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MessageGroupDetailCacheQueryObject on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QFilterCondition> {}

extension MessageGroupDetailCacheQueryLinks on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QFilterCondition> {}

extension MessageGroupDetailCacheQuerySortBy
    on QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QSortBy> {
  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByDetailJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailJson', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByDetailJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailJson', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }
}

extension MessageGroupDetailCacheQuerySortThenBy on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QSortThenBy> {
  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByCacheKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByCacheKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheKey', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByDetailJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailJson', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByDetailJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailJson', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension MessageGroupDetailCacheQueryWhereDistinct on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QDistinct> {
  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QDistinct>
      distinctByCacheKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QDistinct>
      distinctByCacheScopeUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QDistinct>
      distinctByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAtUtc');
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QDistinct>
      distinctByDetailJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detailJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageGroupDetailCache, MessageGroupDetailCache, QDistinct>
      distinctByGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }
}

extension MessageGroupDetailCacheQueryProperty on QueryBuilder<
    MessageGroupDetailCache, MessageGroupDetailCache, QQueryProperty> {
  QueryBuilder<MessageGroupDetailCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MessageGroupDetailCache, String, QQueryOperations>
      cacheKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheKey');
    });
  }

  QueryBuilder<MessageGroupDetailCache, String, QQueryOperations>
      cacheScopeUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeUserId');
    });
  }

  QueryBuilder<MessageGroupDetailCache, DateTime, QQueryOperations>
      cachedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAtUtc');
    });
  }

  QueryBuilder<MessageGroupDetailCache, String, QQueryOperations>
      detailJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detailJson');
    });
  }

  QueryBuilder<MessageGroupDetailCache, String, QQueryOperations>
      groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }
}
