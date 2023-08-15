import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../model/reddit_post.dart';
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

  Stream<HomeListPageState> get state => _stateSubject;

  @mustCallSuper
  @override
  void dispose() {
    _stateSubject.close();
  }

  void append(PostListData postListData) {
    final state = _stateSubject.value;
    _updateState(state.append(postListData));
  }

  void setLoading(bool isLoading) {
    final state = _stateSubject.value;
    _updateState(state.setLoading(isLoading));
  }

  void _updateState(HomeListPageState state) {
    _stateSubject.add(state);
  }
}
