import 'dart:convert';

import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
        '/welcome' : (context) => const SampleAppPage(),
        '/fadeTest' : (context) => const MyFadeTest("FadeTest"),
        '/netTest' : (context) => const SampleNetAppPage(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress(){
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController,
    ];
    for(final controller in controllers){

      if(controller.value.text.isNotEmpty){
        progress += 1 / controllers.length;
      }
    }
    setState(() {
      _formProgress = progress;
    });

  }

  @override
  Widget build(BuildContext context) {

    void _showWelcomeScreen(){
      Navigator.of(context).pushNamed("/welcome");
    }

    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.white;
                  }),
              backgroundColor: MaterialStateProperty.resolveWith(
                      (Set<MaterialState> states) {
                    return states.contains(MaterialState.disabled)
                        ? null
                        : Colors.blue;
                  }),
            ),
            onPressed:
                _formProgress == 1 ? _showWelcomeScreen : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Text("Welcome",style: Theme.of(context).textTheme.headline1,),
      ),
    );
  }

}

class AnimatedProgressIndicator extends StatefulWidget{

  final double value;

  const AnimatedProgressIndicator({
    required this.value,
});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicator();
  }

}

class _AnimatedProgressIndicator extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1200),vsync: this);
    final colorTween = TweenSequence(
      [
        TweenSequenceItem(tween: ColorTween(begin : Colors.red,end: Colors.orange), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin : Colors.orange,end: Colors.yellow), weight: 1),
        TweenSequenceItem(tween: ColorTween(begin : Colors.yellow,end: Colors.green), weight: 1),
      ]);
    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }


  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder:(context,child) => LinearProgressIndicator(
      value: _curveAnimation.value,
      valueColor: _colorAnimation,
      backgroundColor: _colorAnimation.value?.withOpacity(0.4),
    ));
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Default value for toggle.
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  void _showFadeTest(){
    Navigator.of(context).pushNamed('/fadeTest');
  }

  void _showNetTest(){
    Navigator.of(context).pushNamed('/netTest');
  }


  Widget _getToggleChild() {
    if (toggle) {
      return TextButton(
          onPressed: _showNetTest,
          child: const Text('Sign up')
      );
    } else {
      return ElevatedButton(
        onPressed: _showFadeTest,
        child: const Text('Toggle Two'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: const Icon(Icons.update),
      ),
    );
  }
}

class MyFadeTest extends StatefulWidget {
  const MyFadeTest(this.title);

  final String title;
  @override
  State<MyFadeTest> createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FadeTransition(
          opacity: curve,
          child: const FlutterLogo(
            size: 100,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        onPressed: () {
          controller.forward();
        },
        child: const Icon(Icons.brush),
      ),
    );
  }
}

class SampleNetAppPage extends StatefulWidget {
  const SampleNetAppPage({super.key});

  @override
  State<SampleNetAppPage> createState() => _SampleNetAppPageState();
}

class _SampleNetAppPageState extends State<SampleNetAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget getBody() {
    bool showLoadingDialog = widgets.isEmpty;
    if (showLoadingDialog) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  Widget getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: getBody(),
    );
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, position) {
        return getRow(position);
      },
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      onTap: (){
        setState(() {
          developer.log("row $i");
        });
      },
      child:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text("Row ${widgets[i]["title"]}"),
      ),
    );

  }

  Future<void> loadData() async {
    var dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = jsonDecode(response.body);
    });
  }
}