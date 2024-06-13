import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:actual/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/cursor_pagination_model.dart';

class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>> extends StateNotifier<CursorPaginationBase> {

  final U repository;

  PaginationProvider({
    required this.repository
})
      : super(
          CursorPaginationLoading(),
        ){
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    //5가지 가능성
    // state 상태
    //1) cursorpagination  -- 정상적으로 데이터가 있는 상태
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          return;
        }
      }
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );
      //fetchMore (데이터를 추가로 더 가져오는 상황)
      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } // 데이터를 처음부터 가져오는 상황
      else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터에 새로운 데이터 추가
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e,stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지못함');
    }
  }
}
