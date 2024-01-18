import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatelessWidget {
  Avatar({
    super.key,
    required this.imageUrl,
    required this.onUpload,
  });

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: imageUrl != null
              ? ClipOval(
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Text('No Image'),
                  ),
                ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image == null) {
              return;
            }
            final imageExtension = image.path.split('.').last.toLowerCase();
            final imageBytes = await image.readAsBytes();
            final userId = client.auth.currentUser!.id;
            final imagePath = '/$userId/profile';
            await client.storage.from('profiles').uploadBinary(
                  imagePath,
                  imageBytes,
                  fileOptions: FileOptions(
                    upsert: true,
                    contentType: 'image/$imageExtension',
                  ),
                );
            String imageUrl = client.storage.from('profiles').getPublicUrl(imagePath);
            imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
              't': DateTime.now().millisecondsSinceEpoch.toString()
            }).toString();
            onUpload(imageUrl);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            minimumSize: MaterialStateProperty.all<Size>(const Size(200, 35)),
          ),
          child: const Text('Ganti Foto Profile'),
        ),
      ],
    );
  }
}
