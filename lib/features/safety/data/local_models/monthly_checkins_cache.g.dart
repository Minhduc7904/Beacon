// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_checkins_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMonthlyCheckinsCacheCollection on Isar {
  IsarCollection<MonthlyCheckinsCache> get monthlyCheckinsCaches =>
      this.collection();
}

const MonthlyCheckinsCacheSchema = CollectionSchema(
  name: r'MonthlyCheckinsCache',
  id: -967763962689979631,
  properties: {
    r'cacheScopeMonthKey': PropertySchema(
      id: 0,
      name: r'cacheScopeMonthKey',
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
    r'fromDate': PropertySchema(
      id: 3,
      name: r'fromDate',
      type: IsarType.dateTime,
    ),
    r'itemsJson': PropertySchema(
      id: 4,
      name: r'itemsJson',
      type: IsarType.string,
    ),
    r'month': PropertySchema(
      id: 5,
      name: r'month',
      type: IsarType.long,
    ),
    r'toDate': PropertySchema(
      id: 6,
      name: r'toDate',
      type: IsarType.dateTime,
    ),
    r'totalCount': PropertySchema(
      id: 7,
      name: r'totalCount',
      type: IsarType.long,
    ),
    r'year': PropertySchema(
      id: 8,
      name: r'year',
      type: IsarType.long,
    )
  },
  estimateSize: _monthlyCheckinsCacheEstimateSize,
  serialize: _monthlyCheckinsCacheSerialize,
  deserialize: _monthlyCheckinsCacheDeserialize,
  deserializeProp: _monthlyCheckinsCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'cacheScopeMonthKey': IndexSchema(
      id: -7230774103745539148,
      name: r'cacheScopeMonthKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'cacheScopeMonthKey',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _monthlyCheckinsCacheGetId,
  getLinks: _monthlyCheckinsCacheGetLinks,
  attach: _monthlyCheckinsCacheAttach,
  version: '3.1.0+1',
);

int _monthlyCheckinsCacheEstimateSize(
  MonthlyCheckinsCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheScopeMonthKey.length * 3;
  bytesCount += 3 + object.cacheScopeUserId.length * 3;
  bytesCount += 3 + object.itemsJson.length * 3;
  return bytesCount;
}

void _monthlyCheckinsCacheSerialize(
  MonthlyCheckinsCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheScopeMonthKey);
  writer.writeString(offsets[1], object.cacheScopeUserId);
  writer.writeDateTime(offsets[2], object.cachedAtUtc);
  writer.writeDateTime(offsets[3], object.fromDate);
  writer.writeString(offsets[4], object.itemsJson);
  writer.writeLong(offsets[5], object.month);
  writer.writeDateTime(offsets[6], object.toDate);
  writer.writeLong(offsets[7], object.totalCount);
  writer.writeLong(offsets[8], object.year);
}

MonthlyCheckinsCache _monthlyCheckinsCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthlyCheckinsCache();
  object.cacheScopeMonthKey = reader.readString(offsets[0]);
  object.cacheScopeUserId = reader.readString(offsets[1]);
  object.cachedAtUtc = reader.readDateTime(offsets[2]);
  object.fromDate = reader.readDateTime(offsets[3]);
  object.id = id;
  object.itemsJson = reader.readString(offsets[4]);
  object.month = reader.readLong(offsets[5]);
  object.toDate = reader.readDateTime(offsets[6]);
  object.totalCount = reader.readLong(offsets[7]);
  object.year = reader.readLong(offsets[8]);
  return object;
}

P _monthlyCheckinsCacheDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthlyCheckinsCacheGetId(MonthlyCheckinsCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _monthlyCheckinsCacheGetLinks(
    MonthlyCheckinsCache object) {
  return [];
}

void _monthlyCheckinsCacheAttach(
    IsarCollection<dynamic> col, Id id, MonthlyCheckinsCache object) {
  object.id = id;
}

extension MonthlyCheckinsCacheByIndex on IsarCollection<MonthlyCheckinsCache> {
  Future<MonthlyCheckinsCache?> getByCacheScopeMonthKey(
      String cacheScopeMonthKey) {
    return getByIndex(r'cacheScopeMonthKey', [cacheScopeMonthKey]);
  }

  MonthlyCheckinsCache? getByCacheScopeMonthKeySync(String cacheScopeMonthKey) {
    return getByIndexSync(r'cacheScopeMonthKey', [cacheScopeMonthKey]);
  }

  Future<bool> deleteByCacheScopeMonthKey(String cacheScopeMonthKey) {
    return deleteByIndex(r'cacheScopeMonthKey', [cacheScopeMonthKey]);
  }

  bool deleteByCacheScopeMonthKeySync(String cacheScopeMonthKey) {
    return deleteByIndexSync(r'cacheScopeMonthKey', [cacheScopeMonthKey]);
  }

  Future<List<MonthlyCheckinsCache?>> getAllByCacheScopeMonthKey(
      List<String> cacheScopeMonthKeyValues) {
    final values = cacheScopeMonthKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheScopeMonthKey', values);
  }

  List<MonthlyCheckinsCache?> getAllByCacheScopeMonthKeySync(
      List<String> cacheScopeMonthKeyValues) {
    final values = cacheScopeMonthKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'cacheScopeMonthKey', values);
  }

  Future<int> deleteAllByCacheScopeMonthKey(
      List<String> cacheScopeMonthKeyValues) {
    final values = cacheScopeMonthKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'cacheScopeMonthKey', values);
  }

  int deleteAllByCacheScopeMonthKeySync(List<String> cacheScopeMonthKeyValues) {
    final values = cacheScopeMonthKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'cacheScopeMonthKey', values);
  }

  Future<Id> putByCacheScopeMonthKey(MonthlyCheckinsCache object) {
    return putByIndex(r'cacheScopeMonthKey', object);
  }

  Id putByCacheScopeMonthKeySync(MonthlyCheckinsCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'cacheScopeMonthKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheScopeMonthKey(
      List<MonthlyCheckinsCache> objects) {
    return putAllByIndex(r'cacheScopeMonthKey', objects);
  }

  List<Id> putAllByCacheScopeMonthKeySync(List<MonthlyCheckinsCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheScopeMonthKey', objects,
        saveLinks: saveLinks);
  }
}

extension MonthlyCheckinsCacheQueryWhereSort
    on QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QWhere> {
  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhere>
      anyCacheScopeMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheScopeMonthKey'),
      );
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhere>
      anyCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheScopeUserId'),
      );
    });
  }
}

extension MonthlyCheckinsCacheQueryWhere
    on QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QWhereClause> {
  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyEqualTo(String cacheScopeMonthKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeMonthKey',
        value: [cacheScopeMonthKey],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyNotEqualTo(String cacheScopeMonthKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeMonthKey',
              lower: [],
              upper: [cacheScopeMonthKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeMonthKey',
              lower: [cacheScopeMonthKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeMonthKey',
              lower: [cacheScopeMonthKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cacheScopeMonthKey',
              lower: [],
              upper: [cacheScopeMonthKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyGreaterThan(
    String cacheScopeMonthKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeMonthKey',
        lower: [cacheScopeMonthKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyLessThan(
    String cacheScopeMonthKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeMonthKey',
        lower: [],
        upper: [cacheScopeMonthKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyBetween(
    String lowerCacheScopeMonthKey,
    String upperCacheScopeMonthKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeMonthKey',
        lower: [lowerCacheScopeMonthKey],
        includeLower: includeLower,
        upper: [upperCacheScopeMonthKey],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyStartsWith(String CacheScopeMonthKeyPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeMonthKey',
        lower: [CacheScopeMonthKeyPrefix],
        upper: ['$CacheScopeMonthKeyPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeMonthKey',
        value: [''],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeMonthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'cacheScopeMonthKey',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'cacheScopeMonthKey',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'cacheScopeMonthKey',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'cacheScopeMonthKey',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeUserIdEqualTo(String cacheScopeUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [cacheScopeUserId],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeUserIdStartsWith(String CacheScopeUserIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [CacheScopeUserIdPrefix],
        upper: ['$CacheScopeUserIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [''],
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterWhereClause>
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

extension MonthlyCheckinsCacheQueryFilter on QueryBuilder<MonthlyCheckinsCache,
    MonthlyCheckinsCache, QFilterCondition> {
  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeMonthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cacheScopeMonthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cacheScopeMonthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cacheScopeMonthKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cacheScopeMonthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cacheScopeMonthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
          QAfterFilterCondition>
      cacheScopeMonthKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheScopeMonthKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
          QAfterFilterCondition>
      cacheScopeMonthKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheScopeMonthKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeMonthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeMonthKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeMonthKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> cachedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> fromDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fromDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> fromDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fromDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> fromDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fromDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> fromDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fromDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
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

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
          QAfterFilterCondition>
      itemsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
          QAfterFilterCondition>
      itemsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> itemsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> monthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> monthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> monthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> monthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> toDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'toDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> toDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'toDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> toDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'toDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> toDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'toDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> totalCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> totalCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> totalCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCount',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> totalCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> yearEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> yearGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> yearLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache,
      QAfterFilterCondition> yearBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MonthlyCheckinsCacheQueryObject on QueryBuilder<MonthlyCheckinsCache,
    MonthlyCheckinsCache, QFilterCondition> {}

extension MonthlyCheckinsCacheQueryLinks on QueryBuilder<MonthlyCheckinsCache,
    MonthlyCheckinsCache, QFilterCondition> {}

extension MonthlyCheckinsCacheQuerySortBy
    on QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QSortBy> {
  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByCacheScopeMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeMonthKey', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByCacheScopeMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeMonthKey', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByFromDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromDate', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByFromDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromDate', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByItemsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByItemsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByToDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toDate', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByToDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toDate', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthlyCheckinsCacheQuerySortThenBy
    on QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QSortThenBy> {
  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByCacheScopeMonthKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeMonthKey', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByCacheScopeMonthKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeMonthKey', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByFromDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromDate', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByFromDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fromDate', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByItemsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByItemsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsJson', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByToDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toDate', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByToDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'toDate', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByTotalCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCount', Sort.desc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthlyCheckinsCacheQueryWhereDistinct
    on QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct> {
  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByCacheScopeMonthKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeMonthKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByCacheScopeUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAtUtc');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByFromDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fromDate');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByItemsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByToDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'toDate');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByTotalCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCount');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, MonthlyCheckinsCache, QDistinct>
      distinctByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year');
    });
  }
}

extension MonthlyCheckinsCacheQueryProperty on QueryBuilder<
    MonthlyCheckinsCache, MonthlyCheckinsCache, QQueryProperty> {
  QueryBuilder<MonthlyCheckinsCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, String, QQueryOperations>
      cacheScopeMonthKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeMonthKey');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, String, QQueryOperations>
      cacheScopeUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeUserId');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, DateTime, QQueryOperations>
      cachedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAtUtc');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, DateTime, QQueryOperations>
      fromDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fromDate');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, String, QQueryOperations>
      itemsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemsJson');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, int, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, DateTime, QQueryOperations>
      toDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'toDate');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, int, QQueryOperations>
      totalCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCount');
    });
  }

  QueryBuilder<MonthlyCheckinsCache, int, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}
