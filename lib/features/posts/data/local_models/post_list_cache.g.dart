// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_list_cache.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPostListCacheCollection on Isar {
  IsarCollection<PostListCache> get postListCaches => this.collection();
}

const PostListCacheSchema = CollectionSchema(
  name: r'PostListCache',
  id: -3371375506447320662,
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
    r'feedType': PropertySchema(
      id: 2,
      name: r'feedType',
      type: IsarType.string,
    ),
    r'friendId': PropertySchema(
      id: 3,
      name: r'friendId',
      type: IsarType.string,
    ),
    r'listScopeKey': PropertySchema(
      id: 4,
      name: r'listScopeKey',
      type: IsarType.string,
    ),
    r'nextCursor': PropertySchema(
      id: 5,
      name: r'nextCursor',
      type: IsarType.string,
    )
  },
  estimateSize: _postListCacheEstimateSize,
  serialize: _postListCacheSerialize,
  deserialize: _postListCacheDeserialize,
  deserializeProp: _postListCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'listScopeKey': IndexSchema(
      id: 7021607052233492290,
      name: r'listScopeKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'listScopeKey',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _postListCacheGetId,
  getLinks: _postListCacheGetLinks,
  attach: _postListCacheAttach,
  version: '3.1.0+1',
);

int _postListCacheEstimateSize(
  PostListCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cacheScopeUserId.length * 3;
  bytesCount += 3 + object.feedType.length * 3;
  {
    final value = object.friendId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.listScopeKey.length * 3;
  {
    final value = object.nextCursor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _postListCacheSerialize(
  PostListCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cacheScopeUserId);
  writer.writeDateTime(offsets[1], object.cachedAtUtc);
  writer.writeString(offsets[2], object.feedType);
  writer.writeString(offsets[3], object.friendId);
  writer.writeString(offsets[4], object.listScopeKey);
  writer.writeString(offsets[5], object.nextCursor);
}

PostListCache _postListCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PostListCache();
  object.cacheScopeUserId = reader.readString(offsets[0]);
  object.cachedAtUtc = reader.readDateTime(offsets[1]);
  object.feedType = reader.readString(offsets[2]);
  object.friendId = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.listScopeKey = reader.readString(offsets[4]);
  object.nextCursor = reader.readStringOrNull(offsets[5]);
  return object;
}

P _postListCacheDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _postListCacheGetId(PostListCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _postListCacheGetLinks(PostListCache object) {
  return [];
}

void _postListCacheAttach(
    IsarCollection<dynamic> col, Id id, PostListCache object) {
  object.id = id;
}

extension PostListCacheByIndex on IsarCollection<PostListCache> {
  Future<PostListCache?> getByListScopeKey(String listScopeKey) {
    return getByIndex(r'listScopeKey', [listScopeKey]);
  }

  PostListCache? getByListScopeKeySync(String listScopeKey) {
    return getByIndexSync(r'listScopeKey', [listScopeKey]);
  }

  Future<bool> deleteByListScopeKey(String listScopeKey) {
    return deleteByIndex(r'listScopeKey', [listScopeKey]);
  }

  bool deleteByListScopeKeySync(String listScopeKey) {
    return deleteByIndexSync(r'listScopeKey', [listScopeKey]);
  }

  Future<List<PostListCache?>> getAllByListScopeKey(
      List<String> listScopeKeyValues) {
    final values = listScopeKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'listScopeKey', values);
  }

  List<PostListCache?> getAllByListScopeKeySync(
      List<String> listScopeKeyValues) {
    final values = listScopeKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'listScopeKey', values);
  }

  Future<int> deleteAllByListScopeKey(List<String> listScopeKeyValues) {
    final values = listScopeKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'listScopeKey', values);
  }

  int deleteAllByListScopeKeySync(List<String> listScopeKeyValues) {
    final values = listScopeKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'listScopeKey', values);
  }

  Future<Id> putByListScopeKey(PostListCache object) {
    return putByIndex(r'listScopeKey', object);
  }

  Id putByListScopeKeySync(PostListCache object, {bool saveLinks = true}) {
    return putByIndexSync(r'listScopeKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByListScopeKey(List<PostListCache> objects) {
    return putAllByIndex(r'listScopeKey', objects);
  }

  List<Id> putAllByListScopeKeySync(List<PostListCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'listScopeKey', objects, saveLinks: saveLinks);
  }
}

extension PostListCacheQueryWhereSort
    on QueryBuilder<PostListCache, PostListCache, QWhere> {
  QueryBuilder<PostListCache, PostListCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhere> anyListScopeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'listScopeKey'),
      );
    });
  }
}

extension PostListCacheQueryWhere
    on QueryBuilder<PostListCache, PostListCache, QWhereClause> {
  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause> idBetween(
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

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyEqualTo(String listScopeKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'listScopeKey',
        value: [listScopeKey],
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyNotEqualTo(String listScopeKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listScopeKey',
              lower: [],
              upper: [listScopeKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listScopeKey',
              lower: [listScopeKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listScopeKey',
              lower: [listScopeKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'listScopeKey',
              lower: [],
              upper: [listScopeKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyGreaterThan(
    String listScopeKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listScopeKey',
        lower: [listScopeKey],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyLessThan(
    String listScopeKey, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listScopeKey',
        lower: [],
        upper: [listScopeKey],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyBetween(
    String lowerListScopeKey,
    String upperListScopeKey, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listScopeKey',
        lower: [lowerListScopeKey],
        includeLower: includeLower,
        upper: [upperListScopeKey],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyStartsWith(String ListScopeKeyPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'listScopeKey',
        lower: [ListScopeKeyPrefix],
        upper: ['$ListScopeKeyPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'listScopeKey',
        value: [''],
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterWhereClause>
      listScopeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'listScopeKey',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'listScopeKey',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'listScopeKey',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'listScopeKey',
              upper: [''],
            ));
      }
    });
  }
}

extension PostListCacheQueryFilter
    on QueryBuilder<PostListCache, PostListCache, QFilterCondition> {
  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      cacheScopeUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cacheScopeUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      cacheScopeUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cacheScopeUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      cacheScopeUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      cacheScopeUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cacheScopeUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      cachedAtUtcEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cachedAtUtc',
        value: value,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feedType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'feedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'feedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'feedType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'feedType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feedType',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      feedTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'feedType',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'friendId',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'friendId',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friendId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'friendId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'friendId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'friendId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'friendId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'friendId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'friendId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'friendId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friendId',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      friendIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'friendId',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listScopeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listScopeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listScopeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listScopeKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'listScopeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'listScopeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'listScopeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'listScopeKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listScopeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      listScopeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'listScopeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextCursor',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextCursor',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorEqualTo(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorGreaterThan(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorLessThan(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorBetween(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorStartsWith(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorEndsWith(
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

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextCursor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextCursor',
        value: '',
      ));
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterFilterCondition>
      nextCursorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextCursor',
        value: '',
      ));
    });
  }
}

extension PostListCacheQueryObject
    on QueryBuilder<PostListCache, PostListCache, QFilterCondition> {}

extension PostListCacheQueryLinks
    on QueryBuilder<PostListCache, PostListCache, QFilterCondition> {}

extension PostListCacheQuerySortBy
    on QueryBuilder<PostListCache, PostListCache, QSortBy> {
  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> sortByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> sortByFeedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedType', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByFeedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedType', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> sortByFriendId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendId', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByFriendIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendId', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByListScopeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listScopeKey', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByListScopeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listScopeKey', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> sortByNextCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      sortByNextCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.desc);
    });
  }
}

extension PostListCacheQuerySortThenBy
    on QueryBuilder<PostListCache, PostListCache, QSortThenBy> {
  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByCacheScopeUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByCacheScopeUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cacheScopeUserId', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> thenByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByCachedAtUtcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cachedAtUtc', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> thenByFeedType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedType', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByFeedTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feedType', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> thenByFriendId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendId', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByFriendIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'friendId', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByListScopeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listScopeKey', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByListScopeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listScopeKey', Sort.desc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy> thenByNextCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.asc);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QAfterSortBy>
      thenByNextCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.desc);
    });
  }
}

extension PostListCacheQueryWhereDistinct
    on QueryBuilder<PostListCache, PostListCache, QDistinct> {
  QueryBuilder<PostListCache, PostListCache, QDistinct>
      distinctByCacheScopeUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cacheScopeUserId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QDistinct>
      distinctByCachedAtUtc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cachedAtUtc');
    });
  }

  QueryBuilder<PostListCache, PostListCache, QDistinct> distinctByFeedType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feedType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QDistinct> distinctByFriendId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'friendId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QDistinct> distinctByListScopeKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listScopeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PostListCache, PostListCache, QDistinct> distinctByNextCursor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextCursor', caseSensitive: caseSensitive);
    });
  }
}

extension PostListCacheQueryProperty
    on QueryBuilder<PostListCache, PostListCache, QQueryProperty> {
  QueryBuilder<PostListCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PostListCache, String, QQueryOperations>
      cacheScopeUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cacheScopeUserId');
    });
  }

  QueryBuilder<PostListCache, DateTime, QQueryOperations>
      cachedAtUtcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cachedAtUtc');
    });
  }

  QueryBuilder<PostListCache, String, QQueryOperations> feedTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feedType');
    });
  }

  QueryBuilder<PostListCache, String?, QQueryOperations> friendIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'friendId');
    });
  }

  QueryBuilder<PostListCache, String, QQueryOperations> listScopeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listScopeKey');
    });
  }

  QueryBuilder<PostListCache, String?, QQueryOperations> nextCursorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextCursor');
    });
  }
}
