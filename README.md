# polyline_codec

## Getting started

You should ensure that you add the polyline_codec as a dependency in your project.

read more at [how to install](https://pub.dev/packages/polyline_codec#-installing-tab-)

## Usage

```dart

const coordinates = [
      [-179.9832104, 0]
    ];

final polyline = PolylineCodec.encode(coordinates);

print(polyline); //'`~oia@?'

```

based on https://github.com/mapbox/polyline
