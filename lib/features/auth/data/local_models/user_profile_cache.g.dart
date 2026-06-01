// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileCacheCollection on Isar {
  IsarCollection<UserProfileCache> get userProfileCaches => this.collection();
}

const UserProfileCacheSchema = CollectionSchema(
  name: r'UserProfileCache',
  id: 6727096250389556981,
  properties: {
    r'avatarMediaObjectId': PropertySchema(
      id: 0,
      name: r'avatarMediaObjectId',
      type: IsarType.string,
    ),
    r'avatarUrl': PropertySchema(
      id: 1,
      name: r'avatarUrl',
      type: IsarType.string,
    ),
    r'cacheScopeUserId': PropertySchema(
      id: 2,
      name: r'cacheScopeUserId',
      type: IsarType.string,
    ),
    r'cachedAtUtc': PropertySchema(
      id: 3,
      name: r'cachedAtUtc',
      type: IsarType.dateTime,
    ),
    r'createdAtUtc': PropertySchema(
      id: 4,
      name: r'createdAtUtc',
      type: IsarType.dateTime,
    ),
    r'email': PropertySchema(
      id: 5,
      name: r'email',
      type: IsarType.string,
    ),
    r'familyName': PropertySchema(
      id: 6,
      name: r'familyName',
      type: IsarType.string,
    ),
    r'givenName': PropertySchema(
      id: 7,
      name: r'givenName',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 8,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isEmailVerified': PropertySchema(
      id: 9,
      name: r'isEmailVerified',
      type: IsarType.bool,
    ),
    r'lastLoginAtUtc': PropertySchema(
      id: 10,
      name: r'lastLoginAtUtc',
      type: IsarType.dateTime,
    ),
    r'phoneNumber': PropertySchema(
      id: 11,
      name: r'phoneNumber',
      type: IsarType.string,
    ),
    r'timeZone': PropertySchema(
      id: 12,
      name: r'timeZone',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 13,
      name: r'userId',
      type: IsarType.string,
    ),
    r'username': PropertySchema(
      id: 14,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _userProfileCacheEstimateSize,
  serialize: _userProfileCacheSerialize,
  deserialize: _userProfileCacheDeserialize,
  deserializeProp: _userProfileCacheDeserializeProp,
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
  getId: _userProfileCacheGetId,
  getLinks: _userProfileCacheGetLinks,
  attach: _userProfileCacheAttach,
  version: '3.1.0+1',
);

int _userProfileCacheEstimateSize(
  UserProfileCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.avatarMediaObjectId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.avatarUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.cacheScopeUserId.length * 3;
  bytesCount += 3 + object.email.length * 3;
  bytesCount += 3 + object.familyName.length * 3;
  bytesCount += 3 + object.givenName.length * 3;
  {
    final value = object.phoneNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.timeZone.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _userProfileCacheSerialize(
  UserProfileCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.avatarMediaObjectId);
  writer.writeString(offsets[1], object.avatarUrl);
  writer.writeString(offsets[2], object.cacheScopeUserId);
  writer.writeDateTime(offsets[3], object.cachedAtUtc);
  writer.writeDateTime(offsets[4], object.createdAtUtc);
  writer.writeString(offsets[5], object.email);
  writer.writeString(offsets[6], object.familyName);
  writer.writeString(offsets[7], object.givenName);
  writer.writeBool(offsets[8], object.isActive);
  writer.writeBool(offsets[9], object.isEmailVerified);
  writer.writeDateTime(offsets[10], object.lastLoginAtUtc);
  writer.writeString(offsets[11], object.phoneNumber);
  writer.writeString(offsets[12], object.timeZone);
  writer.writeString(offsets[13], object.userId);
  writer.writeString(offsets[14], object.username);
}

UserProfileCache _userProfileCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileCache();
  object.avatarMediaObjectId = reader.readStringOrNull(offsets[0]);
  object.avatarUrl = reader.readStringOrNull(offsets[1]);
  object.cacheScopeUserId = reader.readString(offsets[2]);
  object.cachedAtUtc = reader.readDateTime(offsets[3]);
  object.createdAtUtc = reader.readDateTime(offsets[4]);
  object.email = reader.readString(offsets[5]);
  object.familyName = reader.readString(offsets[6]);
  object.givenName = reader.readString(offsets[7]);
  object.id = id;
  object.isActive = reader.readBool(offsets[8]);
  object.isEmailVerified = reader.readBool(offsets[9]);
  object.lastLoginAtUtc = reader.readDateTimeOrNull(offsets[10]);
  object.phoneNumber = reader.readStringOrNull(offsets[11]);
  object.timeZone = reader.readString(offsets[12]);
  object.userId = reader.readString(offsets[13]);
  object.username = reader.readString(offsets[14]);
  return object;
}

P _userProfileCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileCacheGetId(UserProfileCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileCacheGetLinks(UserProfileCache object) {
  return [];
}

void _userProfileCacheAttach(
    IsarCollection<dynamic> col, Id id, UserProfileCache object) {
  object.id = id;
}

extension UserProfileCacheByIndex on IsarCollection<UserProfileCache> {
  Future<UserProfileCache?> getByCacheScopeUserId(String cacheScopeUserId) {
    return getByIndex(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  UserProfileCache? getByCacheScopeUserIdSync(String cacheScopeUserId) {
    return getByIndexSync(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  Future<bool> deleteByCacheScopeUserId(String cacheScopeUserId) {
    return deleteByIndex(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  bool deleteByCacheScopeUserIdSync(String cacheScopeUserId) {
    return deleteByIndexSync(r'cacheScopeUserId', [cacheScopeUserId]);
  }

  Future<List<UserProfileCache?>> getAllByCacheScopeUserId(
      List<String> cacheScopeUserIdValues) {
    final values = cacheScopeUserIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'cacheScopeUserId', values);
  }

  List<UserProfileCache?> getAllByCacheScopeUserIdSync(
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

  Future<Id> putByCacheScopeUserId(UserProfileCache object) {
    return putByIndex(r'cacheScopeUserId', object);
  }

  Id putByCacheScopeUserIdSync(UserProfileCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'cacheScopeUserId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCacheScopeUserId(List<UserProfileCache> objects) {
    return putAllByIndex(r'cacheScopeUserId', objects);
  }

  List<Id> putAllByCacheScopeUserIdSync(List<UserProfileCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'cacheScopeUserId', objects,
        saveLinks: saveLinks);
  }
}

extension UserProfileCacheQueryWhereSort
    on QueryBuilder<UserProfileCache, UserProfileCache, QWhere> {
  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhere>
      anyCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cacheScopeUserId'),
      );
    });
  }
}

extension UserProfileCacheQueryWhere
    on QueryBuilder<UserProfileCache, UserProfileCache, QWhereClause> {
  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
      cacheScopeUserIdEqualTo(String cacheScopeUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [cacheScopeUserId],
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
      cacheScopeUserIdStartsWith(String CacheScopeUserIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cacheScopeUserId',
        lower: [CacheScopeUserIdPrefix],
        upper: ['$CacheScopeUserIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cacheScopeUserId',
        value: [''],
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterWhereClause>
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

extension UserProfileCacheQueryFilter
    on QueryBuilder<UserProfileCache, UserProfileCache, QFilterCondition> {
  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatarMediaObjectId',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatarMediaObjectId',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarMediaObjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatarMediaObjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatarMediaObjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatarMediaObjectId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatarMediaObjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatarMediaObjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatarMediaObjectId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatarMediaObjectId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarMediaObjectId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarMediaObjectIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatarMediaObjectId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatarUrl',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatarUrl',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatarUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatarUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatarUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatarUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatarUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatarUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatarUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      avatarUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatarUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      cacheScopeUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      cacheScopeUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheScopeUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      cachedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      createdAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      createdAtUtcGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      createdAtUtcLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      createdAtUtcBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'familyName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'familyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'familyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'familyName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      familyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'familyName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'givenName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'givenName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'givenName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'givenName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'givenName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'givenName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'givenName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'givenName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'givenName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      givenNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'givenName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
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

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      isEmailVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEmailVerified',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      lastLoginAtUtcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLoginAtUtc',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      lastLoginAtUtcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLoginAtUtc',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      lastLoginAtUtcEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLoginAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      lastLoginAtUtcGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLoginAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      lastLoginAtUtcLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLoginAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      lastLoginAtUtcBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLoginAtUtc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phoneNumber',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phoneNumber',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phoneNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phoneNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      phoneNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeZone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeZone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeZone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      timeZoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeZone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterFilterCondition>
      usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension UserProfileCacheQueryObject
    on QueryBuilder<UserProfileCache, UserProfileCache, QFilterCondition> {}

extension UserProfileCacheQueryLinks
    on QueryBuilder<UserProfileCache, UserProfileCache, QFilterCondition> {}

extension UserProfileCacheQuerySortBy
    on QueryBuilder<UserProfileCache, UserProfileCache, QSortBy> {
  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByAvatarMediaObjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarMediaObjectId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByAvatarMediaObjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarMediaObjectId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByAvatarUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByAvatarUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByCreatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByFamilyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByFamilyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByGivenName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'givenName', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByGivenNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'givenName', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByIsEmailVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmailVerified', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByIsEmailVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmailVerified', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByLastLoginAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAtUtc', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByLastLoginAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAtUtc', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByTimeZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByTimeZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserProfileCacheQuerySortThenBy
    on QueryBuilder<UserProfileCache, UserProfileCache, QSortThenBy> {
  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByAvatarMediaObjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarMediaObjectId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByAvatarMediaObjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarMediaObjectId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByAvatarUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByAvatarUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarUrl', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByCreatedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtUtc', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByFamilyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByFamilyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'familyName', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByGivenName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'givenName', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByGivenNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'givenName', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByIsEmailVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmailVerified', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByIsEmailVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEmailVerified', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByLastLoginAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAtUtc', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByLastLoginAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAtUtc', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByTimeZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByTimeZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QAfterSortBy>
      thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserProfileCacheQueryWhereDistinct
    on QueryBuilder<UserProfileCache, UserProfileCache, QDistinct> {
  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByAvatarMediaObjectId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarMediaObjectId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByAvatarUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByCacheScopeUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAtUtc');
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByCreatedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtUtc');
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByFamilyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'familyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByGivenName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'givenName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByIsEmailVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEmailVerified');
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByLastLoginAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLoginAtUtc');
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByPhoneNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phoneNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByTimeZone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeZone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileCache, UserProfileCache, QDistinct>
      distinctByUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension UserProfileCacheQueryProperty
    on QueryBuilder<UserProfileCache, UserProfileCache, QQueryProperty> {
  QueryBuilder<UserProfileCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfileCache, String?, QQueryOperations>
      avatarMediaObjectIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarMediaObjectId');
    });
  }

  QueryBuilder<UserProfileCache, String?, QQueryOperations>
      avatarUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarUrl');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations>
      cacheScopeUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeUserId');
    });
  }

  QueryBuilder<UserProfileCache, DateTime, QQueryOperations>
      cachedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAtUtc');
    });
  }

  QueryBuilder<UserProfileCache, DateTime, QQueryOperations>
      createdAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtUtc');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations>
      familyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'familyName');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations> givenNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'givenName');
    });
  }

  QueryBuilder<UserProfileCache, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<UserProfileCache, bool, QQueryOperations>
      isEmailVerifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEmailVerified');
    });
  }

  QueryBuilder<UserProfileCache, DateTime?, QQueryOperations>
      lastLoginAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLoginAtUtc');
    });
  }

  QueryBuilder<UserProfileCache, String?, QQueryOperations>
      phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phoneNumber');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations> timeZoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeZone');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<UserProfileCache, String, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
