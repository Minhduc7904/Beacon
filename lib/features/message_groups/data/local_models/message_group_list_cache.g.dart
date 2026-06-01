// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_group_list_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMessageGroupListCacheCollection on Isar {
  IsarCollection<MessageGroupListCache> get messageGroupListCaches =>
      this.collection();
}

const MessageGroupListCacheSchema = CollectionSchema(
  name: r'MessageGroupListCache',
  id: -47041353572712653,
  properties: {
    r'cacheScopeUserId': PropertySchema(
      id: 0,
      name: r'cacheScopeUserId',
      type: IsarType.string,
    ),
    r'cachedAtUtc': PropertySchema(
      id: 1,
      name: r'cachedAtUtc',
      type: IsarType.dateTime,
    ),
    r'hasMore': PropertySchema(
      id: 2,
      name: r'hasMore',
      type: IsarType.bool,
    ),
    r'limit': PropertySchema(
      id: 3,
      name: r'limit',
      type: IsarType.long,
    ),
    r'nextCursor': PropertySchema(
      id: 4,
      name: r'nextCursor',
      type: IsarType.string,
    )
  },
  estimateSize: _messageGroupListCacheEstimateSize,
  serialize: _messageGroupListCacheSerialize,
  deserialize: _messageGroupListCacheDeserialize,
  deserializeProp: _messageGroupListCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'cacheScopeUserId': IndexSchema(
      id: 8349032037920063017,
      name: r'cacheScopeUserId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'cacheScopeUserId',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _messageGroupListCacheGetId,
  getLinks: _messageGroupListCacheGetLinks,
  attach: _messageGroupListCacheAttach,
  version: '3.1.0+1',
);

int _messageGroupListCacheEstimateSize(
  MessageGroupListCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheScopeUserId.length * 3;
  {
    final value = object.nextCursor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _messageGroupListCacheSerialize(
  MessageGroupListCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheScopeUserId);
  writer.writeDateTime(offsets[1], object.cachedAtUtc);
  writer.writeBool(offsets[2], object.hasMore);
  writer.writeLong(offsets[3], object.limit);
  writer.writeString(offsets[4], object.nextCursor);
}

MessageGroupListCache _messageGroupListCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MessageGroupListCache();
  object.cacheScopeUserId = reader.readString(offsets[0]);
  object.cachedAtUtc = reader.readDateTime(offsets[1]);
  object.hasMore = reader.readBool(offsets[2]);
  object.id = id;
  object.limit = reader.readLong(offsets[3]);
  object.nextCursor = reader.readStringOrNull(offsets[4]);
  return object;
}

P _messageGroupListCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _messageGroupListCacheGetId(MessageGroupListCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _messageGroupListCacheGetLinks(
    MessageGroupListCache object) {
  return [];
}

void _messageGroupListCacheAttach(
    IsarCollection<dynamic> col, Id id, MessageGroupListCache object) {
  object.id = id;
}

extension MessageGroupListCacheByIndex
    on IsarCollection<MessageGroupListCache> {
  Future<MessageGroupListCache?> getByCacheScopeUserId(
      String cacheScopeUserId) {
    return getByIndex(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  MessageGroupListCache? getByCacheScopeUserIdSync(String cacheScopeUserId) {
    return getByIndexSync(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  Future<bool> deleteByCacheScopeUserId(String cacheScopeUserId) {
    return deleteByIndex(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  bool deleteByCacheScopeUserIdSync(String cacheScopeUserId) {
    return deleteByIndexSync(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  Future<List<MessageGroupListCache?>> getAllByCacheScopeUserId(
      List<String> cacheScopeUserIdValues) {
    final values = cacheScopeUserIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheScopeUserId', values);
  }

  List<MessageGroupListCache?> getAllByCacheScopeUserIdSync(
      List<String> cacheScopeUserIdValues) {
    final values = cacheScopeUserIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheScopeUserId', values);
  }

  Future<int> deleteAllByCacheScopeUserId(List<String> cacheScopeUserIdValues) {
    final values = cacheScopeUserIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheScopeUserId', values);
  }

  int deleteAllByCacheScopeUserIdSync(List<String> cacheScopeUserIdValues) {
    final values = cacheScopeUserIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheScopeUserId', values);
  }

  Future<Id> putByCacheScopeUserId(MessageGroupListCache object) {
    return putByIndex(r'cacheScopeUserId', object);
  }

  Id putByCacheScopeUserIdSync(MessageGroupListCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'cacheScopeUserId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheScopeUserId(
      List<MessageGroupListCache> objects) {
    return putAllByIndex(r'cacheScopeUserId', objects);
  }

  List<Id> putAllByCacheScopeUserIdSync(List<MessageGroupListCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheScopeUserId', objects,
        saveLinks: saveLinks);
  }
}

extension MessageGroupListCacheQueryWhereSort
    on QueryBuilder<MessageGroupListCache, MessageGroupListCache, QWhere> {
  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhere>
      anyCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheScopeUserId'),
      );
    });
  }
}

extension MessageGroupListCacheQueryWhere on QueryBuilder<MessageGroupListCache,
    MessageGroupListCache, QWhereClause> {
  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdEqualTo(String cacheScopeUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [cacheScopeUserId],
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdNotEqualTo(String cacheScopeUserId) {
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdGreaterThan(
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdLessThan(
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdBetween(
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdStartsWith(String CacheScopeUserIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [CacheScopeUserIdPrefix],
        upper: ['$CacheScopeUserIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [''],
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterWhereClause>
      cacheScopeUserIdIsNotEmpty() {
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
}

extension MessageGroupListCacheQueryFilter on QueryBuilder<
    MessageGroupListCache, MessageGroupListCache, QFilterCondition> {
  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> cachedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> hasMoreEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasMore',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
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

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> limitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'limit',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> limitGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'limit',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> limitLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'limit',
        value: value,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> limitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'limit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextCursor',
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextCursor',
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextCursor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
          QAfterFilterCondition>
      nextCursorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
          QAfterFilterCondition>
      nextCursorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextCursor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextCursor',
        value: '',
      ));
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache,
      QAfterFilterCondition> nextCursorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextCursor',
        value: '',
      ));
    });
  }
}

extension MessageGroupListCacheQueryObject on QueryBuilder<
    MessageGroupListCache, MessageGroupListCache, QFilterCondition> {}

extension MessageGroupListCacheQueryLinks on QueryBuilder<MessageGroupListCache,
    MessageGroupListCache, QFilterCondition> {}

extension MessageGroupListCacheQuerySortBy
    on QueryBuilder<MessageGroupListCache, MessageGroupListCache, QSortBy> {
  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByHasMore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMore', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByHasMoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMore', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limit', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limit', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByNextCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      sortByNextCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.desc);
    });
  }
}

extension MessageGroupListCacheQuerySortThenBy
    on QueryBuilder<MessageGroupListCache, MessageGroupListCache, QSortThenBy> {
  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByHasMore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMore', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByHasMoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasMore', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limit', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'limit', Sort.desc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByNextCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.asc);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QAfterSortBy>
      thenByNextCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.desc);
    });
  }
}

extension MessageGroupListCacheQueryWhereDistinct
    on QueryBuilder<MessageGroupListCache, MessageGroupListCache, QDistinct> {
  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QDistinct>
      distinctByCacheScopeUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QDistinct>
      distinctByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAtUtc');
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QDistinct>
      distinctByHasMore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasMore');
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QDistinct>
      distinctByLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'limit');
    });
  }

  QueryBuilder<MessageGroupListCache, MessageGroupListCache, QDistinct>
      distinctByNextCursor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextCursor', caseSensitive: caseSensitive);
    });
  }
}

extension MessageGroupListCacheQueryProperty on QueryBuilder<
    MessageGroupListCache, MessageGroupListCache, QQueryProperty> {
  QueryBuilder<MessageGroupListCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MessageGroupListCache, String, QQueryOperations>
      cacheScopeUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeUserId');
    });
  }

  QueryBuilder<MessageGroupListCache, DateTime, QQueryOperations>
      cachedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAtUtc');
    });
  }

  QueryBuilder<MessageGroupListCache, bool, QQueryOperations>
      hasMoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasMore');
    });
  }

  QueryBuilder<MessageGroupListCache, int, QQueryOperations> limitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'limit');
    });
  }

  QueryBuilder<MessageGroupListCache, String?, QQueryOperations>
      nextCursorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextCursor');
    });
  }
}
