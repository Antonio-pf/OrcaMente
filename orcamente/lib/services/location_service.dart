import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../core/result.dart';
import '../core/exceptions.dart';

/// Service to handle user location and geocoding
class LocationService {
  /// Get current user location with permission handling
  Future<Result<Position>> getCurrentLocation() async {
    print('🌍 [LocationService] Iniciando obtenção de localização...');
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Failure(
          'Serviços de localização estão desabilitados',
          DataException('location-service-disabled'),
        );
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Failure(
            'Permissão de localização negada',
            DataException('location-permission-denied'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Failure(
          'Permissão de localização negada permanentemente. Ative nas configurações.',
          DataException('location-permission-denied-forever'),
        );
      }

      // Get current position
      print('🌍 [LocationService] Obtendo posição GPS...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      print('✅ [LocationService] Posição obtida: ${position.latitude}, ${position.longitude}');
      return Success(position);
    } catch (e) {
      print('❌ [LocationService] Erro ao obter localização: $e');
      return Failure(
        'Erro ao obter localização: $e',
        DataException('location-error'),
      );
    }
  }

  /// Get location details (city, state, country) from coordinates
  Future<Result<LocationDetails>> getLocationDetails(
    double latitude,
    double longitude,
  ) async {
    print('🗺️ [LocationService] Buscando detalhes da localização para: $latitude, $longitude');
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        // Return default Brazilian location if geocoding fails
        return Success(LocationDetails(
          city: 'São Paulo',
          state: 'SP',
          country: 'Brasil',
          countryCode: 'BR',
        ));
      }

      final place = placemarks.first;
      
      // Handle null values with defaults
      final city = place.locality ?? 
                   place.subAdministrativeArea ?? 
                   place.administrativeArea ?? 
                   'São Paulo';
      
      final state = place.administrativeArea ?? 'SP';
      final country = place.country ?? 'Brasil';
      final countryCode = place.isoCountryCode ?? 'BR';
      
      final details = LocationDetails(
        city: city,
        state: state,
        country: country,
        countryCode: countryCode,
      );

      print('✅ [LocationService] Detalhes obtidos: $city, $state - $country');
      return Success(details);
    } catch (e) {
      print('⚠️ [LocationService] Erro ao obter detalhes, usando fallback: $e');
      // Return default Brazilian location on error (useful for web)
      return Success(LocationDetails(
        city: 'São Paulo',
        state: 'SP',
        country: 'Brasil',
        countryCode: 'BR',
      ));
    }
  }

  /// Get full location info (position + details)
  Future<Result<UserLocation>> getUserLocation() async {
    final positionResult = await getCurrentLocation();

    return await positionResult.when(
      success: (position) async {
        final detailsResult = await getLocationDetails(
          position.latitude,
          position.longitude,
        );

        return detailsResult.when(
          success: (details) => Success(
            UserLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              details: details,
            ),
          ),
          failure: (error, exception) => Failure(error, exception),
        );
      },
      failure: (error, exception) => Failure(error, exception),
    );
  }
}

/// Location details model
class LocationDetails {
  final String city;
  final String state;
  final String country;
  final String countryCode;

  const LocationDetails({
    required this.city,
    required this.state,
    required this.country,
    required this.countryCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'state': state,
      'country': country,
      'countryCode': countryCode,
    };
  }

  factory LocationDetails.fromMap(Map<String, dynamic> map) {
    return LocationDetails(
      city: map['city'] as String? ?? 'Desconhecida',
      state: map['state'] as String? ?? 'Desconhecido',
      country: map['country'] as String? ?? 'Desconhecido',
      countryCode: map['countryCode'] as String? ?? 'BR',
    );
  }

  @override
  String toString() => '$city, $state - $country';
}

/// Complete user location with coordinates and details
class UserLocation {
  final double latitude;
  final double longitude;
  final LocationDetails details;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'details': details.toMap(),
    };
  }

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      details: LocationDetails.fromMap(
        map['details'] as Map<String, dynamic>,
      ),
    );
  }
}
