import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:equatable/equatable.dart';

import '../../../../Repositories/repository_manager.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  late RepositoryManager _repository;

  HomeCubit() : super(HomeStateInitial()) {
    _repository = GetIt.I<RepositoryManager>();
  }
}
