class Actor {
  final int id;
  final String displayName;
  final String firstName;
  final String secondName;
  final int age;
  final String birthday;
  final String placeOfBirth;
  final String biography;
  final Map<String, List> acting;
  final Map<String, List> production;
  final Map<String, List> directing;
  final String image;

  const Actor({
    required this.id,
    required this.displayName,
    required this.firstName,
    required this.secondName,
    required this.age,
    required this.birthday,
    required this.placeOfBirth,
    required this.biography,
    required this.acting,
    required this.production,
    required this.directing,
    required this.image,
  });
}
