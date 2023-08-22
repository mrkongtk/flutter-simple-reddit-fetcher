import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_reddit_fetcher/view/view.abs.dart';
import 'package:simple_reddit_fetcher/view_model/home_list_page_view_model.dart';

import '../model/reddit_post.dart';

class HomeListPage extends ViewAbs<HomeListPageViewModel> {
  HomeListPage({Key? key}) : super.model(HomeListPageViewModel(), key: key);

  @override
  HomeListPageState createState() {
    return HomeListPageState();
  }
}

class HomeListPageState extends ViewState<HomeListPage, HomeListPageViewModel> {
  HomeListPageState() : super();

  @override
  void initState() {
    super.initState();
    viewModel.retrieve();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomeListPageViewModelState>(
      stream: viewModel.state,
      builder: (context, AsyncSnapshot<HomeListPageViewModelState> snapshot) {
        final snapshotData = snapshot.data;
        if (snapshot.hasData &&
            snapshotData != null &&
            snapshotData.dataList.isNotEmpty) {
          return _buildItemList(snapshotData);
        } else {
          return _buildItemListEmpty();
        }
      },
    );
  }

  Widget _buildItemListEmpty() {
    return Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
            child: Center(
                child: Text(
          'No items',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ))));
  }

  Widget _buildItemList(HomeListPageViewModelState snapshotData) {
    final dataList = snapshotData.dataList;
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: NotificationListener<ScrollEndNotification>(
                    onNotification: (scrollEnd) {
                      final metrics = scrollEnd.metrics;
                      if (metrics.atEdge) {
                        bool isTop = metrics.pixels == 0;
                        if (isTop) {
                        } else {
                          if (!snapshotData.isLoading) {
                            viewModel.retrieve(after: snapshotData.after);
                          }
                        }
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        viewModel.retrieve();
                      },
                      child: ListView.separated(
                          padding: const EdgeInsets.all(4),
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dataList.length,
                          itemBuilder: (context, index) =>
                              _buildItem(dataList[index]),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 4,
                              )),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(PostData data) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            child: RichText(
              textAlign: TextAlign.left,
              maxLines: 2,
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
                text: data.title,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                  children: [
                    TextSpan(
                      text: data.authorFullName,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontStyle: FontStyle.italic),
                  children: [
                    TextSpan(
                      text: DateFormat('yyyy-MM-dd\tHH:mm')
                          .format(data.createdDateTime.toLocal()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
