// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_settings_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSafetySettingsCacheCollection on Isar {
  IsarCollection<SafetySettingsCache> get safetySettingsCaches =>
      this.collection();
}

const SafetySettingsCacheSchema = CollectionSchema(
  name: r'SafetySettingsCache',
  id: 3289425761760293955,
  properties: {
    r'autoAlertDelayMinutes': PropertySchema(
      id: 0,
      name: r'autoAlertDelayMinutes',
      type: IsarType.long,
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
    r'dailyDeadlineLocalTime': PropertySchema(
      id: 3,
      name: r'dailyDeadlineLocalTime',
      type: IsarType.string,
    ),
    r'gracePeriodMinutes': PropertySchema(
      id: 4,
      name: r'gracePeriodMinutes',
      type: IsarType.long,
    ),
    r'isAutoAlertEnabled': PropertySchema(
      id: 5,
      name: r'isAutoAlertEnabled',
      type: IsarType.bool,
    ),
    r'isDefault': PropertySchema(
      id: 6,
      name: r'isDefault',
      type: IsarType.bool,
    ),
    r'isMonitoringEnabled': PropertySchema(
      id: 7,
      name: r'isMonitoringEnabled',
      type: IsarType.bool,
    ),
    r'reminderBeforeMinutes': PropertySchema(
      id: 8,
      name: r'reminderBeforeMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _safetySettingsCacheEstimateSize,
  serialize: _safetySettingsCacheSerialize,
  deserialize: _safetySettingsCacheDeserialize,
  deserializeProp: _safetySettingsCacheDeserializeProp,
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
  getId: _safetySettingsCacheGetId,
  getLinks: _safetySettingsCacheGetLinks,
  attach: _safetySettingsCacheAttach,
  version: '3.1.0+1',
);

int _safetySettingsCacheEstimateSize(
  SafetySettingsCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheScopeUserId.length * 3;
  bytesCount += 3 + object.dailyDeadlineLocalTime.length * 3;
  return bytesCount;
}

void _safetySettingsCacheSerialize(
  SafetySettingsCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.autoAlertDelayMinutes);
  writer.writeString(offsets[1], object.cacheScopeUserId);
  writer.writeDateTime(offsets[2], object.cachedAtUtc);
  writer.writeString(offsets[3], object.dailyDeadlineLocalTime);
  writer.writeLong(offsets[4], object.gracePeriodMinutes);
  writer.writeBool(offsets[5], object.isAutoAlertEnabled);
  writer.writeBool(offsets[6], object.isDefault);
  writer.writeBool(offsets[7], object.isMonitoringEnabled);
  writer.writeLong(offsets[8], object.reminderBeforeMinutes);
}

SafetySettingsCache _safetySettingsCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SafetySettingsCache();
  object.autoAlertDelayMinutes = reader.readLong(offsets[0]);
  object.cacheScopeUserId = reader.readString(offsets[1]);
  object.cachedAtUtc = reader.readDateTime(offsets[2]);
  object.dailyDeadlineLocalTime = reader.readString(offsets[3]);
  object.gracePeriodMinutes = reader.readLong(offsets[4]);
  object.id = id;
  object.isAutoAlertEnabled = reader.readBool(offsets[5]);
  object.isDefault = reader.readBool(offsets[6]);
  object.isMonitoringEnabled = reader.readBool(offsets[7]);
  object.reminderBeforeMinutes = reader.readLong(offsets[8]);
  return object;
}

P _safetySettingsCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _safetySettingsCacheGetId(SafetySettingsCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _safetySettingsCacheGetLinks(
    SafetySettingsCache object) {
  return [];
}

void _safetySettingsCacheAttach(
    IsarCollection<dynamic> col, Id id, SafetySettingsCache object) {
  object.id = id;
}

extension SafetySettingsCacheByIndex on IsarCollection<SafetySettingsCache> {
  Future<SafetySettingsCache?> getByCacheScopeUserId(String cacheScopeUserId) {
    return getByIndex(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  SafetySettingsCache? getByCacheScopeUserIdSync(String cacheScopeUserId) {
    return getByIndexSync(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  Future<bool> deleteByCacheScopeUserId(String cacheScopeUserId) {
    return deleteByIndex(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  bool deleteByCacheScopeUserIdSync(String cacheScopeUserId) {
    return deleteByIndexSync(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  Future<List<SafetySettingsCache?>> getAllByCacheScopeUserId(
      List<String> cacheScopeUserIdValues) {
    final values = cacheScopeUserIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheScopeUserId', values);
  }

  List<SafetySettingsCache?> getAllByCacheScopeUserIdSync(
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

  Future<Id> putByCacheScopeUserId(SafetySettingsCache object) {
    return putByIndex(r'cacheScopeUserId', object);
  }

  Id putByCacheScopeUserIdSync(SafetySettingsCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'cacheScopeUserId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheScopeUserId(List<SafetySettingsCache> objects) {
    return putAllByIndex(r'cacheScopeUserId', objects);
  }

  List<Id> putAllByCacheScopeUserIdSync(List<SafetySettingsCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheScopeUserId', objects,
        saveLinks: saveLinks);
  }
}

extension SafetySettingsCacheQueryWhereSort
    on QueryBuilder<SafetySettingsCache, SafetySettingsCache, QWhere> {
  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhere>
      anyCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheScopeUserId'),
      );
    });
  }
}

extension SafetySettingsCacheQueryWhere
    on QueryBuilder<SafetySettingsCache, SafetySettingsCache, QWhereClause> {
  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
      cacheScopeUserIdEqualTo(String cacheScopeUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [cacheScopeUserId],
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
      cacheScopeUserIdStartsWith(String CacheScopeUserIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [CacheScopeUserIdPrefix],
        upper: ['$CacheScopeUserIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [''],
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterWhereClause>
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

extension SafetySettingsCacheQueryFilter on QueryBuilder<SafetySettingsCache,
    SafetySettingsCache, QFilterCondition> {
  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      autoAlertDelayMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoAlertDelayMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      autoAlertDelayMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'autoAlertDelayMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      autoAlertDelayMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'autoAlertDelayMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      autoAlertDelayMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'autoAlertDelayMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdEqualTo(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdGreaterThan(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdLessThan(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdBetween(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdStartsWith(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdEndsWith(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheScopeUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cachedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cachedAtUtcGreaterThan(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cachedAtUtcLessThan(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      cachedAtUtcBetween(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyDeadlineLocalTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyDeadlineLocalTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyDeadlineLocalTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyDeadlineLocalTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyDeadlineLocalTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyDeadlineLocalTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyDeadlineLocalTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyDeadlineLocalTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyDeadlineLocalTime',
        value: '',
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      dailyDeadlineLocalTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyDeadlineLocalTime',
        value: '',
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      gracePeriodMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gracePeriodMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      gracePeriodMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gracePeriodMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      gracePeriodMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gracePeriodMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      gracePeriodMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gracePeriodMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      isAutoAlertEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAutoAlertEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      isDefaultEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDefault',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      isMonitoringEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMonitoringEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      reminderBeforeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderBeforeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      reminderBeforeMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderBeforeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      reminderBeforeMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderBeforeMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterFilterCondition>
      reminderBeforeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderBeforeMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SafetySettingsCacheQueryObject on QueryBuilder<SafetySettingsCache,
    SafetySettingsCache, QFilterCondition> {}

extension SafetySettingsCacheQueryLinks on QueryBuilder<SafetySettingsCache,
    SafetySettingsCache, QFilterCondition> {}

extension SafetySettingsCacheQuerySortBy
    on QueryBuilder<SafetySettingsCache, SafetySettingsCache, QSortBy> {
  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByAutoAlertDelayMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAlertDelayMinutes', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByAutoAlertDelayMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAlertDelayMinutes', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByDailyDeadlineLocalTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyDeadlineLocalTime', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByDailyDeadlineLocalTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyDeadlineLocalTime', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByGracePeriodMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gracePeriodMinutes', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByGracePeriodMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gracePeriodMinutes', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByIsAutoAlertEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoAlertEnabled', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByIsAutoAlertEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoAlertEnabled', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByIsMonitoringEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMonitoringEnabled', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByIsMonitoringEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMonitoringEnabled', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByReminderBeforeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderBeforeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      sortByReminderBeforeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderBeforeMinutes', Sort.desc);
    });
  }
}

extension SafetySettingsCacheQuerySortThenBy
    on QueryBuilder<SafetySettingsCache, SafetySettingsCache, QSortThenBy> {
  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByAutoAlertDelayMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAlertDelayMinutes', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByAutoAlertDelayMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAlertDelayMinutes', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByDailyDeadlineLocalTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyDeadlineLocalTime', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByDailyDeadlineLocalTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyDeadlineLocalTime', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByGracePeriodMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gracePeriodMinutes', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByGracePeriodMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gracePeriodMinutes', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIsAutoAlertEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoAlertEnabled', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIsAutoAlertEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAutoAlertEnabled', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIsMonitoringEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMonitoringEnabled', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByIsMonitoringEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMonitoringEnabled', Sort.desc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByReminderBeforeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderBeforeMinutes', Sort.asc);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QAfterSortBy>
      thenByReminderBeforeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderBeforeMinutes', Sort.desc);
    });
  }
}

extension SafetySettingsCacheQueryWhereDistinct
    on QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct> {
  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByAutoAlertDelayMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoAlertDelayMinutes');
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByCacheScopeUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAtUtc');
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByDailyDeadlineLocalTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyDeadlineLocalTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByGracePeriodMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gracePeriodMinutes');
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByIsAutoAlertEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAutoAlertEnabled');
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDefault');
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByIsMonitoringEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMonitoringEnabled');
    });
  }

  QueryBuilder<SafetySettingsCache, SafetySettingsCache, QDistinct>
      distinctByReminderBeforeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderBeforeMinutes');
    });
  }
}

extension SafetySettingsCacheQueryProperty
    on QueryBuilder<SafetySettingsCache, SafetySettingsCache, QQueryProperty> {
  QueryBuilder<SafetySettingsCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SafetySettingsCache, int, QQueryOperations>
      autoAlertDelayMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoAlertDelayMinutes');
    });
  }

  QueryBuilder<SafetySettingsCache, String, QQueryOperations>
      cacheScopeUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeUserId');
    });
  }

  QueryBuilder<SafetySettingsCache, DateTime, QQueryOperations>
      cachedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAtUtc');
    });
  }

  QueryBuilder<SafetySettingsCache, String, QQueryOperations>
      dailyDeadlineLocalTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyDeadlineLocalTime');
    });
  }

  QueryBuilder<SafetySettingsCache, int, QQueryOperations>
      gracePeriodMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gracePeriodMinutes');
    });
  }

  QueryBuilder<SafetySettingsCache, bool, QQueryOperations>
      isAutoAlertEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAutoAlertEnabled');
    });
  }

  QueryBuilder<SafetySettingsCache, bool, QQueryOperations>
      isDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDefault');
    });
  }

  QueryBuilder<SafetySettingsCache, bool, QQueryOperations>
      isMonitoringEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMonitoringEnabled');
    });
  }

  QueryBuilder<SafetySettingsCache, int, QQueryOperations>
      reminderBeforeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderBeforeMinutes');
    });
  }
}
