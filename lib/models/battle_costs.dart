import 'package:equatable/equatable.dart';

class ActionCosts extends Equatable {
  final int ap;
  final int cp;
  final int sp;
  
  const ActionCosts({this.ap = 0, this.cp = 0, this.sp = 0});
  
  @override
  List<Object?> get props => [ap, cp, sp];
}

class BattleCosts {
  // Tune here any time
  static const move = ActionCosts(ap: 20, cp: 0, sp: 5);
  static const punch = ActionCosts(ap: 20, cp: 0, sp: 10);
  static const heal = ActionCosts(ap: 20, cp: 25, sp: 0);

  // Base heal amount
  static const healAmount = 500;
}
