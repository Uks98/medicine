import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine/components/constant.dart';
import 'package:medicine/components/page_route.dart';
import 'package:medicine/components/widgets.dart';
import 'package:medicine/pages/add/add_alarm_page.dart';

import 'add_page_widget.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _textEditingController = TextEditingController();
  File? _medicineImage;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: AddPageBody(children:[
                  Text(
                    "어떤 약이에요?",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: largeSpace,
                  ),
                  Center(child: _MedicineImageButton(
                    changeImageFile: (File? value) {
                      _medicineImage = value;
                    },
                  )),
                  const SizedBox(
                    height: largeSpace + regularSpace,
                  ),
                  Text(
                    "약 이름",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  TextFormField(
                    controller: _textEditingController,
                    maxLength: 20,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintText: "복용할 약 이름을 기입해주세요",
                      hintStyle: Theme.of(context).textTheme.bodyText2,
                      contentPadding: textFieldContentPadding,
                    ),
                   onChanged: (_) {
                     setState(() {});
                   },
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomSubmitButton(text: '다음', onPressed:
        _textEditingController.text.isEmpty ? null : _onAddAlarmPage)
    );
  }

  _onAddAlarmPage() {
    Navigator.push(
      context,
      FadePageRoute(
        page: AddAlarmPage(
            medicineImage: _medicineImage,
            medicineName: _textEditingController.text),
      ),
    );
  }
}



class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({Key? key, required this.changeImageFile})
      : super(key: key);
  final ValueChanged<File?> changeImageFile;

  @override
  _MedicineImageButtonState createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
          padding: _pickedImage == null ? null : EdgeInsets.zero,
          onPressed: _showBottomSheet,
          child: _pickedImage == null
              ? const Icon(
                  CupertinoIcons.photo_camera_solid,
                  color: Colors.white,
                )
              : CircleAvatar(
                  radius: 40,
                  foregroundImage: FileImage(_pickedImage!),
                )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PickImageBottomSheet(
            onPressedCamera: () => onPressed(ImageSource.camera),
            onPressedGallery: () => onPressed(ImageSource.gallery));
      },
    );
  }

  void onPressed(ImageSource imageSource) {
    ImagePicker().pickImage(source: imageSource).then((xfile) {
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);
          widget.changeImageFile(_pickedImage);
        });
      }
      Navigator.of(context).maybePop();
    }).onError((error, stackTrace){
      ///설정창으로 이동
      Navigator.of(context).pop();
      showPermissionDenied(context,permission: "카메라 및 갤러리 전환");
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet(
      {Key? key, required this.onPressedCamera, required this.onPressedGallery})
      : super(key: key);
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
      return BottomSheetBody(children:[
            TextButton(
                onPressed: onPressedCamera, child: const Text("카메라로 촬영")),
            TextButton(
                onPressed: onPressedGallery, child: const Text("앨범에서 가져오기")),
          ],
    );
  }
}
