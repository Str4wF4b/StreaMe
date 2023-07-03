import '../model/stream_model.dart';

final allStreams = <Stream>[
  const Stream(
      id: 0,
      title: "Spider-Man: Across the Spider-Verse",
      type: "Movie",
      year: "2023",
      pg: "12",
      seasonOrDuration: "2 h 30 min",
      genre: ["Action", "Adventure", "Animation", "Science Fiction"],
      cast: ["Hailee Steinfeld, Shameik Moore, Oscar Isaac"],
      direction: ["Joaquim Dos Santos, Kemp Powers, Justik K. Thompson"],
      plot: "After reuniting with Gwen Stacy, Brooklyn’s full-time, friendly neighborhood Spider-Man is catapulted across the Multiverse, where he encounters the Spider Society, a team of Spider-People charged with protecting the Multiverse’s very existence. But when the heroes clash on how to handle a new threat, Miles finds himself pitted against the other Spiders and must set out on his own to save those he loves most.",
      provider: [],
      image:
          "https://de.web.img3.acsta.net/pictures/23/05/02/09/53/0897240.jpg"),
  const Stream(
      id: 1,
      title: "Atypical",
      type: "Series",
      year: "2017 - 2021",
      pg: "12",
      seasonOrDuration: "4 Seasons",
      genre: ["Drama", "Comedy"],
      cast: ["Keir Gilchrist", "Brigette Lundy-Paine", "Jennifer Jason Leigh", "Michael Rapaport"],
      direction: ["Robia Rashid"],
      plot: "Sam, an 18-year-old on the autism spectrum, takes a funny, yet painful, journey of self-discovery for love and independence and upends his family.",
      provider: ["Netflix"],
      image:
          "https://flxt.tmsimg.com/assets/p14273937_b_h9_aa.jpg"),
  const Stream(
      id: 2,
      title: "Alice in Borderland",
      type: "Series",
      year: "2020",
      pg: "16",
      seasonOrDuration: "1 Season",
      genre: ["Drama", "Mystery", "Action", "Science-Fiction", "Fantasy"],
      cast: ["Kento Yamazaki", "Tao Tsuchiya", "Nijiro Murakami"],
      direction: ["Akira Morii"],
      plot: "With his two friends, a video-game-obsessed young man finds himself in a strange version of Tokyo where they must compete in dangerous games to win.",
      provider: ["Netflix"],
      image:
      "https://www.tvmovie.de/assets/2022/12/22/92575-alice-in-borderland-staffel-3-wann-und-wie-geht-es-weiter.jpg"
  ),
  const Stream(
      id: 3,
      title: "Se7en",
      type: "Movie",
      year: "1995",
      pg: "16",
      seasonOrDuration: "2 h 12 min",
      genre: ["Crime", "Mystery", "Thriller"],
      cast: ["Morgan Freeman", "Brad Pitt", "Gwyneth Paltrow"],
      direction: ["Phyllis Carlyle", "Arnold Kopelson"],
      plot: "Two homicide detectives are on a desperate hunt for a serial killer whose crimes are based on the \"seven deadly sins\" in this dark and haunting film that takes viewers from the tortured remains of one victim to the next. The seasoned Det. Sommerset researches each sin in an effort to get inside the killer's mind, while his novice partner, Mills, scoffs at his efforts to unravel the case.",
      provider: ["Netflix"],
      image:
      "https://de.web.img3.acsta.net/medias/nmedia/18/76/03/18/19277893.jpg"
  ),
  const Stream(
      id: 4,
      title: "Demon Slayer: Kimetsu no Yaiba",
      type: "Series",
      year: "2019 - 2023",
      pg: "16",
      seasonOrDuration: "3 Seasons",
      genre: ["Animation", "Action", "Adventure", "Science-Fiction", "Fantasy"],
      cast: ["Natsuki Hanae", "Akari Kito"],
      direction: ["	Haruo Sotozaki"],
      plot: "It is the Taisho Period in Japan. Tanjiro, a kindhearted boy who sells charcoal for a living, finds his family slaughtered by a demon. To make matters worse, his younger sister Nezuko, the sole survivor, has been transformed into a demon herself. Though devastated by this grim reality, Tanjiro resolves to become a “demon slayer” so that he can turn his sister back into a human, and kill the demon that massacred his family.",
      provider: ["Crunchyroll", "Hulu", "Netflix"],
      image:
      "https://m.media-amazon.com/images/M/MV5BZjZjNzI5MDctY2Y4YS00NmM4LTljMmItZTFkOTExNGI3ODRhXkEyXkFqcGdeQXVyNjc3MjQzNTI@._V1_.jpg"
  ),
  const Stream(
      id: 5,
      title: "Knives Out",
      type: "Movie",
      year: "2020",
      pg: "12",
      seasonOrDuration: "1 h 53 min",
      genre: ["Crime", "Comedy", "Mystery"],
      cast: ["Daniel Craig", "Ana de Armas", "Christopher Plummer", "Chris Evans"],
      direction: ["Rian Johnson"],
      plot: "When renowned crime novelist Harlan Thrombey is found dead at his estate just after his 85th birthday, the inquisitive and debonair Detective Benoit Blanc is mysteriously enlisted to investigate. From Harlan's dysfunctional family to his devoted staff, Blanc sifts through a web of red herrings and self-serving lies to uncover the truth behind Harlan's untimely death.",
      provider: ["Netflix"],
      image:
      "https://m.media-amazon.com/images/M/MV5BMGUwZjliMTAtNzAxZi00MWNiLWE2NzgtZGUxMGQxZjhhNDRiXkEyXkFqcGdeQXVyNjU1NzU3MzE@._V1_.jpg"
  ),
  const Stream(
      id: 6,
      title: "The Conjuring 2",
      type: "Movie",
      year: "2016",
      pg: "R",
      seasonOrDuration: "2 h 14 min",
      genre: ["Horror", "Thriller"],
      cast: ["Patrick Wilson", "Vera Farmiga", "Madison Wolfe", "Frances O'Connor"],
      direction: ["James Wan"],
      plot: "Lorraine and Ed Warren travel to north London to help a single mother raising four children alone in a house plagued by malicious spirits.",
      provider: ["Netflix", "SkyGo", "WOW"],
      image:
      "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/zEqyD0SBt6HL7W9JQoWwtd5Do1T.jpg"
  ),
  const Stream(
      id: 7,
      title: "Ted Lasso",
      type: "Movie",
      year: "2020 - 2023",
      pg: "MA",
      seasonOrDuration: "3 Seasons",
      genre: ["Comedy", "Drama", "Sport"],
      cast: ["Jason Sudeikis", "Brett Goldstein", "Juno Temple"],
      direction: ["Jason Sudeikis", "Brendan Hunt", "Bill Lawrence", "Joe Kelly"],
      plot: "Ted Lasso, an American football coach, moves to England when he’s hired to manage a soccer team—despite having no experience. With cynical players and a doubtful town, will he get them to see the Ted Lasso Way?",
      provider: ["AppleTVPlus"],
      image:
      "https://www.werstreamt.es/assets/Media/Posters/apple/Ted_Lasso_key_art_2x3-small__ScaleWidthWzM0Ml0.png"
  ),
  const Stream(
    id: 8,
    title: "The Maze Runner",
    type: "Movie",
    year: "2014",
    pg: "13",
    seasonOrDuration: "1 h 53 min",
    genre: ["Action", "Mystery", "Science Fiction", "Thriller"],
    cast: ["Dylan O'Brien", "Kaya Scodelario", "Thomas Brodie-Sangster", "Will Poulter"],
    direction: ["Wes Ball"],
    plot: "Set in a post-apocalyptic world, young Thomas is deposited in a community of boys after his memory is erased, soon learning they're all trapped in a maze that will require him to join forces with fellow “runners” for a shot at escape.",
    provider: ["DisneyPlus"],
    image: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/ode14q7WtDugFDp78fo9lCsmay9.jpg"
  ),
];
