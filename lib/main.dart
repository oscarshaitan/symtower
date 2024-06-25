import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/widgets.dart';
import 'package:symtower/npc/crowd.dart';

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

   /* world.add(SpriteComponent(
      sprite: await Sprite.load('crane/crane_pilar.png'),
      anchor: Anchor.center,
      position: Vector2(0, -50),
      scale: Vector2.all(.09),
    ));*/
    world.addAll([
      TetrominoBlock(/*initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(0, -1)),*/ isFoundation: true),
      /* TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(3.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(6.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(9.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(12.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(15.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-3.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-6.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-9.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-12.2, -1)), isFoundation: true),
      TetrominoBlock(initialPosition: visibleRect.bottomCenter.toVector2()..add(Vector2(-15.2, -1)), isFoundation: true),*/
    ]);
  }

  @override
  void onTapDown(event) {
    final bottomLeft = camera.visibleWorldRect.bottomLeft.toVector2()..add(Vector2(-crowdSize, -crowdSize));
    var crowd1 = Crowd();
    world.addAll([crowd1]);
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
