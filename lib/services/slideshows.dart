import 'package:admin_dashboard/models/slideshows.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class SlideshowService {
  String slideshowCollection = "slideshows";

  Future<List<SlideshowModel>> getAllSlideshows() async =>
      firebaseFiretore.collection(slideshowCollection).get().then((result) {
        List<SlideshowModel> slideshows = [];
        for (DocumentSnapshot slideshow in result.docs) {
          slideshows.add(SlideshowModel.fromSnapshot(slideshow));
        }
        return slideshows;
      });

  Future<bool> addSlideshow(Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(slideshowCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> updateSlideshow(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(slideshowCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteSlideshow(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(slideshowCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
