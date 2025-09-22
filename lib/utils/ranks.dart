// lib/utils/ranks.dart

enum NinjaRank { student, genin, chunin, jounin, eliteJounin }

class RankThresholds {
  // CUMULATIVE XP thresholds (inclusive lower bound, exclusive upper bound except top)
  static const int studentCap    = 7_500;      // 0 .. <7,500
  static const int geninCap      = 60_000;     // 7,500 .. <60,000
  static const int chuninCap     = 750_000;    // 60,000 .. <750,000
  static const int jouninCap     = 2_250_000;  // 750,000 .. <2,250,000
  static const int eliteCap      = 5_000_000;  // 2,250,000 .. 5,000,000 (max)

  static NinjaRank rankForXp(int xp) {
    if (xp < studentCap) return NinjaRank.student;
    if (xp < geninCap)   return NinjaRank.genin;
    if (xp < chuninCap)  return NinjaRank.chunin;
    if (xp < jouninCap)  return NinjaRank.jounin;
    return NinjaRank.eliteJounin; // cap at top
  }

  static int capFor(NinjaRank r) {
    switch (r) {
      case NinjaRank.student:     return studentCap;
      case NinjaRank.genin:       return geninCap;
      case NinjaRank.chunin:      return chuninCap;
      case NinjaRank.jounin:      return jouninCap;
      case NinjaRank.eliteJounin: return eliteCap;
    }
  }

  static (int min, int max) rangeFor(NinjaRank r) {
    switch (r) {
      case NinjaRank.student:     return (0, studentCap);
      case NinjaRank.genin:       return (studentCap, geninCap);
      case NinjaRank.chunin:      return (geninCap, chuninCap);
      case NinjaRank.jounin:      return (chuninCap, jouninCap);
      case NinjaRank.eliteJounin: return (jouninCap, eliteCap);
    }
  }

  static double progressWithinRank(int xp, NinjaRank r) {
    final (min, max) = rangeFor(r);
    final span = (max - min).toDouble();
    if (span <= 0) return 1.0;
    return ((xp - min) / span).clamp(0.0, 1.0);
  }
}
