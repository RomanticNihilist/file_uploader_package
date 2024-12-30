# File Picker Widget for Flutter

A simple and customizable file picker widget for Flutter, allowing users to pick files from their device or web application. This package supports multi-file picking, file type filtering, and file compression options.

## Features

- **File Picker:** Allows users to select files from their device.
- **Multi-file Support:** Pick multiple files at once.
- **File Type Filtering:** Customize file types that can be picked (e.g., images, videos, etc.).
- **Compression Support:** Allows you to set compression quality for picked files (e.g., 30% compression).
- **Web Support:** Works on web with necessary fallbacks for file paths.
- **Error Handling:** Includes error handling and displays helpful messages if something goes wrong.
- **Customizable:** Easily modifiable for different use cases.

## Installation

Add the dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  file_uploader_package:
    git:
      url: https://github.com/RomanticNihilist/file_uploader_package
  flutter:
    sdk: flutter
  file_picker: ^5.2.1 # Check for the latest version on pub.dev
```

Alternatively, you can add it via the command line:

```bash
flutter pub add file_picker
```

## Usage

To use the `FilePickerWidget` in your Flutter app, follow these steps:

1. **Import the necessary packages:**

```dart
import 'package:file_picker/file_picker.dart';

```

2. **Create the `FilePickerWidget` widget in your widget tree:**

```dart
void main() {
  runApp(MaterialApp(
    home: FilePickerWidget(),
  ));
}

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilePickerWidgetState();
  }
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
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
```

### Widget Breakdown

1. **`FilePickerWidget`**: The main widget that displays a button to trigger the file picking process and lists the selected files.
2. **`_pickFiles`**: Function that handles the file picking logic using the `FilePicker` library.
3. **`_logException`**: Displays error messages in a snack bar if something goes wrong during the file picking process.
4. **`_resetState`**: Resets the state of the widget (file name and path) when picking new files.
5. **UI Layout**: A simple `ListView` shows the picked files, and a floating action button is used to trigger the file picker.

### Customization

You can customize the following properties:

- **`_multiPick`**: Set to `true` to allow multiple file selections or `false` to allow single file selection.
- **`_pickingType`**: Choose the type of files allowed for picking (`FileType.any`, `FileType.image`, etc.).
- **`_extension`**: Filter files by extension (e.g., `['jpg', 'png']`).
- **`compressionQuality`**: Adjust file compression quality (default is `30`).

## Example Use Case

This widget is great for any application that requires file uploads, such as:

- File upload forms
- Image and document picker
- Web file selection for a web-based Flutter app

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

This `README.md` covers the installation, usage, customization, and features of your file picker widget for Flutter.