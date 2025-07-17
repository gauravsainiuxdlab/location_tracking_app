import '../enums/view_state.dart';

class ViewStateManager {
  ViewState _state = ViewState.loading;
  String? _message;

  ViewState get state => _state;
  String? get message => _message;

  void setLoading([String? msg]) {
    _state = ViewState.loading;
    _message = msg;
  }

  void setEmpty([String? msg]) {
    _state = ViewState.empty;
    _message = msg;
  }

  void setComplete([String? msg]) {
    _state = ViewState.complete;
    _message = msg;
  }

  void setError([String? msg]) {
    _state = ViewState.error;
    _message = msg;
  }

  @override
  String toString() {
    return 'ViewState: $_state, Message: $_message';
  }
}
