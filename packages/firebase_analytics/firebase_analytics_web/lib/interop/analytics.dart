// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:js_interop';

import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';
import 'package:firebase_core_web/firebase_core_web_interop.dart';

import 'analytics_interop.dart' as analytics_interop;

export 'analytics_interop.dart';

/// Given an AppJSImp, return the Analytics instance.
Analytics getAnalyticsInstance([App? app]) {
  return Analytics.getInstance(
    app != null
        ? analytics_interop.getAnalytics(app.jsObject)
        : analytics_interop.getAnalytics(),
  );
}

class Analytics extends JsObjectWrapper<analytics_interop.AnalyticsJsImpl> {
  Analytics._fromJsObject(analytics_interop.AnalyticsJsImpl jsObject)
      : super.fromJsObject(jsObject);
  static final _expando = Expando<Analytics>();

  /// Creates a new Analytics instance from a [jsObject].
  static Analytics getInstance(analytics_interop.AnalyticsJsImpl jsObject) {
    return _expando[jsObject] ??= Analytics._fromJsObject(jsObject);
  }

  static Future<bool> isSupported() async {
    final result = await analytics_interop.isSupported().toDart;
    return result! as bool;
  }

  /// Non-null App for this instance of analytics service.
  App get app => App.getInstance(jsObject.app);

  void logEvent({
    required String name,
    Map<String, Object?>? parameters,
    AnalyticsCallOptions? callOptions,
  }) {
    return analytics_interop.logEvent(
      jsObject,
      name.toJS,
      parameters?.jsify(),
      callOptions?.asMap().jsify() as JSObject?,
    );
  }

  void setAnalyticsCollectionEnabled({required bool enabled}) {
    return analytics_interop.setAnalyticsCollectionEnabled(
      jsObject,
      enabled.toJS,
    );
  }

  void setCurrentScreen({
    String? screenName,
    AnalyticsCallOptions? callOptions,
  }) {
    return analytics_interop.logEvent(
      jsObject,
      'screen_view'.toJS,
      {'firebase_screen': screenName}.jsify(),
      callOptions?.asMap().jsify() as JSObject?,
    );
  }

  void setUserId({
    String? id,
    AnalyticsCallOptions? callOptions,
  }) {
    return analytics_interop.setUserId(
      jsObject,
      id?.toJS,
      callOptions?.asMap().jsify() as JSObject?,
    );
  }

  void setUserProperty({
    required String name,
    required String? value,
    AnalyticsCallOptions? callOptions,
  }) {
    return analytics_interop.setUserProperties(
      jsObject,
      {name: value}.jsify(),
      callOptions?.asMap().jsify() as JSObject?,
    );
  }
}
