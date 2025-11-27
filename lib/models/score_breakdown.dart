class ScoreBreakdown {
  final int eagles;
  final int birdies;
  final int pars;
  final int bogeys;
  final int doubleBogeys;
  final int others;
  final int totalHoles;

  ScoreBreakdown({
    required this.eagles,
    required this.birdies,
    required this.pars,
    required this.bogeys,
    required this.doubleBogeys,
    required this.others,
    required this.totalHoles,
  });

  double get eagleRate => totalHoles == 0 ? 0.0 : (eagles / totalHoles) * 100;
  double get birdieRate => totalHoles == 0 ? 0.0 : (birdies / totalHoles) * 100;
  double get parRate => totalHoles == 0 ? 0.0 : (pars / totalHoles) * 100;
  double get bogeyRate => totalHoles == 0 ? 0.0 : (bogeys / totalHoles) * 100;
  double get doubleBogeyRate => totalHoles == 0 ? 0.0 : (doubleBogeys / totalHoles) * 100;
  double get otherRate => totalHoles == 0 ? 0.0 : (others / totalHoles) * 100;
  
  double get birdieOrBetterRate => totalHoles == 0 ? 0.0 : ((eagles + birdies) / totalHoles) * 100;
  double get parOrBetterRate => totalHoles == 0 ? 0.0 : ((eagles + birdies + pars) / totalHoles) * 100;
}
