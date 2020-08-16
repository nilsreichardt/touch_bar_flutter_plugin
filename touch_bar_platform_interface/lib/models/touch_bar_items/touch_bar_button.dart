// Copyright (c) 2020 Eduardo Vital Alencar Cunha
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../extensions/color_extension.dart';
import '../labeled_image.dart';
import '../touch_bar_image.dart';
import '../touch_bar_item.dart';

class TouchBarButton extends TouchBarItem {
  /// Creates a new [TouchBarButton] item with the given [label],
  /// [accessibilityLabel], [backgroundColor], [icon], [iconPosition]
  /// and [onClick].
  ///
  /// [iconPosition] is set to (the first condition to match will be applied):
  /// - [ImagePosition.noImage] if [icon] is null;
  /// - [ImagePosition.imageOnly] if [label] is null;
  /// - [ImagePosition.left] if [iconPosition] is null;
  /// - otherwise the [iconPosition] value will be used.
  TouchBarButton({
    String label,
    String accessibilityLabel,
    Color backgroundColor,
    TouchBarImage icon,
    ImagePosition iconPosition,
    VoidCallback onClick,
  })  : this._onClick = onClick.hashCode.toString(),
        this._accessibilityLabel = accessibilityLabel,
        this._backgroundColor = backgroundColor,
        this._labeledIcon = LabeledImage(
          image: icon,
          label: label,
          imagePosition: iconPosition,
        ),
        super(methods: {'${onClick.hashCode}': onClick});

  @override
  String get type => "Button";

  TouchBarImage get icon => _labeledIcon.image;
  String get label => _labeledIcon.label;
  ImagePosition get iconPosition => _labeledIcon.imagePosition;
  String get accessibilityLabel => _accessibilityLabel;
  Color get backgroundColor => _backgroundColor;

  set icon(TouchBarImage newValue) {
    updateProperty('icon', newValue: newValue);
    this._labeledIcon.image = newValue;
  }

  set label(String newValue) {
    updateProperty('label', newValue: newValue);
    this._labeledIcon.label = newValue;
  }

  set iconPosition(ImagePosition newValue) {
    updateProperty('iconPosition', newValue: newValue.toString());
    this._labeledIcon.imagePosition = newValue;
  }

  set accessibilityLabel(String newValue) {
    updateProperty('accessibilityLabel', newValue: newValue);
    _accessibilityLabel = newValue;
  }

  set backgroundColor(Color newValue) {
    updateProperty('backgroundColor', newValue: newValue.toRGBA());
    _backgroundColor = newValue;
  }

  set onClick(Function newValue) {
    // It is necessary to change only the [onClick] implementation.
    // The hashcode should remain the same since it is used only to
    // assure uniqueness.
    this.methods['$_onClick'] = newValue;
  }

  /// Icon with label and iconpPosition information.
  LabeledImage _labeledIcon;

  /// A succinct description of the [TouchBarButton] used to provide
  /// accessibility.
  String _accessibilityLabel;

  /// Background color of te [TouchBarButton]
  Color _backgroundColor;

  /// The hash code of the method called when the button is clicked.
  ///
  /// The implementation of this method is stored in
  /// [AbstractTouchBarItem.methods].
  String _onClick;

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'type': type,
      'iconPosition': iconPosition.toString(),
    };
    if (label != null) map['label'] = label;
    if (accessibilityLabel != null)
      map['accessibilityLabel'] = accessibilityLabel;
    if (backgroundColor != null)
      map['backgroundColor'] = backgroundColor.toRGBA();
    if (_onClick != null) map['onClick'] = _onClick;
    if (icon != null) map['icon'] = icon;

    return map;
  }
}
