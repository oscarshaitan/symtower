import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:symtower/npc/crowd.dart';
import 'package:symtower/tetromino/block/export.dart';
import 'package:symtower/world/pavement.dart';

class TetrominoBlock extends BodyComponent with TapCallbacks, ContactCallbacks {
  final ({Material material, TileStyle style})? blockSprite;

  bool onTheGround = false;
  final Vector2? initialPosition;

  TetrominoBlock({this.initialPosition, this.blockSprite}) : super(renderBody: false);

  @override
  Future<void> onLoad() async {
    bodyDef = BodyDef(
      userData: this,
      linearDamping: 0,
      position: Vector2((18 * 30) + 9, 18 * 16),
      type: BodyType.dynamic,
      gravityOverride: Vector2(0, 100),
    );

    fixtureDefs = _fixtureDef();

    add(
      SpriteComponent(
        sprite: await Sprite.load('blocks/${blockSprite!.material.name}/${blockSprite!.style.name}.png'),
        anchor: Anchor.center,
        size: Vector2.all(tileSize),
      ),
    );

    super.onLoad();
  }

  List<FixtureDef> _fixtureDef() {
    return [
      FixtureDef(
        PolygonShape()
          ..set([
            Vector2(-(tileSize / 2), (tileSize / 2)),
            Vector2((tileSize / 2), -(tileSize / 2)),
            Vector2(-(tileSize / 2), -(tileSize / 2)),
            Vector2((tileSize / 2), (tileSize / 2)),
          ]),
        restitution: switch (blockSprite!.material) {
          Material.marvel => 0.3,
          Material.rock => 0.2,
          Material.stone => 0.1,
        },
        density: switch (blockSprite!.material) {
          Material.marvel => 500,
          Material.rock => 300,
          Material.stone => 1000,
        },
        friction: switch (blockSprite!.material) {
          Material.marvel => 0.2,
          Material.rock => 0.5,
          Material.stone => 0.7,
        },
      )
    ];
  }

  @override
  void onTapDown(TapDownEvent event) {}

  @override
  beginContact(Object other, Contact contact) async {
    if (other is Pavement) {
      onTheGround = true;
    }

    if (other is Pavement || other is Crowd) {
      await Future.delayed(const Duration(milliseconds: 600));
      removeFromParent();
    }
  }

  void multiplyGravity(double multiplier) {
    body.linearVelocity = Vector2(0, multiplier * body.linearVelocity.y);
  }

  void affectFriction(double newFriction) {
    body.fixtures.first.friction = newFriction;
  }

  /// positive speed will move the block to the right, negative to the left
  void applyWind(double windSpeed) {
    body.linearVelocity = Vector2(windSpeed, 0);
  }
}

class FoundationBlock extends BodyComponent with ContactCallbacks {
  final TiledObject foundationTile;

  FoundationBlock(this.foundationTile);

  @override
  Future<void> onLoad() async {
    bodyDef = BodyDef(
      userData: this,
      position: Vector2(foundationTile.x + tileSize / 2, foundationTile.y + tileSize / 2),
      linearDamping: 0,
      gravityOverride: Vector2(0, 100),
      type: BodyType.static,
    );

    fixtureDefs = [
      FixtureDef(
        PolygonShape()
          ..set([
            Vector2(-(tileSize / 2), (tileSize / 2)),
            Vector2((tileSize / 2), -(tileSize / 2)),
            Vector2(-(tileSize / 2), -(tileSize / 2)),
            Vector2((tileSize / 2), (tileSize / 2)),
          ]),
      )
    ];

    add(
      SpriteComponent(
        sprite: await Sprite.load('blocks/sand/tile_0025.png'),
        anchor: Anchor.center,
        size: Vector2.all(tileSize),
      ),
    );

    super.onLoad();
  }
}
