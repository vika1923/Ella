import 'package:auth_app_flutter/Utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.purple,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: const MyStatefulWidget(), //Container(),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/logo2.png',
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.home),
                title: const Text('Home'),
              ),
              ListTile(
                onTap: (() {
                  Navigator.pushNamed(context, MyRoutes.web);
                }),
                leading: const Icon(Icons.mail),
                title: const Text('Telegram Chat'),
              ),
              ListTile(
                onTap: (() {
                  Navigator.pushNamed(context, MyRoutes.chatting);
                }),
                leading: const Icon(Icons.favorite),
                title: const Text('Secret Chat'),
              ),
              ListTile(
                onTap: (() {
                  Navigator.pushNamed(context, MyRoutes.calendar);
                }),
                leading: const Icon(Icons.calendar_month),
                title: const Text('Calendar'),
              ),
              ListTile(
                onTap: (() {
                  Navigator.pushNamed(context, MyRoutes.aboutus);
                }),
                leading: const Icon(Icons.settings),
                title: const Text('About Us'),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.login_outlined),
                title: const Text('Logout'),
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Terms of Service | Privacy Policy'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    WebView(
      initialUrl: 'https://www.unwomen.org',
      javascriptMode: JavascriptMode.unrestricted,
    ),
    Center(
        child: WebView(
      initialUrl: 'https://www.sexeducationforum.org.uk',
      javascriptMode: JavascriptMode.unrestricted,
    )),
    WebView(
      initialUrl: 'https://online.fliphtml5.com/lhljt/bmhb/?1650982033231',
      javascriptMode: JavascriptMode.unrestricted,
    ),
    Center(
        child: WebView(
      initialUrl: 'http://www.itsyoursexlife.com/',
      javascriptMode: JavascriptMode.unrestricted,
    )),
    WebView(
      initialUrl:
          'https://www.psychologytoday.com/intl/tests?order=entityqueue_relationship_position&sort=desc',
      javascriptMode: JavascriptMode.unrestricted,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),*/
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'For Girls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Sex Education',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'ITGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.multitrack_audio),
            label: 'Tests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'FAQ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}
