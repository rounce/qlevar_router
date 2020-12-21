import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'router.dart';
import 'types.dart';

class RoutesTree {
  final List<_QRoute> _routes = [];

  MatchContext _cureentTree;
  QRouterDelegate _rootDelegate;

  // Build the Route Tree.
  List<_QRoute> _buildTree(List<QRoute> routes, String basePath) {
    final result = <_QRoute>[];
    if (routes == null || routes.isEmpty) return result;
    for (var route in routes) {
      var path = route.path;
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      final fullPath = basePath + (path.isEmpty ? '' : '/$path');
      final _route = _QRoute(
        name: route.name ?? path,
        isComponent: path.startsWith(':'),
        path: path,
        page: route.page,
        redirectGuard: route.redirectGuard ?? (s) => null,
        fullPath: fullPath,
      );
      _route.children.addAll(_buildTree(route.children, fullPath));
      result.add(_route);
      QR.log('"${_route.name}" added with base $basePath');
    }
    return result;
  }

  QRouterDelegate setTree(
      List<QRoute> routes, QRouterDelegate Function() delegate) {
    if (_routes.isNotEmpty) {
      QR.log('Tree already set');
      return _rootDelegate;
    }

    _routes.addAll(_buildTree(routes, ''));
    _rootDelegate = delegate();
    return _rootDelegate;
  }

  MatchContext getMatch(String path, {String parentPath}) {
    parentPath = parentPath ?? '';
    path = path.trim();
    QR.log('matching for $path for parent: $parentPath');

    // Check if the same route
    if (path == QR.currentRoute.fullPath && QR.currentRoute.match != null) {
      return QR.currentRoute.match;
    }

    MatchRoute match;

    if (parentPath.isNotEmpty) {
      if (parentPath == 'QRouterBasePath') parentPath = '';
      match = _getMatchWithParent(path, parentPath);
      if (parentPath.isEmpty) {
        _cureentTree = match;
      }
    } else {
      match = _getMatchWithoutParent(path);
    }

    // //Set initRoute
    // final initMatch = MatchRoute.fromTree(routes: searchIn, path: '');
    // if (!match.found) return _notFound(path);
    // childMatch.childMatch = initMatch;

    // AddParams
    final params = Uri.parse(path).queryParametersAll;
    for (var item in params.entries) {
      if (item.value.length == 1) {
        match.params.addAll({item.key: item.value.first});
      } else if (item.value.isNotEmpty) {
        match.params.addAll({item.key: item.value});
      }
    }

    final context = MatchContext.fromRoute(match);

    // Set current route info
    QR.currentRoute.fullPath = path;
    QR.currentRoute..params = match.params;
    QR.currentRoute.match = context;

    return context;
  }

  MatchRoute _getMatchWithParent(String path, String parentPath) {
    var searchIn = _routes;
    for (var item in Uri.parse(parentPath).pathSegments) {
      searchIn =
          MatchRoute.fromTree(routes: searchIn, path: item).route.children;
    }

    MatchRoute match;
    // if init route for a path.
    if (path == '' || path == '/') {
      if (path.startsWith('/')) path = path.substring(1);
      match = MatchRoute.fromTree(routes: searchIn, path: path);
    } else {
      final uri = Uri.parse(path);
      String childInit;
      if (uri.pathSegments.length > 1 && uri.pathSegments[1].isNotEmpty) {
        childInit = '/${uri.pathSegments[1]}';
      }
      match = MatchRoute.fromTree(
          routes: searchIn, path: uri.pathSegments[0], childInit: childInit);
    }
    return !match.found ? _notFound(path) : match;
  }

  MatchRoute _getMatchWithoutParent(String path) {
    final currentRoute = Uri.parse(QR.currentRoute.fullPath).pathSegments;
    final newRoute = Uri.parse(path).pathSegments;

    // InitalRoute
    if (newRoute.isEmpty) {
      return MatchRoute.fromTree(routes: _routes, path: '');
    }

    var searchIn = _routes;
    _QRoute parent;
    var matchLevel = 0;
    // Search for the match level
    for (matchLevel;
        matchLevel < min(newRoute.length, currentRoute.length);
        matchLevel++) {
      if (currentRoute[matchLevel] != newRoute[matchLevel]) {
        break;
      }

      parent = searchIn
          .firstWhere((element) => element.path == currentRoute[matchLevel]);
      searchIn = parent.children;
    }
    // Clean the unused route.

    // return the new match
    final match =
        MatchRoute.fromTree(routes: searchIn, path: newRoute[matchLevel++]);
    if (!match.found) return _notFound(path);

    searchIn = match.route.children;

    // build rest tree
    var childMatch = match;
    for (matchLevel; matchLevel < newRoute.length; matchLevel++) {
      searchIn = childMatch.route.children;
      childMatch.childMatch =
          MatchRoute.fromTree(routes: searchIn, path: newRoute[matchLevel]);
      if (!match.found) return _notFound(path);
      childMatch = childMatch.childMatch;
    }
    return match;
  }

  // Get match object for notFound Page.
  MatchRoute _notFound(String path) {
    QR.currentRoute.fullPath = path;
    final match = MatchRoute.fromTree(routes: _routes, path: 'notFound');
    QR.currentRoute.match = match;
    return match;
  }
}

class _QRoute {
  final String name;
  final String path;
  final String fullPath;
  final RedirectGuard redirectGuard;
  final QRouteBuilder page;
  final bool isComponent;
  final List<_QRoute> children = [];

  _QRoute(
      {this.name,
      this.isComponent = false,
      @required this.path,
      @required this.page,
      @required this.redirectGuard,
      @required this.fullPath});

  _QRoute copyWith({String name, String path, String fullPath}) => _QRoute(
      fullPath: fullPath ?? this.fullPath,
      name: name ?? this.name,
      path: path ?? this.path,
      page: page,
      redirectGuard: redirectGuard,
      isComponent: isComponent);

  bool get hasChidlren => children != null && children.isNotEmpty;

  @override
  String toString() =>
      // ignore: lines_longer_than_80_chars
      'fullPath: $fullPath, path: $path,isComponent: $isComponent hasChidlren: $hasChidlren';
}

class MatchRoute {
  final _QRoute route;
  final bool found;
  MatchRoute childMatch;
  final String childInit;
  final Map<String, dynamic> params;
  MatchRoute({
    this.route,
    this.found = true,
    this.childInit,
    this.childMatch,
    this.params,
  });

  factory MatchRoute.notFound() => MatchRoute(found: false);

  factory MatchRoute.fromTree(
      {List<_QRoute> routes, String path, String childInit}) {
    if (routes.isEmpty) {
      return null;
    }
    if (!routes.any((route) => route.path == path || route.isComponent)) {
      return MatchRoute.notFound();
    }

    var matchs = routes.where((route) => route.path == path);
    final params = <String, dynamic>{};
    _QRoute match;
    if (matchs.isEmpty) {
      matchs = routes.where((route) => route.isComponent);
      final component = matchs.first.path.substring(1);
      params.addAll({component: path});
      final fullPath =
          matchs.first.fullPath.replaceAll(matchs.first.path, path);
      match = matchs.first.copyWith(path: path, fullPath: fullPath);
    } else {
      match = matchs.first;
    }
    // TODO : Fix redirect.
    //final redirect = match.redirectGuard(QR.currentRoute.fullPath);
    // if (redirect != null) {
    //   return QR.findMatch(redirect);
    // }
    return MatchRoute(route: match, params: params, childInit: childInit);
  }
}

class MatchContext {
  final String name;
  final String fullPath;
  final QRouteBuilder page;
  final MatchContext childContext;
  final QRouter<dynamic> childRouter;

  MatchContext(
      {this.name,
      this.fullPath,
      this.page,
      this.childContext,
      this.childRouter});

  factory MatchContext.fromRoute(MatchRoute route,
          {QRouter<dynamic> childRouter}) =>
      MatchContext(
          name: route.route.name,
          fullPath: route.route.fullPath,
          page: route.route.page,
          childContext: route.childMatch == null
              ? null
              : MatchContext.fromRoute(route.childMatch),
          childRouter: childRouter);

  MaterialPage toMaterialPage() => MaterialPage(
      name: name, key: ValueKey(fullPath), child: page(childRouter));

  void triggerChild() {
    if (childRouter == null) {
      return;
    }
    childRouter.routerDelegate.setNewRoutePath(childRouter);
  }
}
