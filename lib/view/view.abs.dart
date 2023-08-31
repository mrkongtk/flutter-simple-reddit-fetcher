import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../view_model/view_model.abs.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

abstract class ViewAbs<VM extends ViewModelAbs> extends StatefulWidget {
  final VM viewModel;

  const ViewAbs.model(this.viewModel, {Key? key}) : super(key: key);
}

abstract class ViewState<V extends ViewAbs, VM extends ViewModelAbs> extends State<V>
    with RouteAware {
  late final VM _viewModel;
  late final Logger logger;

  VM get viewModel => _viewModel;

  String get _sanitisedRoutePageName {
    return '$runtimeType'.replaceAll('_', '').replaceAll('State', '');
  }

  ViewState() : super() {
    logger = Logger();
    logger.d('Created $runtimeType.');
  }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel as VM;
    viewModel.init();
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // subscribe for the change of route
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @mustCallSuper
  @override
  void didPopNext() {
    logger.d('🚚 $_sanitisedRoutePageName didPopNext');
    viewModel.routingDidPopNext();
  }

  /// Called when the current route has been pushed.
  @mustCallSuper
  @override
  void didPush() {
    logger.d('🚚 $_sanitisedRoutePageName didPush');
    viewModel.routingDidPush();
  }

  /// Called when the current route has been popped off.
  @mustCallSuper
  @override
  void didPop() {
    logger.d('🚚 $_sanitisedRoutePageName didPop');
    viewModel.routingDidPop();
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @mustCallSuper
  @override
  void didPushNext() {
    logger.d('🚚 $_sanitisedRoutePageName didPushNext');
    viewModel.routingDidPushNext();
  }

  @mustCallSuper
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    logger.d('Disposing $runtimeType.');
    viewModel.dispose();
    super.dispose();
  }
}
