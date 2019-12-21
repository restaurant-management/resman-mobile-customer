import 'package:bloc/bloc.dart';
import 'package:resman_mobile_customer/src/models/comment.dart';
import 'package:resman_mobile_customer/src/repositories/repository.dart';

class CommentBloc extends Bloc<CommentBlocEvent, CommentBlocState> {
  final int dishId;
  Repository _repository = Repository();
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  CommentBloc(this.dishId);

  @override
  CommentBlocState get initialState => CommentBlocInitialize();

  @override
  Stream<CommentBlocState> mapEventToState(CommentBlocEvent event) async* {
    if (event is FetchComment) {
      yield CommentBlocFetching(dishId);
      try {
        _comments = await _repository.getCommentsOfDish(dishId);
        yield CommentBlocFetchSuccess(_comments);
      } catch (e) {
        yield CommentBlocFetchFailure(e.toString());
      }
    }
    if (event is CreateComment) {
      yield CommentBlocCreatingComment(dishId);
      try {
        final comment = await _repository.createComment(
            dishId, event.content, event.rating);
        _comments = [comment, ..._comments];
        yield CommentBlocCreateSuccess(comment);
      } catch (e) {
        yield CommentBlocCreateFailure(e.toString());
      }
      yield CommentBlocInitialize();
    }
  }
}

abstract class CommentBlocEvent {}

abstract class CommentBlocState {}

// ============ STATE ============//

class CommentBlocInitialize extends CommentBlocState {
  @override
  String toString() => 'CommentBlocInitialize';
}

class CommentBlocFetching extends CommentBlocState {
  final int dishId;

  CommentBlocFetching(this.dishId);
  @override
  String toString() => 'CommentBlocFetching (dishId: $dishId)';
}

class CommentBlocFetchFailure extends CommentBlocState {
  final String error;

  CommentBlocFetchFailure(this.error);
  @override
  String toString() => 'CommentBlocFetchFailure ($error)';
}

class CommentBlocFetchSuccess extends CommentBlocState {
  final List<Comment> comments;

  CommentBlocFetchSuccess(this.comments);
  @override
  String toString() => 'CommentBlocFetchSuccess (${comments.length} comments)';
}

class CommentBlocCreatingComment extends CommentBlocState {
  final int dishId;
  CommentBlocCreatingComment(this.dishId);
  @override
  String toString() => 'CommentBlocCreatingComment (dish $dishId)';
}

class CommentBlocCreateFailure extends CommentBlocState {
  final String error;

  CommentBlocCreateFailure(this.error);
  @override
  String toString() => 'CommentBlocCreateFailure ($error)';
}

class CommentBlocCreateSuccess extends CommentBlocState {
  final Comment comment;

  CommentBlocCreateSuccess(this.comment);
  @override
  String toString() => 'CommentBlocCreateSuccess (${comment.id})';
}

// ============ EVENT ============//

class FetchComment extends CommentBlocEvent {
  @override
  String toString() => 'FetchComment';
}

class CreateComment extends CommentBlocEvent {
  final String content;
  final double rating;

  CreateComment(this.content, {this.rating = 5.0});
  @override
  String toString() => 'CreateComment ($content)';
}
