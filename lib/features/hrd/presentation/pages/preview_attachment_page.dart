import 'package:akib_pos/common/app_text_styles.dart';
import 'package:akib_pos/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class PreviewAttachmentPage extends StatefulWidget {
  final String url;

  const PreviewAttachmentPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _PreviewAttachmentPageState createState() => _PreviewAttachmentPageState();
}

class _PreviewAttachmentPageState extends State<PreviewAttachmentPage> {
  late String imageUrl;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.url;
  }

  void _retryLoading() {
    setState(() {
      isLoading = true;
      isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text('Lampiran', style: AppTextStyle.headline5),
      ),
      body: Center(
        child: isError
            ?  Container(
              color: Colors.white,
              padding: EdgeInsets.only(bottom: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Utils.buildErrorStatePlain(title: "Gagal Memuat Gambar", message: "", onRetry: () {
                    _retryLoading();
                  },),
                ],
              ),
            )
            : PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                loadingBuilder: (context, event) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: event == null
                          ? null
                          : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  // Schedule the `setState()` call to be made after the build cycle is complete
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        isError = true;
                      });
                    }
                  });
                  return const SizedBox();
                },
              ),
      ),
    );
  }
}