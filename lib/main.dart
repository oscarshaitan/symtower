import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:symtower/tetromino/block/block.dart';
import 'package:symtower/tetromino/block/utils.dart';
import 'package:symtower/world/pavement.dart';

import 'npc/crowd.dart';

void main() {
  runApp(GameWidget.controlled(gameFactory: SymTower.new));
}

class SymTower extends Forge2DGame with TapCallbacks {
  int _life = 1000;

  @override
  Future<void> onLoad() async {
    TiledComponent homeMap = await TiledComponent.load('symtower_map_60_32.tmx', Vector2.all(tileSize));

    camera = CameraComponent(
      world: world,
      viewport: FixedSizeViewport(homeMap.size.x, homeMap.size.y),
    );

    addAll([homeMap, Pavement()]);
    _generateCrowd();
    _generateBlocks();

    List<TiledObject> foundation = homeMap.tileMap.getLayer<ObjectGroup>('FoundationObj')!.objects;

    addAll(foundation.map((foundationTile) => FoundationBlock(foundationTile)));

    await super.onLoad();
  }

  @override
  Future<void> onTapDown(event) async {
    addAll([TetrominoBlock(blockSprite: randomBlockSprite())]);
  }

  _generateCrowd() async {
    while (true) {
      add(Crowd());

      await Future.delayed(const Duration(seconds: 3));
    }
  }

  _generateBlocks() async {
    while (true) {
      add(TetrominoBlock(blockSprite: randomBlockSprite()));

      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  onCrowdKilled() {
    _life--;
    if (_life <= 0 && !paused) {
      pauseEngine();
    }
  }
}
