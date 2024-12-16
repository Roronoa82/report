// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_data.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFilteredDataCollection on Isar {
  IsarCollection<FilteredData> get filteredDatas => this.collection();
}

const FilteredDataSchema = CollectionSchema(
  name: r'FilteredData',
  id: 8655549837019120296,
  properties: {
    r'filterKey': PropertySchema(
      id: 0,
      name: r'filterKey',
      type: IsarType.string,
    ),
    r'filterValue': PropertySchema(
      id: 1,
      name: r'filterValue',
      type: IsarType.string,
    ),
    r'referenceDateId': PropertySchema(
      id: 2,
      name: r'referenceDateId',
      type: IsarType.long,
    ),
    r'resultData': PropertySchema(
      id: 3,
      name: r'resultData',
      type: IsarType.string,
    )
  },
  estimateSize: _filteredDataEstimateSize,
  serialize: _filteredDataSerialize,
  deserialize: _filteredDataDeserialize,
  deserializeProp: _filteredDataDeserializeProp,
  idName: r'id',
  indexes: {
    r'filterKey': IndexSchema(
      id: -6513534407312558196,
      name: r'filterKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'filterKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'filterValue': IndexSchema(
      id: 8607987426606454289,
      name: r'filterValue',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'filterValue',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _filteredDataGetId,
  getLinks: _filteredDataGetLinks,
  attach: _filteredDataAttach,
  version: '3.1.0+1',
);

int _filteredDataEstimateSize(
  FilteredData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.filterKey.length * 3;
  bytesCount += 3 + object.filterValue.length * 3;
  bytesCount += 3 + object.resultData.length * 3;
  return bytesCount;
}

void _filteredDataSerialize(
  FilteredData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.filterKey);
  writer.writeString(offsets[1], object.filterValue);
  writer.writeLong(offsets[2], object.referenceDateId);
  writer.writeString(offsets[3], object.resultData);
}

FilteredData _filteredDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FilteredData();
  object.filterKey = reader.readString(offsets[0]);
  object.filterValue = reader.readString(offsets[1]);
  object.id = id;
  object.referenceDateId = reader.readLong(offsets[2]);
  object.resultData = reader.readString(offsets[3]);
  return object;
}

P _filteredDataDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _filteredDataGetId(FilteredData object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _filteredDataGetLinks(FilteredData object) {
  return [];
}

void _filteredDataAttach(
    IsarCollection<dynamic> col, Id id, FilteredData object) {
  object.id = id;
}

extension FilteredDataQueryWhereSort
    on QueryBuilder<FilteredData, FilteredData, QWhere> {
  QueryBuilder<FilteredData, FilteredData, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FilteredDataQueryWhere
    on QueryBuilder<FilteredData, FilteredData, QWhereClause> {
  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause> idBetween(
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

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause> filterKeyEqualTo(
      String filterKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'filterKey',
        value: [filterKey],
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause>
      filterKeyNotEqualTo(String filterKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterKey',
              lower: [],
              upper: [filterKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterKey',
              lower: [filterKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterKey',
              lower: [filterKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterKey',
              lower: [],
              upper: [filterKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause>
      filterValueEqualTo(String filterValue) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'filterValue',
        value: [filterValue],
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterWhereClause>
      filterValueNotEqualTo(String filterValue) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterValue',
              lower: [],
              upper: [filterValue],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterValue',
              lower: [filterValue],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterValue',
              lower: [filterValue],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'filterValue',
              lower: [],
              upper: [filterValue],
              includeUpper: false,
            ));
      }
    });
  }
}

extension FilteredDataQueryFilter
    on QueryBuilder<FilteredData, FilteredData, QFilterCondition> {
  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filterKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filterKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filterKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filterKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filterKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filterKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filterKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterKey',
        value: '',
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filterKey',
        value: '',
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filterValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filterValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filterValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filterValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filterValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filterValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filterValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filterValue',
        value: '',
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      filterValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filterValue',
        value: '',
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition> idBetween(
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

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      referenceDateIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceDateId',
        value: value,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      referenceDateIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceDateId',
        value: value,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      referenceDateIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceDateId',
        value: value,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      referenceDateIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceDateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resultData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resultData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resultData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resultData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultData',
        value: '',
      ));
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterFilterCondition>
      resultDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resultData',
        value: '',
      ));
    });
  }
}

extension FilteredDataQueryObject
    on QueryBuilder<FilteredData, FilteredData, QFilterCondition> {}

extension FilteredDataQueryLinks
    on QueryBuilder<FilteredData, FilteredData, QFilterCondition> {}

extension FilteredDataQuerySortBy
    on QueryBuilder<FilteredData, FilteredData, QSortBy> {
  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> sortByFilterKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterKey', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> sortByFilterKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterKey', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> sortByFilterValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterValue', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      sortByFilterValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterValue', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      sortByReferenceDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceDateId', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      sortByReferenceDateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceDateId', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> sortByResultData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultData', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      sortByResultDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultData', Sort.desc);
    });
  }
}

extension FilteredDataQuerySortThenBy
    on QueryBuilder<FilteredData, FilteredData, QSortThenBy> {
  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> thenByFilterKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterKey', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> thenByFilterKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterKey', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> thenByFilterValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterValue', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      thenByFilterValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'filterValue', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      thenByReferenceDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceDateId', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      thenByReferenceDateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceDateId', Sort.desc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy> thenByResultData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultData', Sort.asc);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QAfterSortBy>
      thenByResultDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultData', Sort.desc);
    });
  }
}

extension FilteredDataQueryWhereDistinct
    on QueryBuilder<FilteredData, FilteredData, QDistinct> {
  QueryBuilder<FilteredData, FilteredData, QDistinct> distinctByFilterKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filterKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QDistinct> distinctByFilterValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'filterValue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FilteredData, FilteredData, QDistinct>
      distinctByReferenceDateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceDateId');
    });
  }

  QueryBuilder<FilteredData, FilteredData, QDistinct> distinctByResultData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultData', caseSensitive: caseSensitive);
    });
  }
}

extension FilteredDataQueryProperty
    on QueryBuilder<FilteredData, FilteredData, QQueryProperty> {
  QueryBuilder<FilteredData, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FilteredData, String, QQueryOperations> filterKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterKey');
    });
  }

  QueryBuilder<FilteredData, String, QQueryOperations> filterValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'filterValue');
    });
  }

  QueryBuilder<FilteredData, int, QQueryOperations> referenceDateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceDateId');
    });
  }

  QueryBuilder<FilteredData, String, QQueryOperations> resultDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultData');
    });
  }
}
