import 'package:flutter_bloc/flutter_bloc.dart';

enum EditorLayout {
  editor,
  preview,
  sideBySide,
}

extension EditorLayoutMap on EditorLayout {
  T when<T>({
    required T onEditor,
    required T onPreview,
    required T onSideBySide,
  }) {
    switch (this) {
      case EditorLayout.editor:
        return onEditor;
      case EditorLayout.preview:
        return onPreview;
      case EditorLayout.sideBySide:
        return onSideBySide;
    }
  }
}

class EditorLayoutCubit extends Cubit<EditorLayout> {
  EditorLayoutCubit() : super(EditorLayout.sideBySide);

  void editor() => emit(EditorLayout.editor);

  void preview() => emit(EditorLayout.preview);

  void sideBySide() => emit(EditorLayout.sideBySide);

  void next() =>
      emit(EditorLayout.values[(state.index + 1) % EditorLayout.values.length]);
}
