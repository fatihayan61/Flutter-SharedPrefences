import 'package:flutter/material.dart';
import 'package:shared_example/utilts/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_example/utilts/shared.dart';
import '../model/dataModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Service _services = Service();
  SharedPrefs shared = SharedPrefs();
  late Future<List<Post>> parseData;
  bool control = false;

  turnSnackBar(String data) {
    var snackBar1 = SnackBar(
      duration: const Duration(seconds: 1),
      elevation: 6,
      backgroundColor: Colors.blue,
      padding: const EdgeInsets.all(16),
      behavior: SnackBarBehavior.floating,
      content: Text(data),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }

  @override
  void initState() {
    super.initState();
    controlShared();
  }

  Future<void> controlShared() async {
    if (shared.control) {
      parseData = _chageFutureList();
      control = true;
    } else {
      parseData = _services.fetchData(http.Client());
      control = false;
      setState(() {});
    }
  }

  Future<List<Post>> _chageFutureList() async {
    return Future.value(_services.parseData(shared.sharedData!));
  }

  removeSharedData() async {
    if (shared.control) {
      await shared.removeUserShared();
      turnSnackBar("Remove Shared Data");
      setState(() {});
    }
  }

  saveServiceData() async {
    if (!shared.control) {
      await SharedPrefs().createDataShared(_services.response.body);
      turnSnackBar("Save Service Data");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: control ? const Text("Shared Data") : const Text('Service Data'),
        actions: [
          control
              ? IconButton(
                  onPressed: () {
                    removeSharedData();
                  },
                  icon: const Icon(Icons.delete),
                )
              : IconButton(
                  onPressed: () {
                    saveServiceData();
                  },
                  icon: const Icon(Icons.save),
                )
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: parseData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to fetch data'),
            );
          } else if (snapshot.hasData) {
            return PostList(
              posts: snapshot.data!,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({Key? key, required this.posts}) : super(key: key);
  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(posts[index].title),
          ),
        );
      },
    );
  }
}
