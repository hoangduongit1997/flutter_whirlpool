import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_whirlpool/screens/main/washing_machine/drum/physic/drum_physic.dart';
import 'package:flutter_whirlpool/view_models/service_locator.dart';
import 'package:flutter_whirlpool/view_models/settings_view_model.dart';

typedef PaintCallback();

class WashingMachineController {
  WashingMachineController({
    @required this.ballsCount,
  }) : physic = DrumPhysic(ballsCount: ballsCount);

  final int ballsCount;
  final DrumPhysic physic;

  double get drumAngle => physic?.whirlpoolCoreBody?.getAngle() ?? 0.0;
  double get radius => _radius;
  bool get devMode => ServiceLocator.get<SettingsViewModel>()?.devMode;
  PaintCallback onNeedPaint;

  double _radius;
  bool _initalized = false;

  initialize({double radius}) {
    assert(_initalized != true);
    _initalized = true;

    _radius = radius;
    physic.initialize(radius);
  }

  initializeBalls() {
    physic.initializeBalls();
  }

  hasBalls() {
    return physic.balls.length > 0;
  }

  start() {
    assert(_initalized == true);

    SchedulerBinding.instance.scheduleFrameCallback(step);
    redraw();
  }

  step(Duration timeStamp) {
    assert(_initalized == true);

    physic.step();
    SchedulerBinding.instance.scheduleFrameCallback(step, rescheduling: true);
    redraw();
  }

  setAngularVelocity(
    double value, {
    double seconds = 0.0,
    bool stopAtEnd = false,
  }) {
    if (_initalized != true) {
      return;
    }

    physic.setAngularVelocity(value, seconds: seconds, stopAtEnd: stopAtEnd);
  }

  redraw() {
    if (onNeedPaint != null) {
      onNeedPaint();
    }
  }
}
