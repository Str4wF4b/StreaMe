class Streams {
  final int id;
  final String title;
  final String type;
  final String year;
  final String pg;
  final String seasonOrDuration;
  final List<String> genre;
  final List<String> cast;
  final List<String> direction;
  final String plot;
  final List<String> provider;
  final String image;

  const Streams({
    required this.id,
    required this.title,
    required this.type,
    required this.year,
    required this.pg,
    required this.seasonOrDuration,
    required this.genre,
    required this.cast,
    required this.direction,
    required this.plot,
    required this.provider,
    required this.image,
  });
}
