import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/domain/usecases/refuel_usecases.dart';
import 'package:fuelsense/domain/repositories/refuel_repository.dart';
import 'package:fuelsense/di/setup_di.dart';

// StreamProvider to watch all refuels for a bike with real-time DB updates
final refuelListStreamProvider = StreamProvider.family<List<Refuel>, int>((
  ref,
  userBikeId,
) {
  final repository = getIt<RefuelRepository>();
  // Use the repository's watch method for real-time updates
  return repository.watchRefuelsByBikeId(userBikeId);
});

// Provider for delete use case
final deleteRefuelUseCaseProvider = Provider<DeleteRefuelUseCase>((ref) {
  return getIt<DeleteRefuelUseCase>();
});
