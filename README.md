# File Picker Widget for Flutter

A simple and customizable file picker widget for Flutter, allowing users to pick files from their device or web application. This package supports multi-file picking, file type filtering, and file compression options.

# Important Notes for Project Setup

1. **Update Gradle Version:**
    - Navigate to the `android` folder inside the project directory:
      ```bash
      cd android
      ```
    - Run the following command to set the Gradle version to 8.5:
      ```bash
      ./gradlew wrapper --gradle-version=8.5
      ```

2. **Modify Android Settings:**
    - Open the `android/settings.gradle` file.
    - Locate the following line:
      ```gradle
      id "com.android.application" version "8.1.0" apply false
      ```
    - Update it to:
      ```gradle
      id "com.android.application" version "8.2.1" apply false
      ```

3. **Set Java Version:**
    - Ensure the system's Java version is `JDK 17`.
    - The `JAVA_HOME` environment variable must be set to the JDK installation path.
        - On macOS/Linux, add the following line to your `~/.bashrc` or `~/.zshrc`:
          ```bash
          export JAVA_HOME=/path/to/jdk17
          export PATH=$JAVA_HOME/bin:$PATH
          ```
        - On Windows, set `JAVA_HOME` in the Environment Variables through System Properties.

---

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

```sh
flutter pub add file_picker
```

Then run:

```sh
flutter pub get
```

## Usage

To use the `FilePickerWidget` in your Flutter app, follow these steps:

1. **Import the necessary packages:**

```dart
import 'package:flutter/material.dart';
import 'package:file_uploader_package/file_uploader_package.dart';

```

2. **Create the `FilePickerWidget` widget in your widget tree:**

```dart
void main() {
  runApp(MaterialApp(
    home: FilePickerWidget(),
  ));
}
```
3. **Here is the code for the FilePickerWidget() widget but u don't have to write this code:**

```dart
class FilePickerWidget extends StatefulWidget{
   const FilePickerWidget({super.key});
   @override
   State<StatefulWidget> createState() {
      // TODO: implement createState
      return _FilePickerWidgetState();
   }
}

class _FilePickerWidgetState extends State<FilePickerWidget>{

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