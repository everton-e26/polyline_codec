import 'package:flutter_test/flutter_test.dart';
import 'package:polyline_codec/polyline_codec.dart';

void main() {
  test('encode to ??', () {
    const coordinates = [
      [0, 0]
    ];
    final expectedPolyline = '??';

    final polyline = PolylineCodec.encode(coordinates);
    expect(polyline, expectedPolyline);
    expect(PolylineCodec.decode(polyline), coordinates);
  });

  test("encode decode", () {
    const coordinates = [
      [-179.9832104, 0]
    ];
    final expectedPolyline = '`~oia@?';
    final polyline = PolylineCodec.encode(coordinates);
    expect(polyline, expectedPolyline);
    expect(PolylineCodec.decode(polyline), [
      [-179.98321, 0]
    ]);
  });
}
