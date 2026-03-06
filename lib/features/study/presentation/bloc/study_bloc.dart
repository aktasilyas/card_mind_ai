import 'package:flutter_bloc/flutter_bloc.dart';

part 'study_event.dart';
part 'study_state.dart';

class StudyBloc extends Bloc<StudyEvent, StudyState> {
  StudyBloc() : super(const StudyInitial());
}
