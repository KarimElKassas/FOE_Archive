import 'package:dartz/dartz.dart';
import 'package:foe_archive/data/models/letter_model.dart';
import 'package:hive/hive.dart';

import '../../../core/error/error_messages.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/base_use_case.dart';

abstract class BaseLetterLocalDataSource {
  Future<Unit> addIncomingExternalLettersToCache(List<LetterModel> chatsList);
  Future<Unit> addOutgoingExternalLettersToCache(List<LetterModel> chatsList);
  Future<Unit> addIncomingInternalLettersToCache(List<LetterModel> chatsList);
  Future<Unit> addOutgoingInternalLettersToCache(List<LetterModel> chatsList);
  Future<Unit> addArchivedLettersToCache(List<LetterModel> chatsList);
  Future<Unit> addForMeLettersToCache(List<LetterModel> chatsList);
  Future<List<LetterModel>> getIncomingInternalLetters(NoParameters parameters);
  Future<List<LetterModel>> getIncomingExternalLetters(NoParameters parameters);
  Future<List<LetterModel>> getOutgoingInternalLetters(NoParameters parameters);
  Future<List<LetterModel>> getOutgoingExternalLetters(NoParameters parameters);
  Future<List<LetterModel>> getArchivedLetters(NoParameters parameters);
  Future<List<LetterModel>> getForMeLetters(NoParameters parameters);
}

class LetterLocalDataSource implements BaseLetterLocalDataSource {
  @override
  Future<List<LetterModel>> getIncomingInternalLetters(NoParameters parameters) async {
    var chatsBox = Hive.box("IncomingInternalLetters");
    var hiveList = chatsBox.get("lettersList");
    if(hiveList == null){
      throw const EmptyCacheFailure(emptyCacheData);
    }else{
      var finalList = List<LetterModel>.from((chatsBox.get("lettersList") as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
      return finalList;
    }
  }
  @override
  Future<List<LetterModel>> getIncomingExternalLetters(NoParameters parameters) async {
    var chatsBox = Hive.box("IncomingExternalLetters");
    var hiveList = chatsBox.get("lettersList");
    if(hiveList == null){
      throw const EmptyCacheFailure(emptyCacheData);
    }else{
      var finalList = List<LetterModel>.from((chatsBox.get("lettersList") as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
      return finalList;
    }
  }
  @override
  Future<List<LetterModel>> getOutgoingInternalLetters(NoParameters parameters) async {
    var chatsBox = Hive.box("OutgoingInternalLetters");
    var hiveList = chatsBox.get("lettersList");
    if(hiveList == null){
      throw const EmptyCacheFailure(emptyCacheData);
    }else{
      var finalList = List<LetterModel>.from((chatsBox.get("lettersList") as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
      return finalList;
    }
  }
  @override
  Future<List<LetterModel>> getOutgoingExternalLetters(NoParameters parameters) async {
    var chatsBox = Hive.box("OutgoingExternalLetters");
    var hiveList = chatsBox.get("lettersList");
    if(hiveList == null){
      throw const EmptyCacheFailure(emptyCacheData);
    }else{
      var finalList = List<LetterModel>.from((chatsBox.get("lettersList") as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
      return finalList;
    }
  }
  @override
  Future<List<LetterModel>> getArchivedLetters(NoParameters parameters) async {
    var chatsBox = Hive.box("ArchivedLetters");
    var hiveList = chatsBox.get("lettersList");
    if(hiveList == null){
      throw const EmptyCacheFailure(emptyCacheData);
    }else{
      var finalList = List<LetterModel>.from((chatsBox.get("lettersList") as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
      return finalList;
    }
  }
  @override
  Future<List<LetterModel>> getForMeLetters(NoParameters parameters) async {
    var chatsBox = Hive.box("ForMeLetters");
    var hiveList = chatsBox.get("lettersList");
    if(hiveList == null){
      throw const EmptyCacheFailure(emptyCacheData);
    }else{
      var finalList = List<LetterModel>.from((chatsBox.get("lettersList") as List<dynamic>).map((e) => LetterModel.fromJson((e as LetterModel).toJson())));
      return finalList;
    }
  }

  @override
  Future<Unit> addIncomingInternalLettersToCache(List<LetterModel> letterList) async {
    var chatsBox = Hive.box("IncomingInternalLetters");
    try{
      await chatsBox.put("lettersList",letterList);
      return Future.value(unit);
    }catch (ex){
      throw LocalDatabaseFailure(ex.toString());
    }
  }
  @override
  Future<Unit> addIncomingExternalLettersToCache(List<LetterModel> letterList) async {
    var chatsBox = Hive.box("IncomingExternalLetters");
    try{
      await chatsBox.put("lettersList",letterList);
      return Future.value(unit);
    }catch (ex){
      throw LocalDatabaseFailure(ex.toString());
    }
  }
  @override
  Future<Unit> addOutgoingInternalLettersToCache(List<LetterModel> letterList) async {
    var chatsBox = Hive.box("OutgoingInternalLetters");
    try{
      await chatsBox.put("lettersList",letterList);
      return Future.value(unit);
    }catch (ex){
      throw LocalDatabaseFailure(ex.toString());
    }
  }
  @override
  Future<Unit> addOutgoingExternalLettersToCache(List<LetterModel> letterList) async {
    var chatsBox = Hive.box("OutgoingExternalLetters");
    try{
      await chatsBox.put("lettersList",letterList);
      return Future.value(unit);
    }catch (ex){
      throw LocalDatabaseFailure(ex.toString());
    }
  }
  @override
  Future<Unit> addArchivedLettersToCache(List<LetterModel> letterList) async {
    var chatsBox = Hive.box("ArchivedLetters");
    try{
      await chatsBox.put("lettersList",letterList);
      return Future.value(unit);
    }catch (ex){
      throw LocalDatabaseFailure(ex.toString());
    }
  }
  @override
  Future<Unit> addForMeLettersToCache(List<LetterModel> letterList) async {
    var chatsBox = Hive.box("ForMeLetters");
    try{
      await chatsBox.put("lettersList",letterList);
      return Future.value(unit);
    }catch (ex){
      throw LocalDatabaseFailure(ex.toString());
    }
  }
}