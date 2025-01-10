import 'package:dthlms/THEME_DATA/color/color.dart';
import 'package:dthlms/THEME_DATA/font/font_family.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ClaenderWidget extends StatefulWidget {
  const ClaenderWidget({super.key});

  @override
  State<ClaenderWidget> createState() => _ClaenderWidgetState();
}

class _ClaenderWidgetState extends State<ClaenderWidget> {
  @override
  Widget build(BuildContext context) {
 
  return  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal:  20 ,vertical: 15),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorPage.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 3,
                            color: Color.fromARGB(255, 192, 191, 191),
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: SfCalendar(
                      cellBorderColor:ColorPage.colorblack ,
                    
                      viewHeaderHeight: 50,
                      viewHeaderStyle: ViewHeaderStyle(dayTextStyle:FontFamily.font6 ),

                      // allowDragAndDrop: false,
                      // allowViewNavigation: true,
                      backgroundColor: Color.fromARGB(255, 243, 245, 251),
                      headerStyle: CalendarHeaderStyle(
                          backgroundColor: ColorPage.blue,
                          textAlign: TextAlign.center,
                          textStyle: FontFamily.font3),
                      // showTodayButton: true,
                      view: CalendarView.month,
                      monthViewSettings: MonthViewSettings(
                        // agendaItemHeight: 20,
                        agendaViewHeight: 120,
                        agendaStyle: AgendaStyle(
                            dateTextStyle: FontFamily.font3.copyWith(color: ColorPage.appbarcolor),
                            placeholderTextStyle: TextStyle(color: Colors.red)),
                        showAgenda: true,
                      ),
                    ),
                  ));
}
  }
