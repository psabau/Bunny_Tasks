import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WeatherMap {
  static Icon mapStringToIcon(
      BuildContext context,
      String input,
      double iconSize,
      ) {
    IconData icon;
    switch (input) {
      case 'Thunderstorm':
        icon = MdiIcons.weatherLightningRainy;
        break;
      case 'Drizzle':
        icon = MdiIcons.weatherPartlyRainy;
        break;
      case 'Rain':
        icon = MdiIcons.weatherRainy;
        break;
      case 'Snow':
        icon = MdiIcons.weatherSnowy;
        break;
      case 'Clear':
        icon = MdiIcons.weatherSunny;
        break;
      case 'Clouds':
        icon = MdiIcons.weatherCloudy;
        break;
      case 'Mist':
        icon = MdiIcons.weatherFog;
        break;
      case 'fog':
        icon = MdiIcons.weatherFog;
        break;
      case 'Smoke':
        icon = MdiIcons.smoke;
        break;
      case 'Haze':
        icon = MdiIcons.weatherHazy;
        break;
      case 'Dust':
      case 'Sand':
      case 'Ash':
        icon = MdiIcons.weatherDust;
        break;
      case 'Squall':
      case 'Tornado':
        icon = MdiIcons.weatherTornado;
        break;
      default:
        icon = MdiIcons.weatherCloudy;
    }
    return Icon(
      icon,
      size: iconSize,
      color: Theme.of(context).primaryColor,
    );
  }
}