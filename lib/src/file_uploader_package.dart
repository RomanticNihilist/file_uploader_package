import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

void main(){
  runApp(MaterialApp(
    home: FilePickerWidget(),
  )
  );
}

class FilePickerWidget extends StatefulWidget{
  const FilePickerWidget({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FilePickerWidgetState();
  }
}

class FilePickerWidgetState extends State<FilePickerWidget>{

  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? fileName;
  List<PlatformFile>? paths;
  String? extension;
  final bool multiPick = true;
  final FileType pickingType = FileType.any;

  void logException(String message) {
    print(message);
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      fileName = null;
      paths = null;
    });
  }

  void pickFiles() async {
    resetState();
    try {
      paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: pickingType,
        allowMultiple: multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (extension?.isNotEmpty ?? false)
            ? extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      logException('Unsupported operation$e');
    } catch (e) {
      logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      fileName =
      paths != null ? paths!.map((e) => e.name).toString() : '...';
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scrollbar(
          child: ListView.separated(
            itemCount: paths?.length ?? 1,
            itemBuilder: (BuildContext context, int index) {
              if (paths == null || paths!.isEmpty) {
                return const ListTile(
                  title: Text('No files selected'),
                );
              }

              final isMultiPath = paths!.isNotEmpty;
              final String name = 'File $index: ${isMultiPath ? paths![index].name : fileName ?? '...'}';
              final path = kIsWeb ? null : paths![index].path;

              return ListTile(
                title: Text(name),
                subtitle: Text(path ?? ''),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickFiles,
        icon: const Icon(Icons.add),
        label: const Text("Add Files"),
      ),
    );
  }
}
