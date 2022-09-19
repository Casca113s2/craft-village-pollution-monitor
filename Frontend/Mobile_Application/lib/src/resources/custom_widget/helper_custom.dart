import 'package:fl_nynberapp/src/app.dart';
import 'package:fl_nynberapp/src/resources/change_password_page.dart';
import 'package:fl_nynberapp/src/resources/craft_page.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/shape_custom.dart';
import 'package:fl_nynberapp/src/resources/details_user_page.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/home_page.dart';
import 'package:fl_nynberapp/src/resources/login_page.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class Helper {
  double _height ;
  double _width ;
  var scaffoldKey;
  var context;
  String fullname = "";
  String email = "";
  
  Helper(double _height, double _width, var scaffoldKey, var context, String fullname, String email) {
    this._height = _height;
    this._width = _width;
    this.scaffoldKey = scaffoldKey;
    this.context = context;
    this.fullname = fullname;
    this.email = email;
  }
  
  Widget drawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Opacity(
            opacity: 0.75,
            child: Container(
                height: _height / 5,
                padding: EdgeInsets.only(top: _height / 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[200], LightColors.kDarkYellow],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.black,
                          ),
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                        title: Text(fullname),
                        subtitle: Text(
                          email,
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsUserPage()));
                            })),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
                      
                      Padding(
                      padding: EdgeInsets.fromLTRB(_width / 22, 0, 0, 0),
                      child: GestureDetector(
                        onTap: onLogoutClick,
                        child: Text(LanguageConfig.getLogout()),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(_width / 22, 0, _width/22, 0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangePassword()));
                        },
                        child: Text(LanguageConfig.getChangePassword()),
                      ),
                    ),
                    ],)
                   
                  ],
                )),
          ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("News"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("CV map"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("Image library"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("Archievements"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("Logs"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("Surveys completed"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("Surveys in progress"),
          // ),
          // ListTile(
          //   leading: Icon(Icons.payment),
          //   title: Text("New survey"),
          //   onTap: (){
          //      Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) => CraftPage(null, 0, 0, null)));
          //   },
          // ),
        ],
      ),
    );
  }
  Widget bottomNavBar() {
    return BottomAppBar(
      notchMargin: 4,
      shape: AutomaticNotchedShape(RoundedRectangleBorder(),
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Container(
        margin: EdgeInsets.only(left: 50, right: 50),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _height / 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _height / 5.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.25,
          child: ClipPath(
            clipper: CustomShapeClipper3(),
            child: Container(
              height: _height / 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(left: 40, right: 40, top: _height / 3.75),
        //   child: Material(
        //     borderRadius: BorderRadius.circular(30.0),
        //     elevation: 8,
        //     child: Container(
        //       child: TextFormField(
        //         cursorColor: Colors.orange[200],
        //         keyboardType: TextInputType.text,
        //         decoration: InputDecoration(
        //           contentPadding: EdgeInsets.all(10),
        //           prefixIcon:
        //           Icon(Icons.search, color: Colors.orange[200], size: 30),
        //           hintText: "What're you looking for?",
        //           border: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(30.0),
        //               borderSide: BorderSide.none),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
            //color: Colors.blue,
            margin: EdgeInsets.only(left: 20, right: 20, top: _height / 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/menubutton.png',
                          height: _height / 40,
                        )),
                  ),
                ),
                // Flexible(
                //   child: Container(
                //     height: _height / 20,
                //     padding: EdgeInsets.only(left: 10,right: 10),
                //     decoration: BoxDecoration(
                //       color: Colors.black12,
                //       shape: BoxShape.rectangle,
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: <Widget>[
                //         GestureDetector(
                //           onTap: (){
                //             print('Editing location');
                //           },
                //           child: Icon(
                //             Icons.edit_location,
                //             color: Colors.white,
                //             size: _height/40,
                //           ),
                //         ),
                //         SizedBox(width: 10,),
                //         // Flexible(
                //         //     child: Text('Noida',
                //         //         style: TextStyle(
                //         //             color: Colors.white, fontSize: _height/50),
                //         //         // overflow: TextOverflow.fade,
                //         //         softWrap: false)),
                //       ],
                //     ),
                //   ),
                // ),
                // Opacity(
                //   opacity: 0.5,
                //   child: avatar()
                //   // GestureDetector(
                //   //     onTap: () {},
                //   //     child: Icon(
                //   //       Icons.notifications,
                //   //       color: Colors.black,
                //   //       size: _height / 30,
                //   //     )),
                // ),
              ],
            )),
      ],
    );
  }

  Widget drawerMenu() {
    return Opacity(
      opacity: 0.75,
      child: Container(
          //color: Colors.blue,
          margin: EdgeInsets.only(left: 20, right: 20, top: _height / 20),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Colors.orange[200], Colors.pinkAccent],
          //   ),
          // ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/menubutton.png',
                          height: _height / 40,
                        )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  child: Text(
                    "Craft Village",
                    style: TextStyle(fontSize: 28, color: Colors.black),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomePage()),
                            (Route<dynamic> route) => false);
                      },
                      child: Icon(
                        Icons.home,
                        size: _height / 30,
                      ),
                    ),
                  ),
                ),
              ])),
    );
  }
  Widget menuButton() {
    return Opacity(
      opacity: 0.75,
      child: Container(
          //color: Colors.blue,
          margin: EdgeInsets.only(left: 0, right: 20, top: _height / 30),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Colors.orange[200], Colors.pinkAccent],
          //   ),
          // ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        child: Image.asset(
                          'assets/images/menubutton.png',
                          height: _height / 40,
                        )),
                  ),
                ),
                
              ])),
    );
  }

  onLogoutClick() {
    var auth = MyApp.of(context).auth;
     print('yo hey0');
    LoadingDialog.showLoadingDialog(context, LanguageConfig.getLoading());
    try{
      auth.signOut(() {
      //LoadingDialog.hideLoadingDialog(context);
      //  Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => HomePage()));

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Lỗi", msg);
    });
    }catch(e){
      print('yo hey1');

      Future.delayed(Duration(seconds: 2), () {
            print('yo hey2');
            LoadingDialog.hideLoadingDialog(context);
      });

    }
    
  }
  
}
