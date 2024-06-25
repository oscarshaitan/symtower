import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

enum Material { marvel, rock, stone }

enum TileStyle { tile_0000, tile_0001, tile_0002, tile_0003, tile_0006, tile_0011, tile_0013, tile_0016, tile_0021 }

({Material material, TileStyle style}) randomBlockSprite() {
  return (material: Material.values.random(), style: TileStyle.values.random());
}

const double size = 2;

class TetrominoBlock extends BodyComponent with TapCallbacks {
  final ({Material material, TileStyle style})? blockSprite;
  final bool isFoundation;

  final Vector2? initialPosition;

  TetrominoBlock({this.initialPosition, this.blockSprite, this.isFoundation = false})
      : assert((!isFoundation && blockSprite != null) || (isFoundation && blockSprite == null)),
        super(renderBody: false);

  @override
  Future<void> onLoad() async {
    bodyDef = BodyDef(
      angularDamping: 0.8,
      position: initialPosition ?? Vector2.zero(),
      type: isFoundation ? BodyType.static : BodyType.dynamic,
    );

    fixtureDefs = _fixtureDef();

    add(
      SpriteComponent(
        sprite: await Sprite.load(
          isFoundation ? 'blocks/sand/tile_0025.png' : 'blocks/${blockSprite!.material.name}/${blockSprite!.style.name}.png',
        ),
        anchor: Anchor.center,
        size: Vector2.all(size),
      ),
    );

    super.onLoad();
  }

  List<FixtureDef> _fixtureDef() {
    if (isFoundation) {
      return [
        FixtureDef(
          PolygonShape()
            ..set([
              Vector2(-(size / 2), (size / 2)),
              Vector2((size / 2), -(size / 2)),
              Vector2(-(size / 2), -(size / 2)),
              Vector2((size / 2), (size / 2)),
            ]),
        )
      ];
    }
    return [
      FixtureDef(
        PolygonShape()
          ..set([
            Vector2(-(size / 2), (size / 2)),
            Vector2((size / 2), -(size / 2)),
            Vector2(-(size / 2), -(size / 2)),
            Vector2((size / 2), (size / 2)),
          ]),
        restitution: switch (blockSprite!.material) {
          Material.marvel => 0.6,
          Material.rock => 0.8,
          Material.stone => 0.3,
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
  void onTapDown(TapDownEvent event) {
    applyWind(25);
    //affectFriction(0);
  }

  void multiplyGravity(double multiplier) {
    if (!isFoundation) {
      body.gravityScale = Vector2.all(multiplier);
    }
  }

  void affectFriction(double newFriction) {
    if (!isFoundation) {
      body.fixtures.first.friction = newFriction;
    }
  }

  /// positive speed will move the block to the right, negative to the left
  void applyWind(double windSpeed) {
    if (!isFoundation) {
      body.linearVelocity = Vector2(windSpeed, 0);
    }
  }
}
