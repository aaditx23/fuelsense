import 'package:fuelsense/data/datasources/local/dao/refuel_dao.dart';
import 'package:fuelsense/domain/entities/refuel.dart';
import 'package:fuelsense/domain/repositories/refuel_repository.dart';

class RefuelRepositoryImpl implements RefuelRepository {
  final RefuelDao _refuelDao;

  RefuelRepositoryImpl(this._refuelDao);

  @override
  Future<List<Refuel>> getRefuelsByBikeId(int userBikeId) async {
    final entities = await _refuelDao.findAllByUserBikeId(userBikeId);
    return entities.map((entity) => Refuel.fromEntity(entity)).toList();
  }

  @override
  Stream<List<Refuel>> watchRefuelsByBikeId(int userBikeId) {
    return _refuelDao
        .watchAllByUserBikeId(userBikeId)
        .map(
          (entities) =>
              entities.map((entity) => Refuel.fromEntity(entity)).toList(),
        );
  }

  @override
  Future<Refuel?> getRefuelByRemoteId(int remoteId) async {
    final entity = await _refuelDao.findByRemoteId(remoteId);
    return entity != null ? Refuel.fromEntity(entity) : null;
  }

  @override
  Future<Refuel?> getRefuelByLocalId(int localId) async {
    final entity = await _refuelDao.findByLocalId(localId);
    return entity != null ? Refuel.fromEntity(entity) : null;
  }

  @override
  Future<List<Refuel>> getRefuelsByType(
    int userBikeId,
    String entryType,
  ) async {
    final entities = await _refuelDao.findByUserBikeIdAndEntryType(
      userBikeId,
      entryType,
    );
    return entities.map((entity) => Refuel.fromEntity(entity)).toList();
  }

  @override
  Future<Refuel?> getIncompleteReserveEntry(int userBikeId) async {
    final entity = await _refuelDao.findIncompleteReserveEntry(userBikeId);
    return entity != null ? Refuel.fromEntity(entity) : null;
  }

  @override
  Future<List<Refuel>> getRefuelsByCycleId(int cycleId) async {
    final entities = await _refuelDao.findByReserveCycleId(cycleId);
    return entities.map((entity) => Refuel.fromEntity(entity)).toList();
  }

  @override
  Future<int> saveRefuel(Refuel refuel) async {
    return await _refuelDao.insertRefuel(refuel.toEntity());
  }

  @override
  Future<int> updateRefuel(Refuel refuel) async {
    return await _refuelDao.updateRefuel(refuel.toEntity());
  }

  @override
  Future<int> deleteRefuel(Refuel refuel) async {
    return await _refuelDao.deleteRefuel(refuel.toEntity());
  }

  @override
  Future<int?> deleteRefuelByRemoteId(int remoteId) async {
    return await _refuelDao.deleteByRemoteId(remoteId);
  }

  @override
  Future<int?> updateEntryTypeAndCycle(
    int localId,
    String entryType,
    int? cycleId,
  ) async {
    if (cycleId != null) {
      return await _refuelDao.updateEntryTypeAndCycle(
        localId,
        entryType,
        cycleId,
      );
    } else {
      return await _refuelDao.updateEntryTypeAndClearCycle(localId, entryType);
    }
  }
}
