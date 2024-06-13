import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef paginationWidgetBuilder<T extends IModelWithId> = Widget Function(
    BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase>
      provider;
  final paginationWidgetBuilder<T> itemBuilder;

  const PaginationListView(
      {required this.provider, required this.itemBuilder, Key? key})
      : super(key: key);

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(Listener);
  }

  void Listener() {
    PaginationUtils.paginate(
        controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    controller.removeListener(Listener);
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    if (state is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    // cursor pagnaiton에 자식임.
    if (state is CursorPaginationError) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(state.message, textAlign: TextAlign.center),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            ref.read(widget.provider.notifier).paginate(forceRefetch: true);
          },
          child: Text("다시시도"),
        )
      ]);
    }

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막데이터입니다.'),
              ),
            );
          }

          final pItem = cp.data[index];
          //final pItem = RestaurantModel.fromJson(item);
          return widget.itemBuilder(
            context,
            index,
            pItem,
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
      ),
    );
  }
}
