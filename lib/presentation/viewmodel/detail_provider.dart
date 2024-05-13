import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/data/repository/local_repository_impl.dart';
import 'package:flutter_application_1/domain/model/anime.dart';
import 'package:flutter_application_1/domain/model/anime_db.dart';
import 'package:flutter_application_1/domain/repository/local_repository.dart';
import 'package:http/http.dart' as http;

class DetailProvider extends ChangeNotifier {
  final LocalRepository _localRepository = LocalRepositoryImpl();
  bool isSaved = false;
  Uint8List? _uInt8list;

  void checkSavedOrNot(int id) async {
    final anime = await _localRepository.findAnimeById(id);
    isSaved = anime != null;
    notifyListeners();
  }
  void saveOrDelete(Anime anime) async {
    _uInt8list = await linkToByteArray(anime.image ?? ""); // image error has been fixed
    final s = anime.nicknames?.isEmpty == true ? "" : anime.nicknames?[0];
    final localAnime = AnimeDb(
      id: null,
      animeId: anime.malId,
      name: anime.name,
      nameKanji: anime.nameKanji,
      nickName: s,
      about: anime.about,
      imageData: _uInt8list
    );
    if(isSaved) {
      await _localRepository.deleteFavoriteAnime(localAnime);
      isSaved = false;
    } else {
      await _localRepository.saveFavoriteAnime(localAnime);
      isSaved = true;
    }
    notifyListeners();
  }
  Future<Uint8List?> linkToByteArray(String image) async {
    final response = await http.get(Uri.parse(image));

    if(response.statusCode == 200) {
      return response.bodyBytes;
    }
    return null;
  }
}
