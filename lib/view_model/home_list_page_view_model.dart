import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../model/reddit_post.dart';
import '../repository/reddit_api_provider.dart';
import 'view_model.abs.dart';

class HomeListPageState {
  final String? after;
  final List<PostData> dataList;
  final bool isLoading;

  HomeListPageState._(this.after, this.dataList, this.isLoading);

  factory HomeListPageState.empty() {
    return HomeListPageState._(null, [], false);
  }

  HomeListPageState append(PostListData postListData) {
    final newList = dataList + postListData.dataList;
    return HomeListPageState._(postListData.after, newList, isLoading);
  }

  HomeListPageState setLoading(bool isLoading) {
    return HomeListPageState._(after, dataList, isLoading);
  }
}

class HomeListPageViewModel extends ViewModelAbs {
  final _stateSubject =
      BehaviorSubject<HomeListPageState>.seeded(HomeListPageState.empty());
  late final RedditApiProvider _redditApiProvider;
  final Logger _logger = Logger();

  Stream<HomeListPageState> get state => _stateSubject;

  HomeListPageViewModel({RedditApiProvider? redditApiProvider}) {
    _redditApiProvider = redditApiProvider ?? RedditApiProvider();
  }

  @mustCallSuper
  @override
  void dispose() {
    _stateSubject.close();
  }

  void retrieve({String? after}) {
    _setLoading(true);
    _redditApiProvider
        .getPost(after: after)
        .then((value) => {_append(value.data)},
            onError: (Object e, StackTrace stackTrace) {
      _logger.e(e.toString());
      _logger.e(stackTrace);
    }).whenComplete(() => _setLoading(false));
  }

  void _append(PostListData postListData) {
    final state = _stateSubject.value;
    _updateState(state.append(postListData));
  }

  void _setLoading(bool isLoading) {
    final state = _stateSubject.value;
    _updateState(state.setLoading(isLoading));
  }

  void _updateState(HomeListPageState state) {
    _stateSubject.add(state);
  }
}
