class QueryFilter {
  final String field;
  final dynamic value;
  final FilterOperator operator;

  const QueryFilter({
    required this.field,
    required this.value,
    required this.operator,
  });
}

enum FilterOperator {
  isEqualTo,
  isNotEqualTo,
  isLessThan,
  isLessThanOrEqualTo,
  isGreaterThan,
  isGreaterThanOrEqualTo,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
}
