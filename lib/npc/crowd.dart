import 'dart:math';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:symtower/main.dart';
import 'package:symtower/npc/crowd_sprite.dart';
import 'package:symtower/tetromino/block/export.dart';

class Crowd extends BodyComponent<SymTower> with ContactCallbacks {
  Crowd() : super(renderBody: false);
  late final CrowdSprite _crowdSprite;
  bool _gotHit = false;

  @override
  Future<void> onLoad() async {
    bool leftSpawn = Random().nextBool();
    bodyDef = BodyDef(
        userData: this,
        position: _getSpawn(leftSpawn),
        type: BodyType.kinematic,
        linearVelocity: Vector2(_getVelocity(leftSpawn), 0));
    fixtureDefs = [
      FixtureDef(
        isSensor: true,
        PolygonShape()
          ..set([
            Vector2(crowdSize / 4, 0),
            Vector2(crowdSize / 4, crowdSize),
            Vector2(crowdSize * 3 / 4, crowdSize),
            Vector2(crowdSize * 3 / 4, 0),
          ]),
      )
    ];

    _crowdSprite = CrowdSprite(leftSpawn);
    add(_crowdSprite);
    super.onLoad();
  }

  double _getVelocity(bool leftSpawn) => leftSpawn ? crowdSize : -crowdSize;

  Vector2 _getSpawn(bool leftSpawn) {
    if (leftSpawn) {
      return Vector2(0, game.size.y - crowdSize - 2 * tileSize);
    } else {
      return Vector2(game.size.x - crowdSize, game.size.y - crowdSize - 2 * tileSize);
    }
  }

  @override
  beginContact(Object other, Contact contact) async {
    await _getHit(other);
  }

  Future<void> _getHit(Object other) async {
    if (other is TetrominoBlock && !_gotHit && !other.onTheGround) {
      _gotHit = true;

      body.linearVelocity = Vector2(0, 0);
      _crowdSprite.hitByBlock();

      await Future.delayed(const Duration(milliseconds: 600));
      game.onCrowdKilled();
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    _checkOutOfView();
    super.update(dt);
  }

  void _checkOutOfView() {
    if (position.x > (game.size.x + crowdSize) || position.x < -crowdSize) {
      removeFromParent();
    }
  }
}
