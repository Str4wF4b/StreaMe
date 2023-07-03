class Actor {
  final int id;
  final String firstName;
  final String secondName;
  final int age;
  final String birthday;
  final String placeOfBirth;
  final List<String> movies;
  final List<String> series;
  final String image;

  const Actor({
    required this.id,
    required this.firstName,
    required this.secondName,
    required this.age,
    required this.birthday,
    required this.placeOfBirth,
    required this.movies,
    required this.series,
    required this.image,
  });
}
