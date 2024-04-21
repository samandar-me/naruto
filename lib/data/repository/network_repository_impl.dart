import 'package:flutter_application_1/data/network/anime_service.dart';
import 'package:flutter_application_1/domain/map/map.dart';
import 'package:flutter_application_1/domain/model/anime.dart';
import 'package:flutter_application_1/domain/repository/network_repository.dart';
import 'package:flutter_application_1/util/constants.dart';

class NetworkRepositoryImpl extends NetworkRepository {

  final _service = AnimeService(buildDioClient(Constants.baseUrl));

  @override
  Future<List<Anime>> getAnimeList() async {
   try {
     final response = await _service.getAnimeList();
     final List<Anime> animeList = response.data?.map((e) => e.toAnime()).toList() ?? [];
     return animeList;
   } catch(e) {
     return [];
   }
  }
}