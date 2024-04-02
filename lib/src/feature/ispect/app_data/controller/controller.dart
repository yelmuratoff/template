part of '../app_data.dart';

class AppDataController extends ChangeNotifier {
  var _files = <File>[];
  List<File> get files => _files;

  Future<void> loadFilesList() async {
    try {
      final f = await FileService.instance.getFiles();
      _files = f;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } on Exception catch (e, st) {
      talker.handle(e, st);
      await Toaster.showErrorToast(
        navigatorKey.currentContext!,
        title: e.toString(),
      );
    }
  }

  Future<void> deleteFile(int index) async {
    try {
      await _files[index].delete();
      await loadFilesList();
    } on Exception catch (e, st) {
      talker.handle(e, st);
      await Toaster.showErrorToast(
        navigatorKey.currentContext!,
        title: e.toString(),
      );
    }
  }

  Future<void> deleteFiles() async {
    try {
      for (final file in _files) {
        await file.delete();
      }
      await loadFilesList();
    } on Exception catch (e, st) {
      talker.handle(e, st);
      await Toaster.showErrorToast(
        navigatorKey.currentContext!,
        title: e.toString(),
      );
    }
  }
}
