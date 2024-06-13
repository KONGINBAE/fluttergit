
// 인터페이스 작성

import 'package:actual/common/model/model_with_id.dart';

import '../../restaurant/model/restaurant_model.dart';
import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}