import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dthlms/API/ALL_FUTURE_FUNTIONS/all_functions.dart';
import 'package:dthlms/GETXCONTROLLER/getxController.dart';
import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/PACKAGE_DASHBOARD/mobile_pdf_viewer.dart';
import 'package:dthlms/MODEL_CLASS/login_model.dart';
import 'package:dthlms/PC/STUDYMATERIAL/pdfViewer.dart';
import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookListPagePc extends StatefulWidget {
  const BookListPagePc({super.key});

  @override
  State<BookListPagePc> createState() => _BookListPagePcState();
}

class _BookListPagePcState extends State<BookListPagePc>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String pageTitle = 'Study Material';
//  late DthloginUserDetails ob;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getChapterFiles(
          parentId: 0, "Book", getx.selectedPackageId.value.toString());
    });

    DthloginUserDetails obj;

    _tabController = TabController(length: 1, vsync: this);

    _tabController.addListener(() {
      setState(() {
        switch (_tabController.index) {
          case 0:
            pageTitle = 'Study Material';
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // drawer: _buildSideNavigation(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Platform.isAndroid
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back))
            : (getx.isCollapsed.value
                ? IconButton(
                    icon: Icon(Icons.list),
                    onPressed: () {
                      getx.isCollapsed.value = false;
                    })
                : SizedBox()),
        elevation: 0,
        shadowColor: Colors.grey,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          "Study Materials",
          style: FontFamily.styleb,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _buildHeaderRow(),
            _buildTabBar(),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: getx.booklist.length,
                itemBuilder: (context, index) {
                  var book = getx.booklist[index];
                  return book['DocumentPath'] != '0' ||
                          book['DocumentPath'] == null
                      ? HoverListItem(
                          title: book['FileIdName'],
                          bookurl: book,
                          index: index)
                      : SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        controller: _tabController,
        labelColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedLabelColor: Colors.grey,
        indicatorColor: Color.fromARGB(255, 3, 6, 223),
        isScrollable: true, // Makes the TabBar scrollable if needed
        tabs: [
          Tab(text: 'Study Material'),
        ],
      ),
    );
  }
}
class HoverListItem extends StatefulWidget {
  final String title;
  final Map<String, dynamic> bookurl;
  final int index;
  HoverListItem({
    Key? key,
    required this.title,
    required this.bookurl,
    required this.index,
  }) : super(key: key);

  @override
  State<HoverListItem> createState() => _HoverListItemState();
}

class _HoverListItemState extends State<HoverListItem> {
  bool _isHovering = false;

  /// Example: If you have a GetX controller
  final getx = Get.put(Getx());

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _isHovering ? const Color(0xFFE4EAF2) : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Left icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/book_pdf.png',
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Title
            Expanded(
              child: Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Open Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: _isHovering ? const Color(0xFF2F54F8) : const Color(0xFF4A6CF7),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    if (Platform.isAndroid) {
                      Get.to(
                        transition: Transition.cupertino,
                        () => ShowChapterPDFMobile(
                          pdfUrl: widget.bookurl['DocumentPath'],
                          title: widget.bookurl['FileIdName'],
                          folderName: getPackagDataFieldValuebyId(
                            getx.selectedPackageId.toString(),"PackageName"
                          ),
                          isEncrypted: widget.bookurl["IsEncrypted"] == "true" ||
                              widget.bookurl["IsEncrypted"] == "1",
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute( 
                          builder: (context) {
                            return ShowChapterPDF(
                              pdfUrl: widget.bookurl['DocumentPath'],
                              title: widget.bookurl['FileIdName'],
                              folderName: getPackagDataFieldValuebyId(
                                getx.selectedPackageId.toString(),"PackageName"
                              ),
                              isEncrypted: widget.bookurl["IsEncrypted"] == "true" ||
                                  widget.bookurl["IsEncrypted"] == "1",
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: const Text(
                      'Open',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Delete Button
            IconButton(
              onPressed: _deleteFile,
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 20,
              ),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Delete the file from disk and (optionally) update the UI or show a message
  Future<void> _deleteFile() async {
    final filePath = getDownloadedPathOfPDF(
      widget.bookurl['FileIdName'],
      getPackagDataFieldValuebyId(
        getx.selectedPackageId.toString(),"PackageName"
      ),
    );

    ArtDialogResponse? response = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        title: "Delete",
        text: "${widget.bookurl['FileIdName']}",
        showCancelBtn: true,
        confirmButtonColor: Colors.red,
        type: ArtSweetAlertType.warning,
      ),
    );

    if (response == null || !response.isTapConfirmButton) {
      return;
    }

    if (filePath == '' || filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file path provided.')),
      );
      return;
    }

    final file = File(filePath);
    if (await file.exists()) {
      try {
        await file.delete();
        getx.booklist.removeAt(widget.index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File deleted: $filePath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting file: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File not found: $filePath')),
      );
    }
  }
}