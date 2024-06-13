import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/common/dio/dio.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/repository/restaurant_repository.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(controller: controller, provider: ref.read(restaurantProvider.notifier));
    //현재위치가 최대길이보다 조금 덜되는 위치까지 왔다면 새로운 데이터를 추가요청
    // print('run');
    // if (controller.offset > controller.position.maxScrollExtent - 300) {
    //   ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    // }
  }

  @override
  Widget build(BuildContext context) {
    
    return PaginationListView(provider: restaurantProvider, itemBuilder: <RestaurantModel>(_,index,model){
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RestaurantDetailScreen(id: model.id),
            ),
          );
        },
        child: RestaurantCard.fromModel(
          model: model,
        ),
      );
    });
    final data = ref.watch(restaurantProvider);

    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    // cursor pagnaiton에 자식임.
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    final cp = data as CursorPagination;
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
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막데이터입니다.'),
              ),
            );
          }

          final pItem = cp.data[index];
          //final pItem = RestaurantModel.fromJson(item);
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(id: pItem.id),
                ),
              );
            },
            child: RestaurantCard.fromModel(
              model: pItem,
            ),
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
      ),
    );
  }
}
