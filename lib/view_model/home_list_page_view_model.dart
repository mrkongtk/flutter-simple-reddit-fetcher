import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../model/reddit_post.dart';
import '../repository/reddit_api_provider.dart';
import 'view_model.abs.dart';

class HomeListPageViewModelState {
  final String? after;
  final List<PostData> dataList;
  final bool isLoading;

  HomeListPageViewModelState._(this.after, this.dataList, this.isLoading);

  factory HomeListPageViewModelState.empty() {
    return HomeListPageViewModelState._(null, [], false);
  }

  HomeListPageViewModelState append(PostListData postListData) {
    final newList = dataList + postListData.dataList;
    return HomeListPageViewModelState._(postListData.after, newList, isLoading);
  }

  HomeListPageViewModelState setLoading(bool isLoading) {
    return HomeListPageViewModelState._(after, dataList, isLoading);
  }
}

class HomeListPageViewModel extends ViewModelAbs {
  final _stateSubject = BehaviorSubject<HomeListPageViewModelState>.seeded(
      HomeListPageViewModelState.empty());
  late final RedditApiProvider _redditApiProvider;
  final Logger _logger = Logger();

  Stream<HomeListPageViewModelState> get state => _stateSubject;

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
    _redditApiProvider.getPost(after: after).catchError((e) {
      _logger.e(e.toString());
    }).then((value) {
      if (value.isRight) {
        if (after == null) {
          return _newList(value.right.data);
        } else {
          return _append(value.right.data);
        }
      }
    }).whenComplete(() {
      _setLoading(false);
    });
  }

  HomeListPageViewModelState _newList(PostListData postListData) {
    final result = HomeListPageViewModelState.empty().append(postListData);
    _updateState(result);
    return result;
  }

  HomeListPageViewModelState _append(PostListData postListData) {
    final result = _stateSubject.value.append(postListData);
    _updateState(result);
    return result;
  }

  HomeListPageViewModelState _setLoading(bool isLoading) {
    final result = _stateSubject.value.setLoading(isLoading);
    _updateState(result);
    return result;
  }

  void _updateState(HomeListPageViewModelState state) {
    _stateSubject.add(state);
  }
}
