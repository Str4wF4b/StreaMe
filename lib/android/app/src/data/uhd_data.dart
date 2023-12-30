import 'package:stream_me/android/app/src/model/uhd_model.dart';
import '../../src/utils/images.dart';

final Images image = Images();

final allUhd = <Uhd>[
  //Spider-Man: Across the Spider-Verse:
  Uhd(id: 0, streamId: 0, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/"]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [image.magentaTv, image.prime, image.appleTv],
    "Platform": ["Magenta TV €13,99", "Prime €13,99", "Apple TV €13,99"],
    "Link": [
      "https://www.telekom.de/start",
      "https://www.amazon.de/gp/video/detail/0N7EAU0Y85VI5OO04TYKSXL85T/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-across-the-spider-verse/umc.cmc.2zphwshxw2ejh2znevhod0u01?playableId=tvs.sbd.9001%3A1688506685"
    ]
  }),
  //Atypical:
  Uhd(id: 1, streamId: 1, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/80117540"]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //Alice in Borderland:
  Uhd(id: 2, streamId: 2, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/80200575"]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //Se7en:
  const Uhd(
      id: 3,
      streamId: 3,
      streamOn: {"Logo": [], "Platform": [], "Link": []},
      rent: {"Logo": [], "Platform": [], "Link": []},
      buy: {"Logo": [], "Platform": [], "Link": []}),
  //Demon Slayer: Kimetsu no Yaiba:
  const Uhd(id: 4, streamId: 4, streamOn: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": [],
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //Knives Out:
  Uhd(id: 5, streamId: 5, streamOn: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, rent: {
    "Logo": [image.prime],
    "Platform": ["Prime €4,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0STC0IYO0HN9D8RQTUSQUMWG71/ref=atv_dl_rdr?tag=justdersjd-21"
    ],
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //The Conjuring 2:
  const Uhd(id: 6, streamId: 6, streamOn: {
    "Logo": [],
    "Platform": [],
    "Link": [
    ]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //Ted Lasso:
  Uhd(id: 7, streamId: 7, streamOn: {
    "Logo": [image.appleTvPlus],
    "Platform": ["Apple TV+"],
    "Link": ["https://tv.apple.com/de/episode/pilot/umc.cmc.zb0yksqtym68hasbq8mj4jwp?playableId=tvs.sbd.4000%3AVTEDL0560101"]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //The Maze Runner:
  Uhd(id: 8, streamId: 8, streamOn: {
    "Logo": [image.disneyPlus],
    "Platform": ["Disney+"],
    "Link": ["https://www.disneyplus.com/de-de/movies/maze-runner-die-auserwahlten-im-labyrinth/5eMMEyNl6tWG?irclickid=VfP3CZxx0xyPTg%3AV9Mwcc0e-UkH008VJkRwcRM0&irgwc=1&cid=DSS-Affiliate-Impact-Content-JustWatch+GmbH-705874&tgclid=04010022-ac11-4e05-bd00-1576657a2c0c&dclid=CNX6ipW3jYMDFWCS_QcdUvUM2w"]
  }, rent: {
    "Logo": [image.appleTv, image.prime, image.magentaTv],
    "Platform": ["Apple TV €3,99", "Prime €3,99", "Magenta TV €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/maze-runner---die-auserwahlten-im-labyrinth/umc.cmc.4ljr4z86mfhtbdouv5ml5h693?playableId=tvs.sbd.9001%3A919198535",
      "https://www.amazon.de/gp/video/detail/0HX2AL1JXHLS8ZOM4EPW5JFV5V/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://www.telekom.de/start"
    ]
  }, buy: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €9,99", "Prime €9,99", "Magenta TV €9,99"],
    "Link": [
      "https://tv.apple.com/de/movie/maze-runner---die-auserwahlten-im-labyrinth/umc.cmc.4ljr4z86mfhtbdouv5ml5h693?playableId=tvs.sbd.9001%3A919198535",
      "https://www.amazon.de/gp/video/detail/0HX2AL1JXHLS8ZOM4EPW5JFV5V/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://www.telekom.de/start"
    ]
  }),
  //Dahmer - Monster: The Jeffrey Dahmer Story:
  Uhd(id: 9, streamId: 9, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/81287562"]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
  //Spider-Man: Into the Spider-Verse:
  Uhd(id: 10, streamId: 10, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/81002747"]
  }, rent: {
    "Logo": [image.prime, image.appleTv, image.magentaTv],
    "Platform": ["Prime €3,99", "Apple TV €3,99", "Magenta TV €3,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0O2SSA8EE8BYL2EI1DE0HG8XS4/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-a-new-universe/umc.cmc.4a2ypxddplsdsahwxrc5fkz4x?playableId=tvs.sbd.9001%3A1447687300",
      "https://www.telekom.de/start"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv, image.magentaTv],
    "Platform": ["Prime €9,99", "Apple TV €9,99", "Magenta TV €9,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0O2SSA8EE8BYL2EI1DE0HG8XS4/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-a-new-universe/umc.cmc.4a2ypxddplsdsahwxrc5fkz4x?playableId=tvs.sbd.9001%3A1447687300",
      "https://www.telekom.de/start"
    ]
  }),
  //One Piece:
  const Uhd(id: 11, streamId: 11, streamOn: {
    "Logo": [],
    "Platform": [],
    "Link": [
    ]
  }, rent: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }, buy: {
    "Logo": [],
    "Platform": [],
    "Link": []
  }),
];
