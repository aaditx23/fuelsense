import 'package:fuelsense/domain/entities/refuel.dart';

abstract class RefuelRepository {
  Future<List<Refuel>> getRefuelsByBikeId(int userBikeId);
  Stream<List<Refuel>> watchRefuelsByBikeId(int userBikeId);
  Future<Refuel?> getRefuelByRemoteId(int remoteId);
  Future<Refuel?> getRefuelByLocalId(int localId);
  Future<List<Refuel>> getRefuelsByType(int userBikeId, String entryType);
  Future<Refuel?> getIncompleteReserveEntry(int userBikeId);
  Future<List<Refuel>> getRefuelsByCycleId(int cycleId);
  Future<int> saveRefuel(Refuel refuel);
  Future<int> updateRefuel(Refuel refuel);
  Future<int> deleteRefuel(Refuel refuel);
  Future<int?> deleteRefuelByRemoteId(int remoteId);
  Future<int?> updateEntryTypeAndCycle(
    int localId,
    String entryType,
    int? cycleId,
  );
}
