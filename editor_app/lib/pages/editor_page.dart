import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_view/pages/editor_layout_model.dart';
import 'package:markdown_view/pages/editor_model.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TextEditCubit()),
        BlocProvider(create: (context) => EditorLayoutCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<EditorLayoutCubit, EditorLayout>(
            builder: (BuildContext context, data) {
              return data.when(
                onEditor: _buildMarkdownCard(context),
                onPreview: _buildPreviewCard(context),
                onSideBySide: _buildSideBySideViewContainer(),
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<EditorLayoutCubit, EditorLayout>(
          builder: (BuildContext context, data) {
            return FloatingActionButton(
              onPressed: context.read<EditorLayoutCubit>().next,
              child: Icon(
                data.when(
                  onEditor: Icons.edit,
                  onPreview: Icons.preview,
                  onSideBySide: Icons.view_sidebar,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSideBySideViewContainer() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return _buildSideBySideView(
          context: context,
          axis: orientation == Orientation.landscape ? 2 : 1,
        );
      },
    );
  }

  Widget _buildSideBySideView({
    required BuildContext context,
    required int axis,
  }) {
    return GridView.count(
      crossAxisSpacing: 20,
      crossAxisCount: axis,
      children: [
        _buildMarkdownCard(context),
        _buildPreviewCard(context),
      ],
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    return _buildCard(
      context: context,
      title: 'Preview',
      child: BlocBuilder<TextEditCubit, String>(
        builder: (BuildContext context, data) {
          return Markdown(data: data);
        },
      ),
    );
  }

  Widget _buildMarkdownCard(BuildContext context) {
    return _buildCard(
      context: context,
      title: 'Markdown',
      child: BlocListener<EditorLayoutCubit, EditorLayout>(
        listener: (context, state) {
          _textController.text = context.read<TextEditCubit>().state;
        },
        child: TextField(
          controller: _textController,
          decoration: const InputDecoration(
            hintText: 'Write your markdown here',
          ),
          onChanged: context.read<TextEditCubit>().update,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
    );
  }

  Widget _buildCard({
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
