import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:simple_reddit_fetcher/repository/reddit_api_provider.dart';
import 'package:simple_reddit_fetcher/view/home_list_page.dart';
import 'package:simple_reddit_fetcher/view_model/home_list_page_view_model.dart';

void main() {
  const kind = 'listing';
  const after = 'qwer';
  const before = 'asdf';
  const length = 2;
  const rootUrl = 'https://www.reddit.com';
  const id = 'id tag';
  const author = '23456';
  const title = '34567 title';
  const thumbnailHeight = 12;
  const thumbnailWeight = 34;
  const thumbnail = 'https://123.com/456.jpg';
  const permalink = '/567/890/';
  const date = 1691741421.0;

  testWidgets('show no items when page init', (WidgetTester tester) async {
    final fakeAsync = FakeAsync();
    fakeAsync.run((async) async {
      await tester.pumpWidget(MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeListPage(),
      ));
    });
    fakeAsync.flushMicrotasks();

    // Verify that our counter starts at 0.
    expect(find.text('No items'), findsOneWidget);
  });

  testWidgets('show single item', (WidgetTester tester) async {
    final fakeAsync = FakeAsync();
    fakeAsync.run((async) async {
      final client = MockClient((request) async {
        const sampleDataString = '{"kind": "$kind", "data": '
            '{"after": "$after",'
            '"before": "$before",'
            '"dist": $length,'
            '"children": [{"data":{'
            '"author_fullname":"$author",'
            '"title":"$title",'
            '"thumbnail_height":$thumbnailHeight,'
            '"thumbnail_width":$thumbnailWeight,'
            '"thumbnail":"$thumbnail",'
            '"id":"$id",'
            '"permalink":"$permalink",'
            '"created_utc":$date'
            '}}]}}';
        await Future.delayed(const Duration(seconds: 1));
        return Response(sampleDataString, 200);
      });
      final viewModel = HomeListPageViewModel(
          redditApiProvider: RedditApiProvider(httpClient: client));

      await tester.pumpWidget(MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeListPage(viewModel: viewModel),
      ));
    });
    fakeAsync.flushMicrotasks();
    expect(find.text('No items'), findsOneWidget);

    fakeAsync.elapse(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('No items'), findsNothing);
    expect(find.text(title, findRichText: true), findsOneWidget);
    expect(find.text(author, findRichText: true), findsOneWidget);
    expect(find.text('2023-08-11\t09:10', findRichText: true), findsOneWidget);
  });

  testWidgets('10 items, append 10 item when reach bottom',
      (WidgetTester tester) async {
    final fakeAsync = FakeAsync();
    fakeAsync.run((async) async {
      var numOfFetch = 0;
      final client = MockClient((request) async {
        final requestAfter = request.url.queryParameters['after'];
        expect(requestAfter, isNotNull);
        if (numOfFetch == 0) {
          expect(requestAfter?.isEmpty, true);
        } else {
          expect(requestAfter, after);
        }
        final dataList = numOfFetch < 2
            ? List<int>.generate(10, (index) => 10 * numOfFetch + index + 1)
                .map((e) => '{"data":{'
                    '"author_fullname":"$author$e",'
                    '"title":"$title$e",'
                    '"thumbnail_height":$thumbnailHeight,'
                    '"thumbnail_width":$thumbnailWeight,'
                    '"thumbnail":"$thumbnail",'
                    '"id":"$id$e",'
                    '"permalink":"$permalink",'
                    '"created_utc":${date + e * 60}}}')
                .join(',')
            : '';
        final sampleDataString = '{"kind": "$kind", "data": '
            '{"after": "$after",'
            '"before": "$before",'
            '"dist": $length,'
            '"children": ['
            '$dataList'
            ']}}';
        await Future.delayed(const Duration(milliseconds: 100));
        numOfFetch++;
        return Response(sampleDataString, 200);
      });
      final viewModel = HomeListPageViewModel(
          redditApiProvider: RedditApiProvider(httpClient: client));

      await tester.pumpWidget(MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeListPage(viewModel: viewModel),
      ));
    });
    fakeAsync.flushMicrotasks();
    expect(find.text('No items'), findsOneWidget);

    fakeAsync.flushMicrotasks();
    fakeAsync.elapse(const Duration(milliseconds: 100));
    fakeAsync.flushMicrotasks();
    await tester.pumpAndSettle();

    expect(find.text('No items'), findsNothing);

    final listFinder = find.byType(Scrollable);
    expect(listFinder, findsOneWidget);

    for (var i in List<int>.generate(30, (index) => index + 1)) {
      final titleFinder = find.descendant(
          of: find.byKey(ValueKey('$id$i item')),
          matching: find.byKey(const ValueKey('title')),
          skipOffstage: false);
      final authorFinder = find.descendant(
          of: find.byKey(ValueKey('$id$i item')),
          matching: find.byKey(const ValueKey('author')),
          skipOffstage: false);
      final datetimeFinder = find.descendant(
          of: find.byKey(ValueKey('$id$i item')),
          matching: find.byKey(const ValueKey('datetime')),
          skipOffstage: false);

      if (i <= 20) {
        await tester.scrollUntilVisible(
          datetimeFinder,
          10.0,
          scrollable: listFinder,
        );
        await tester.pumpAndSettle();

        expect(titleFinder, findsOneWidget);
        expect(find.text('$title$i', findRichText: true), findsOneWidget);

        expect(authorFinder, findsOneWidget);
        expect(find.text('$author$i', findRichText: true), findsOneWidget);

        expect(datetimeFinder, findsOneWidget);
        expect(
            find.text(
                DateFormat('yyyy-MM-dd\tHH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        ((date + i * 60) * 1000).round())),
                findRichText: true),
            findsOneWidget);
      } else {
        try {
          await tester.scrollUntilVisible(
            datetimeFinder,
            10.0,
            scrollable: listFinder,
          );
          fail('show not find element at $i');
        } on StateError catch (e) {
          expect(e, isA<StateError>());
        }
      }
    }
  }, timeout: const Timeout(Duration(minutes: 1)));

  testWidgets('reload when pull down at top', (WidgetTester tester) async {
    final fakeAsync = FakeAsync();
    var numOfFetch = 0;
    fakeAsync.run((async) async {
      final client = MockClient((request) async {
        final dataList =
            List<int>.generate(10, (index) => 10 * numOfFetch + index + 1)
                .map((e) => '{"data":{'
                    '"author_fullname":"$author$e",'
                    '"title":"$title$e",'
                    '"thumbnail_height":$thumbnailHeight,'
                    '"thumbnail_width":$thumbnailWeight,'
                    '"thumbnail":"$thumbnail",'
                    '"id":"$id$e",'
                    '"permalink":"$permalink",'
                    '"created_utc":${date + e * 60}}}')
                .join(',');
        final sampleDataString = '{"kind": "$kind", "data": '
            '{"after": "$after",'
            '"before": "$before",'
            '"dist": $length,'
            '"children": ['
            '$dataList'
            ']}}';
        await Future.delayed(const Duration(milliseconds: 100));
        numOfFetch++;
        return Response(sampleDataString, 200);
      });
      final viewModel = HomeListPageViewModel(
          redditApiProvider: RedditApiProvider(httpClient: client));

      await tester.pumpWidget(MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeListPage(viewModel: viewModel),
      ));
    });
    fakeAsync.flushMicrotasks();
    expect(find.text('No items'), findsOneWidget);

    fakeAsync.flushMicrotasks();
    fakeAsync.elapse(const Duration(milliseconds: 100));
    fakeAsync.flushMicrotasks();
    await tester.pumpAndSettle();

    expect(find.text('No items'), findsNothing);
    expect(numOfFetch, 1);

    final listFinder = find.byType(Scrollable);
    expect(listFinder, findsOneWidget);

    final firstTitleFinder = find.descendant(
        of: find.byKey(const ValueKey('${id}1 item')),
        matching: find.byKey(const ValueKey('title')),
        skipOffstage: false);

    await tester.fling(firstTitleFinder, const Offset(0, 400), 1000);
    await tester.pump();

    expect(
      tester.getSemantics(find.byType(RefreshProgressIndicator)),
      matchesSemantics(label: 'Refresh'),
    );

    await tester.pumpAndSettle();

    /*
    // another approach for waiting refresh indicator to finish
    await tester
        .pump(const Duration(seconds: 1)); // finish the scroll animation
    await tester.pump(
        const Duration(seconds: 1)); // finish the indicator settle animation
    await tester.pump(
        const Duration(seconds: 1)); // finish the indicator hide animation
     */

    expect(numOfFetch, 2);
  }, timeout: const Timeout(Duration(minutes: 1)));
}
