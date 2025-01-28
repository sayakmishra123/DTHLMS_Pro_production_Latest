import 'package:dthlms/LOCAL_DATABASE/dbfunction/dbfunction.dart';
import 'package:dthlms/MOBILE/MCQ/mcqpaperdetailsmobile_page.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class McqListMobile extends StatefulWidget {
  final RxList mcqSetList;
  final String type;
  final String img;
  final bool istype;
  McqListMobile(this.mcqSetList, this.type, this.img, this.istype, {super.key});

  @override
  State<McqListMobile> createState() => _McqListMobileState();
}

class _McqListMobileState extends State<McqListMobile> { 
  RxList filteredList = [].obs;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
 
    // Filter the list based on the type
    filteredList.value = widget.mcqSetList
        .where((item) => item["ServicesTypeName"] == widget.type)
        .toList();

    return SizedBox(
      height: screenHeight * 0.8, // Responsive to screen height 
      child: Column(
        children: [
          if (filteredList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final mcqItem = filteredList[index];
                  return McqListItem(
                    name: mcqItem["SetName"] ?? 'No name found',
                    // date: mcqItem["StartDate"] ?? 'No date found',
                    mcqItem: mcqItem,
                    mcqSetList: widget.mcqSetList,
                    istype: widget.istype,
                  );
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: const Text(
                  "No Quick Practice Papers Found",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class McqListItem extends StatefulWidget {
  final String name;
  // final String date;
  final dynamic mcqItem;
  final RxList mcqSetList;
  final bool istype;

  const McqListItem({
    super.key,
    required this.name,
    // required this.date,
    required this.mcqItem,
    required this.mcqSetList,
    required this.istype,
  });

  @override
  State<McqListItem> createState() => _McqListItemState();
}

class _McqListItemState extends State<McqListItem> {
  List mcqPaperList = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    mcqPaperList = await fetchMCQPapertList(widget.mcqItem['SetId']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => McqPaperDetailsMobile(
              widget.mcqItem,
              widget.mcqSetList,
              widget.istype,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
        padding: const EdgeInsets.all(10),
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 244, 214),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                      width: 40,
                      child: Image(
                        image: AssetImage('assets/exam_icon.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FontFamily.styleb
                        .copyWith(color: Colors.black, fontSize: 18),
                  ),

                  // Text(widget.date,
                  //   style: FontFamily.style
                  //       .copyWith(color: Colors.black45, fontSize: 16),
                  // ),

                ],
              ),
            ),
            SizedBox(
              width: 40, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 14,
                    child: Text(mcqPaperList.length.toString()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
