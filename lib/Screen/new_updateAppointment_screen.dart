import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipoint/Screen/copy_link_screen.dart';
import 'package:ipoint/Screen/selected_date_screen.dart';
import 'package:ipoint/Screen/services_page.dart';
import 'package:ipoint/global/custom_text_style.dart';
import 'package:ipoint/global/images.dart';

class NewUpdateAppointment extends StatefulWidget {
  const NewUpdateAppointment({Key? key}) : super(key: key);

  @override
  _NewUpdateAppointmentState createState() => _NewUpdateAppointmentState();
}

class _NewUpdateAppointmentState extends State<NewUpdateAppointment> {
  var _selectedIndex;
  bool value = false;

  List _imgList = [
    Images.carImage,
    Images.carImage,
    Images.carImage,
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> _list = [
      Car(),
      SizedBox(
        width: 20,
      ),
      Car(),
    ];
    var Height = MediaQuery.of(context).size.height;
    var Width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "<Back",
                        style: CustomTheme.body3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Jane Doe',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Container(
                      height: Height / 17,
                      width: Width / 3,
                      decoration: BoxDecoration(
                        color: CustomTheme.primarycolor,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "30,560",
                            style: CustomTheme.subtitle,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 14),
                            child: Text(
                              "pts",
                              style: CustomTheme.body1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CircleAvatar(
                        //child: Text(),
                        radius: 35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wong Che Lai Car Care",
                          style: CustomTheme.body3,
                        ),
                        SizedBox(height: 5),
                        Row(children: [
                          RichText(
                            text: TextSpan(
                                text: '10km',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                                children: [
                                  TextSpan(
                                    text: 'away',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            Images.mapIcon,
                            scale: 3,
                          )
                        ]),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: Height / 15,
                      width: Width / 8,
                      decoration: BoxDecoration(
                          color: CustomTheme.primarycolor,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2.9,
                              spreadRadius: 1.0,
                              offset: Offset(4.0, 4.0),
                            ),
                          ]),
                      child: Image.asset(
                        Images.showroomIcon,
                        scale: 3,
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Container(
                      height: Height / 20,
                      width: Width / 10,
                      decoration: BoxDecoration(
                          color: CustomTheme.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(
                        Icons.favorite_border,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Stack(children: [
                      Image.asset(Images.newUpdate, scale: 2.5),
                      Positioned(
                          // left: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 8,
                            ),
                          ))
                    ]),
                    SizedBox(width: 7),
                    Stack(children: [
                      Image.asset(Images.newUpdate, scale: 2.5),
                      Positioned(
                          // left: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                              size: 8,
                            ),
                          ))
                    ]),
                    SizedBox(width: 7),
                    Container(
                      child: Center(
                        child: Text(
                          "+",
                          style: CustomTheme.body1.copyWith(fontSize: 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: CustomTheme.grey,
                          borderRadius: BorderRadius.circular(30)),
                      height: 100,
                      width: 100,
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("Description", style: CustomTheme.body2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Enim nec dui nunc mattis enim ut tellus. Nulla facilisi nullam vehicula ipsum. Sed euismod nisi porta lorem mollis aliquam ut porttitor leo. Morbi quis commodo odio aenean sed adipiscing diam donec adipiscing. Porta lorem mollis aliquam ut porttitor leo. Iaculis nunc sed augue lacus. Porta non pulvinar neque laoreet suspendisse. Turpis tincidunt id aliquet risus feugiat. Non sodales neque sodales ut etiam sit amet nisl. Vitae ultricies leo integer malesuada nunc vel risus commodo viverra. Id venenatis a condimentum vitae sapien pellentesque. Ac tortor vitae purus faucibus ornare suspendisse sed nisi lacus. Feugiat pretium nibh ipsum consequat nisl vel pretium lectus quam. Diam in arcu cursus euismod quis. Condimentum vitae sapien pellentesque habitant morbi. A erat nam at lectus urna duis.",
                  style: CustomTheme.body1,
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text("The Services", style: CustomTheme.body2),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(children: [
                        Container(
                          height: Height / 30,
                          width: Width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.primarylightcolor),
                          child: Center(
                              child: Text(
                            "Repair/Services",
                            style: CustomTheme.body7,
                          )),
                        ),
                        Positioned(
                            // left: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 8,
                              ),
                            ))
                      ]),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Stack(children: [
                        Container(
                          height: Height / 30,
                          width: Width / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.primarylightcolor),
                          child: Center(
                              child: Text(
                            "Battery Change",
                            style: CustomTheme.body7,
                          )),
                        ),
                        Positioned(
                            // left: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 8,
                              ),
                            ))
                      ]),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Stack(children: [
                        Container(
                          height: Height / 30,
                          width: Width / 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: CustomTheme.primarylightcolor),
                          child: Center(
                              child: Text(
                            "Tyre",
                            style: CustomTheme.body7,
                          )),
                        ),
                        Positioned(
                            // left: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 8,
                              ),
                            ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(children: [
                          Container(
                            height: Height / 30,
                            width: Width / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: CustomTheme.primarylightcolor),
                            child: Center(
                                child: Text(
                              "Engine Overhaul",
                              style: CustomTheme.body7,
                            )),
                          ),
                          Positioned(
                              // left: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ))
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: GestureDetector(
                        onTap: () {},
                        child: Stack(children: [
                          Container(
                            height: Height / 30,
                            width: Width / 3.6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: CustomTheme.primarylightcolor),
                            child: Center(
                                child: Text(
                              "Performance",
                              style: CustomTheme.body7,
                            )),
                          ),
                          Positioned(
                              // left: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 8,
                                ),
                              ))
                        ]),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: Height / 30,
                      width: Width / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: CustomTheme.grey),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("+", style: CustomTheme.body7),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Add Service",
                              style: CustomTheme.body7,
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              SizedBox(height: Height / 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Text(
                        "price range:",
                        style: CustomTheme.body1,
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.remove),
                      SizedBox(width: 5),
                      Text(
                        "10",
                        style: CustomTheme.body1.copyWith(fontSize: 18),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.add),
                      SizedBox(width: 15),
                      Expanded(
                          child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      )),
                      SizedBox(width: 15),
                      Icon(Icons.remove),
                      SizedBox(width: 5),
                      Text(
                        "50",
                        style: CustomTheme.body1.copyWith(fontSize: 18),
                      ),
                      Icon(Icons.add),
                    ],
                  ),
                  width: double.infinity,
                  height: Height / 13,
                  decoration: BoxDecoration(
                      color: CustomTheme.yellow,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(
                height: Height / 35,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: Width / 3,
                  child: TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        backgroundColor: MaterialStateProperty.all(
                            CustomTheme.primarycolor)),
                    onPressed: () {},
                    child: Text(
                      "Update",
                      style: CustomTheme.body1,
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget Car() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          Images.carImage,
          fit: BoxFit.cover,
          height: 150,
          width: 400,
        ),
      ),
    );
  }

  Widget sharePopUp() {
    return Container();
  }
}
