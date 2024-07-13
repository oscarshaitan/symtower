import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';

import 'npc/crowd.dart';

void main() {
  runApp(
    const Center(
      child: ClipRect(
        child: SizedBox(
          width: 60 * 18,
          height: 78 * 18,
          child: GameWidget.controlled(gameFactory: SymTower.new),
        ),
      ),
    ),
  );
}

class SymTower extends Forge2DGame with TapCallbacks {
  int _life = 10;

  @override
  Future<void> onLoad() async {
    camera = CameraComponent.withFixedResolution(width: size.x, height: size.y);
    camera.viewport.add(FpsTextComponent());
    await super.onLoad();

    TiledComponent homeMap = await TiledComponent.load('symtower_map_60_32.tmx', Vector2(18, 18));
    add(homeMap);

    //addAll(createBoundaries());
    _generateCrowd();
  }

  @override
  Future<void> onTapDown(event) async {
    print(event.localPosition);
    addAll([
      Crowd(), /*TetrominoBlock(blockSprite: randomBlockSprite(), isFoundation: false)*/
    ]);
  }

  _generateCrowd() async {
    while (true) {
      //  addAll(([Crowd()]);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  onCrowdKilled() {
    _life--;
    if (_life <= 0 && !paused) {
      pauseEngine();
    }
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final bottomRight = visibleRect.bottomRight.toVector2()..add(Vector2(100, 0));
    final bottomLeft = visibleRect.bottomLeft.toVector2()..add(Vector2(-100, 0));

    return [Wall(bottomLeft, bottomRight)];
  }
}

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 1);
    final bodyDef = BodyDef(position: Vector2.zero());
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
