import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';

import 'tetromino/block.dart';

void main() {
  runApp(const GameWidget.controlled(gameFactory: SymTower.new));
}

class SymTower extends Forge2DGame with TapCallbacks {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport.add(FpsTextComponent());

    world.addAll(createBoundaries());
    final visibleRect = camera.visibleWorldRect;
    visibleRect.bottomCenter;

    world.add(SpriteComponent(
      sprite: await Sprite.load('crane/crane_pilar.png'),
      anchor: Anchor.center,
      scale: Vector2.all(.1),
    ));
    world.addAll([
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2(), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(3.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(6.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(9.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(12.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(15.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-3.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-6.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-9.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-12.2, 0)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-15.2, 0)), isFoundation: true),
    ]);
  }

  @override
  void onTapDown(event) {
    var block = TetrominoBlock(blockSprite: randomBlockSprite(), initialPosition: Vector2(0, 0));
    var block2 = TetrominoBlock(blockSprite: randomBlockSprite(), initialPosition: Vector2(3.2, 0));

    world.addAll([block2, block]);
  }

  List<Component> createBoundaries() {
    final visibleRect = camera.visibleWorldRect;
    final topLeft = visibleRect.topLeft.toVector2();
    final topRight = visibleRect.topRight.toVector2();
    final bottomRight = visibleRect.bottomRight.toVector2();
    final bottomLeft = visibleRect.bottomLeft.toVector2();

    return [
      Wall(topRight, bottomRight),
      Wall(bottomLeft, bottomRight),
      Wall(topLeft, bottomLeft),
    ];
  }
}

class Wall extends BodyComponent {
  final Vector2 _start;
  final Vector2 _end;

  Wall(this._start, this._end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(_start, _end);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(position: Vector2.zero());
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
