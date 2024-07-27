import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:symtower/tetromino/block/export.dart';

class Pavement extends BodyComponent {
  Pavement() : super(renderBody: true);

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(Vector2(game.size.x, game.size.y - (2 * tileSize)), Vector2(0, game.size.y - (2 * tileSize)));
    final fixtureDef = FixtureDef(shape, friction: 1);
    final bodyDef = BodyDef(position: Vector2.zero(), userData: this);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
