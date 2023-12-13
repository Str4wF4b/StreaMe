class Uhd {
  final int id;
  final int streamId;
  final Map streamOn;
  final Map rent;
  final Map buy;

  const Uhd({
    required this.id,
    required this.streamId,
    required this.streamOn,
    required this.rent,
    required this.buy
  });
}