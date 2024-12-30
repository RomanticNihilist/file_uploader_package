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
    return _FilePickerWidgetState();
  }
}

class _FilePickerWidgetState extends State<FilePickerWidget>{

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _extension;
  final bool _multiPick = true;
  final FileType _pickingType = FileType.any;

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
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

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
    });
  }

  void _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scrollbar(
          child: ListView.separated(
            itemCount: _paths?.length ?? 1,
            itemBuilder: (BuildContext context, int index) {
              if (_paths == null || _paths!.isEmpty) {
                return const ListTile(
                  title: Text('No files selected'),
                );
              }

              final isMultiPath = _paths!.isNotEmpty;
              final String name = 'File $index: ${isMultiPath ? _paths![index].name : _fileName ?? '...'}';
              final path = kIsWeb ? null : _paths![index].path;

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
        onPressed: _pickFiles,
        icon: const Icon(Icons.add),
        label: const Text("Add Files"),
      ),
    );
  }
}
