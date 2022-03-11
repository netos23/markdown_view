import 'package:flutter_bloc/flutter_bloc.dart';

const String message = 'The markdown document is still empty';

class TextEditCubit extends Cubit<String> {
  TextEditCubit() : super(message);

  void update(String val) => emit(val.isNotEmpty ? val : message);
}