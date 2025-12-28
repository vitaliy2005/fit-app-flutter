import 'package:bloc/bloc.dart';
import 'package:contacts_app/repositories/user_profile/user_profile.dart';
import 'package:contacts_app/repositories/user_profile/user_profile_repository.dart';
import 'package:equatable/equatable.dart';

part 'profile_widgets_event.dart';
part 'profile_widgets_state.dart';

class ProfileWidgetsBloc extends Bloc<ProfileWidgetsEvent, ProfileWidgetsState> {
  ProfileWidgetsBloc({required this.userProfileRepository}) : super(ProfileWidgetsInitial()) {
    on<ProfileWidgetsReadEvent>((event, emit) async {
      if (state is! ProfileWidgetsLoaded) emit(ProfileWidgetsLoading());

      try {
        final user = await userProfileRepository.getProfile();

        if (user == null) {
          emit(ProfileWidgetsUnauthorized());
          return;
        }

        emit(ProfileWidgetsLoaded(surname: user.surname, name: user.name, userId: '@userId', email: user.email, number: "+71234567890", avatarUrl: '${user.surname[0] + user.name[0]}'.toUpperCase()));
      } catch (e) {
        emit(ProfileWidgetsError(e.toString()));
      }
      UserProfile? user = await userProfileRepository.getProfile();
      
      if (user == null){
        
      }

    });
  }


  final UserProfileRepository userProfileRepository;
}
