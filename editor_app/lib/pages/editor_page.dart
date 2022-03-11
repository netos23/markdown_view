import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_view/pages/editor_model.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocProvider(
        create: (context) => TextEditCubit(),
        child: _buildBody(),
      ),
    );
  }

  OrientationBuilder _buildBody() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return _buildGridView(
          context: context,
          axis: orientation == Orientation.landscape ? 2 : 1,
        );
      },
    );
  }

  GridView _buildGridView({
    required BuildContext context,
    required int axis,
  }) {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      crossAxisCount: axis,
      children: [
        _buildCard(
          context: context,
          title: 'Markdown',
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Write your markdown here',
            ),
            onChanged: context.read<TextEditCubit>().update,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
        _buildCard(
          context: context,
          title: 'Preview',
          child: BlocBuilder<TextEditCubit, String>(
            builder: (BuildContext context, data) {
              return Markdown(data: data);
            },
          ),
        )
      ],
    );
  }

  Card _buildCard({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
