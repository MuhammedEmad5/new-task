import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_task/presentation_layer/youtube%20videos/cubit/states.dart';


class YoutubeVideosScreenCubit extends Cubit<YoutubeVideosScreenStates> {

  YoutubeVideosScreenCubit() : super(YoutubeVideosScreenInitialState());

  static YoutubeVideosScreenCubit get(context) => BlocProvider.of(context);


}
