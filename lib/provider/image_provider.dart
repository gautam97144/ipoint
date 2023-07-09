import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/model/profile_picture_model.dart';

class ImageProfile extends ChangeNotifier {
  ProfilePictureModel? profilePictureModel;
  ProfilePictureModel? get GetProfilePictureModel => profilePictureModel;
  void setimagemodel(ProfilePictureModel model) {
    profilePictureModel = model;
    notifyListeners();
  }
}
