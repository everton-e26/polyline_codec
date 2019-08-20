import 'dart:convert';
import 'dart:math' as math;
import 'package:fixnum/fixnum.dart';

class PolylineCodec {
  PolylineCodec._();

  static int _py2Round(num value) {
    return (value.abs() + 0.5).floor() * (value >= 0 ? 1 : -1);
  }

  static _encode(num current, num previous, num factor) {
    current = _py2Round(current * factor);
    previous = _py2Round(previous * factor);
    Int32 coordinate = Int32(current) - Int32(previous);
    coordinate <<= 1;
    if (current - previous < 0) {
      coordinate = ~coordinate;
    }
    var output = "";
    while (coordinate >= Int32(0x20)) {
      try {
        var v = (Int32(0x20) | (coordinate & Int32(0x1f))) + 63;
        output += String.fromCharCodes([v.toInt()]);
      } catch (err) {
        print(err);
      }
      coordinate >>= 5;
    }
    output += ascii.decode([coordinate.toInt() + 63]);
    return output;
  }

  static List<List<num>> decode(String str, {int precision: 5}) {
    final List<List<num>> coordinates = [];

    var index = 0,
        lat = 0,
        lng = 0,
        shift = 0,
        result = 0,
        byte,
        latitudeChange,
        longitudeChange,
        factor = math.pow(10, precision);

    // Coordinates have variable length when encoded, so just keep
    // track of whether we've hit the end of the string. In each
    // loop iteration, a single coordinate is decoded.
    while (index < str.length) {
      // Reset shift, result, and byte
      byte = null;
      shift = 0;
      result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);

      latitudeChange =
          ((result != 0 & 1) ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();

      shift = result = 0;

      do {
        byte = str.codeUnitAt(index++) - 63;
        result |= ((Int32(byte) & Int32(0x1f)) << shift).toInt();
        shift += 5;
      } while (byte >= 0x20);

      longitudeChange =
          ((result != 0 & 1) ? ~(Int32(result) >> 1) : (Int32(result) >> 1))
              .toInt();

      lat += latitudeChange;
      lng += longitudeChange;

      coordinates.add([lat / factor, lng / factor]);
    }

    return coordinates;
  }

  static encode(List<List<num>> coordinates, {int precision: 5}) {
    if (coordinates.length == 0) {
      return "";
    }

    var factor = math.pow(10, precision),
        output = _encode(coordinates[0][0], 0, factor) +
            _encode(coordinates[0][1], 0, factor);

    for (var i = 1; i < coordinates.length; i++) {
      var a = coordinates[i], b = coordinates[i - 1];
      output += _encode(a[0], b[0], factor);
      output += _encode(a[1], b[1], factor);
    }

    return output;
  }
}
