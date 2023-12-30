import 'package:stream_me/android/app/src/model/sd_model.dart';
import '../../src/utils/images.dart';

final Images image = Images();

final allSd = <Sd>[
  //Spider-Man: Across the Spider-Verse:
  Sd(id: 0, streamId: 0, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/"]
  }, rent: {
    "Logo": [image.prime, image.appleTv],
    "Platform": ["Prime €3,99", "Apple TV €4,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0N7EAU0Y85VI5OO04TYKSXL85T/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-across-the-spider-verse/umc.cmc.2zphwshxw2ejh2znevhod0u01?playableId=tvs.sbd.9001%3A1688506685"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv],
    "Platform": ["Prime €13,99", "Apple TV €13,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0N7EAU0Y85VI5OO04TYKSXL85T/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-across-the-spider-verse/umc.cmc.2zphwshxw2ejh2znevhod0u01?playableId=tvs.sbd.9001%3A1688506685"
    ]
  }),
  //Atypical:
  Sd(id: 1, streamId: 1, streamOn: {
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
  Sd(id: 2, streamId: 2, streamOn: {
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
  Sd(id: 3, streamId: 3, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/950149"]
  }, rent: {
    "Logo": [image.prime, image.appleTv],
    "Platform": ["Prime €3,99", "Apple TV €3,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0RE2IA11PBYW09G116R4E6Q31H/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/sieben/umc.cmc.22qs2aqmay2k78k4ne4y9br2c?playableId=tvs.sbd.9001%3A448163296"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv],
    "Platform": ["Prime €9,99", "Apple TV €9,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0RE2IA11PBYW09G116R4E6Q31H/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/sieben/umc.cmc.22qs2aqmay2k78k4ne4y9br2c?playableId=tvs.sbd.9001%3A448163296"
    ]
  }),
  //Demon Slayer: Kimetsu no Yaiba:
  Sd(id: 4, streamId: 4, streamOn: {
    "Logo": [image.netflix, image.prime, image.crunchyroll],
    "Platform": ["Netflix", "Prime", "Crunchyroll"],
    "Link": [
      "https://www.netflix.com/de/title/81091393",
      "https://www.amazon.de/gp/video/detail/0OO5RDWV6Y8OS05DY80LAOGRKK/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://www.crunchyroll.com/de/watch/GRG5JD92R/cruelty?irclickid=zbkwR01E1xyNUiqVqVVaMziqUkFS7MU1kRwcRM0&irgwc=1"
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
  //Knives Out:
  Sd(id: 5, streamId: 5, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/81037684"]
  }, rent: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €3,99", "Prime €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/knives-out---mord-ist-familiensache/umc.cmc.21f7rjslttoalzd6o9c6cg5ml?playableId=tvs.sbd.9001%3A1491177721",
      "https://www.amazon.de/gp/video/detail/0STC0IYO0HN9D8RQTUSQUMWG71/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }, buy: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €7,99", "Prime €7,99"],
    "Link": [
      "https://tv.apple.com/de/movie/knives-out---mord-ist-familiensache/umc.cmc.21f7rjslttoalzd6o9c6cg5ml?playableId=tvs.sbd.9001%3A1491177721",
      "https://www.amazon.de/gp/video/detail/0STC0IYO0HN9D8RQTUSQUMWG71/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }),
  //The Conjuring 2:
  Sd(id: 6, streamId: 6, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/80091246"]
  }, rent: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €3,99", "Prime €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/conjuring-2/umc.cmc.5a5wi1nskrsbcg5pti8ep10d?playableId=tvs.sbd.9001%3A1123714931",
      "https://www.amazon.de/gp/video/detail/0TEJF138ZN8ERHN9BJX4MCYETM/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }, buy: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €9,99", "Prime €9,99"],
    "Link": [
      "https://tv.apple.com/de/movie/conjuring-2/umc.cmc.5a5wi1nskrsbcg5pti8ep10d?playableId=tvs.sbd.9001%3A1123714931",
      "https://www.amazon.de/gp/video/detail/0TEJF138ZN8ERHN9BJX4MCYETM/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }),
  //Ted Lasso:
  Sd(id: 7, streamId: 7, streamOn: {
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
  Sd(id: 8, streamId: 8, streamOn: {
    "Logo": [image.disneyPlus],
    "Platform": ["Disney+"],
    "Link": ["https://www.disneyplus.com/de-de/movies/maze-runner-die-auserwahlten-im-labyrinth/5eMMEyNl6tWG?irclickid=VfP3CZxx0xyPTg%3AV9Mwcc0e-UkH008VJkRwcRM0&irgwc=1&cid=DSS-Affiliate-Impact-Content-JustWatch+GmbH-705874&tgclid=04010022-ac11-4e05-bd00-1576657a2c0c&dclid=CNX6ipW3jYMDFWCS_QcdUvUM2w"]
  }, rent: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €3,99", "Prime €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/maze-runner---die-auserwahlten-im-labyrinth/umc.cmc.4ljr4z86mfhtbdouv5ml5h693?playableId=tvs.sbd.9001%3A919198535",
      "https://www.amazon.de/gp/video/detail/0HX2AL1JXHLS8ZOM4EPW5JFV5V/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }, buy: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €9,99", "Prime €9,99"],
    "Link": [
      "https://tv.apple.com/de/movie/maze-runner---die-auserwahlten-im-labyrinth/umc.cmc.4ljr4z86mfhtbdouv5ml5h693?playableId=tvs.sbd.9001%3A919198535",
      "https://www.amazon.de/gp/video/detail/0HX2AL1JXHLS8ZOM4EPW5JFV5V/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }),
  //Dahmer - Monster: The Jeffrey Dahmer Story:
  Sd(id: 9,
  streamId: 9,
  streamOn: {
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
  Sd(id: 10, streamId: 10, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/81002747"]
  }, rent: {
    "Logo": [image.prime, image.appleTv, image.skyGo],
    "Platform": ["Prime €3,98", "Apple TV €3,99", "SkyGo €3,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0O2SSA8EE8BYL2EI1DE0HG8XS4/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-a-new-universe/umc.cmc.4a2ypxddplsdsahwxrc5fkz4x?playableId=tvs.sbd.9001%3A1447687300",
      "https://store.sky.de/product/spider-man-a-new-universe/0a599b73-6c83-4247-9a57-b4f915b6a088"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv, image.skyGo],
    "Platform": ["Prime €9,99", "Apple TV €9,99", "SkyGo €9,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0O2SSA8EE8BYL2EI1DE0HG8XS4/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-a-new-universe/umc.cmc.4a2ypxddplsdsahwxrc5fkz4x?playableId=tvs.sbd.9001%3A1447687300",
      "https://store.sky.de/product/spider-man-a-new-universe/0a599b73-6c83-4247-9a57-b4f915b6a088"
    ]
  }),
  //One Piece:
  Sd(id: 11, streamId: 11, streamOn: {
    "Logo": [image.crunchyroll],
    "Platform": ["Crunchyroll"],
    "Link": ["https://www.crunchyroll.com/de/watch/GR3VWXP96/im-luffy-the-man-whos-gonna-be-king-of-the-pirates?irclickid=zbkwR01E1xyNUiqVqVVaMziqUkH0xxQxkRwcRM0&irgwc=1"]
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
