import 'package:stream_me/android/app/src/model/hd_model.dart';
import '../../src/utils/images.dart';

final Images image = Images();

final allSd = <Hd>[
  //Spider-Man: Across the Spider-Verse:
  Hd(id: 0, streamId: 0, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/"]
  }, rent: {
    "Logo": [image.prime, image.appleTv, image.skyGo],
    "Provider": ["Prime €4,99", "Apple TV €4,99", "Sky Go €4,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0N7EAU0Y85VI5OO04TYKSXL85T/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-across-the-spider-verse/umc.cmc.2zphwshxw2ejh2znevhod0u01?playableId=tvs.sbd.9001%3A1688506685"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv, image.skyGo],
    "Provider": ["Prime €13,99", "Apple TV €13,99", "Sky Go €13,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0N7EAU0Y85VI5OO04TYKSXL85T/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-across-the-spider-verse/umc.cmc.2zphwshxw2ejh2znevhod0u01?playableId=tvs.sbd.9001%3A1688506685",
      "https://store.sky.de/product/spider-man-across-the-spider-verse/c108f8b3-ca7f-4032-ac70-20b83c7c477b"
    ]
  }),
  //Atypical:
  Hd(id: 1, streamId: 1, streamOn: {
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
  Hd(id: 2, streamId: 2, streamOn: {
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
  Hd(id: 3, streamId: 3, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/950149"]
  }, rent: {
    "Logo": [image.prime, image.appleTv, image.skyGo, image.magentaTv],
    "Platform": [
      "Prime €3,99",
      "Apple TV €3,99",
      "Sky Go €3,99",
      "Magenta TV €3,99"
    ],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0RE2IA11PBYW09G116R4E6Q31H/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/sieben/umc.cmc.22qs2aqmay2k78k4ne4y9br2c?playableId=tvs.sbd.9001%3A448163296",
      "https://store.sky.de/product/sieben/e9d40800-4167-4d44-8460-bb5150f3c72e",
      "https://www.telekom.de/start"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv, image.skyGo, image.magentaTv],
    "Platform": [
      "Prime €9,99",
      "Apple TV €9,99",
      "Sky Go €9,99",
      "Magenta TV €9,99"
    ],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0RE2IA11PBYW09G116R4E6Q31H/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/sieben/umc.cmc.22qs2aqmay2k78k4ne4y9br2c?playableId=tvs.sbd.9001%3A448163296",
      "https://store.sky.de/product/sieben/e9d40800-4167-4d44-8460-bb5150f3c72e",
      "https://www.telekom.de/start"
    ]
  }),
  //Demon Slayer: Kimetsu no Yaiba:
  Hd(id: 4, streamId: 4, streamOn: {
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
  Hd(id: 5, streamId: 5, streamOn: {
    "Logo": [image.netflix, image.skyGo, image.magentaTv],
    "Platform": ["Netflix", "SkyGo", "Magenta TV"],
    "Link": [
      "https://www.netflix.com/de/title/81037684",
      "https://www.sky.de/angebote?ptabId=j-p-tab-aktuelle-angebote-fiction&wkz=WDPRF28&eml=ADGapID_026_800138_549711014-505030906:P376637279:A567890286:C200050466&extLi=30657164&dclid=CNTh14X4ioMDFfSJ_QcdxFYNhQ&et_uk=ed99f18b8cb849ae9bbe9f3dd09f30d1&et_gk=YmM5ZTIyZWE5OTJhNDk5MzkzM2M3NmFlYTU1ODM5ZGYlN0MxMC4wMi4yMDI0KzIyJTNBMjMlM0E0MQ",
      "https://www.telekom.de/start"
    ]
  }, rent: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €3,99", "Prime €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/knives-out---mord-ist-familiensache/umc.cmc.21f7rjslttoalzd6o9c6cg5ml?playableId=tvs.sbd.9001%3A1491177721",
      "https://www.amazon.de/gp/video/detail/0STC0IYO0HN9D8RQTUSQUMWG71/ref=atv_dl_rdr?tag=justdersjd-21"
    ]
  }, buy: {
    "Logo": [image.appleTv],
    "Platform": ["Apple TV €9,99"],
    "Link": [
      "https://tv.apple.com/de/movie/knives-out---mord-ist-familiensache/umc.cmc.21f7rjslttoalzd6o9c6cg5ml?playableId=tvs.sbd.9001%3A1491177721"
    ]
  }),
  //The Conjuring 2:
  Hd(id: 6, streamId: 6, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/80091246"]
  }, rent: {
    "Logo": [image.appleTv, image.prime, image.skyGo, image.magentaTv],
    "Platform": ["Apple TV €3,99", "Prime €3,99", "Sky Go €3,99", "Magenta TV €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/conjuring-2/umc.cmc.5a5wi1nskrsbcg5pti8ep10d?playableId=tvs.sbd.9001%3A1123714931",
      "https://www.amazon.de/gp/video/detail/0TEJF138ZN8ERHN9BJX4MCYETM/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://store.sky.de/product/conjuring-2/4fb34771-b1e8-4af6-8160-3136a07f3534",
      "https://www.telekom.de/start"
    ]
  }, buy: {
    "Logo": [image.appleTv, image.prime],
    "Platform": ["Apple TV €9,99", "Prime €9,99", "Sky Go €9,99", "Magenta TV €9,99"],
    "Link": [
      "https://tv.apple.com/de/movie/conjuring-2/umc.cmc.5a5wi1nskrsbcg5pti8ep10d?playableId=tvs.sbd.9001%3A1123714931",
      "https://www.amazon.de/gp/video/detail/0TEJF138ZN8ERHN9BJX4MCYETM/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://store.sky.de/product/conjuring-2/4fb34771-b1e8-4af6-8160-3136a07f3534",
      "https://www.telekom.de/start"
    ]
  }),
  //Ted Lasso:
  Hd(id: 7, streamId: 7, streamOn: {
    "Logo": [image.appleTvPlus],
    "Platform": ["Apple TV+"],
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
  //The Maze Runner:
  Hd(id: 8, streamId: 8, streamOn: {
    "Logo": [image.disneyPlus],
    "Platform": ["Disney+"],
    "Link": ["https://www.disneyplus.com/de-de/movies/maze-runner-die-auserwahlten-im-labyrinth/5eMMEyNl6tWG?irclickid=VfP3CZxx0xyPTg%3AV9Mwcc0e-UkH008VJkRwcRM0&irgwc=1&cid=DSS-Affiliate-Impact-Content-JustWatch+GmbH-705874&tgclid=04010022-ac11-4e05-bd00-1576657a2c0c&dclid=CNX6ipW3jYMDFWCS_QcdUvUM2w"]
  }, rent: {
    "Logo": [image.appleTv, image.prime, image.skyGo],
    "Platform": ["Apple TV €3,99", "Prime €3,99", "SkyGo €3,99"],
    "Link": [
      "https://tv.apple.com/de/movie/maze-runner---die-auserwahlten-im-labyrinth/umc.cmc.4ljr4z86mfhtbdouv5ml5h693?playableId=tvs.sbd.9001%3A919198535",
      "https://www.amazon.de/gp/video/detail/0HX2AL1JXHLS8ZOM4EPW5JFV5V/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://store.sky.de/product/maze-runner-die-auserwahlten-im-labyrinth/57ec870c-0251-4dda-9895-e412e20ac407"
    ]
  }, buy: {
    "Logo": [image.appleTv, image.prime, image.skyGo],
    "Platform": ["Apple TV €9,99", "Prime €9,99", "SkyGo €19,99"],
    "Link": [
      "https://tv.apple.com/de/movie/maze-runner---die-auserwahlten-im-labyrinth/umc.cmc.4ljr4z86mfhtbdouv5ml5h693?playableId=tvs.sbd.9001%3A919198535",
      "https://www.amazon.de/gp/video/detail/0HX2AL1JXHLS8ZOM4EPW5JFV5V/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://store.sky.de/product/maze-runner-die-auserwahlten-im-labyrinth/57ec870c-0251-4dda-9895-e412e20ac407"
    ]
  }),
  //Dahmer - Monster: The Jeffrey Dahmer Story:
  Hd(id: 9, streamId: 9, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
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
  //Spider-Man: Into the Spider-Verse:
  Hd(id: 10, streamId: 10, streamOn: {
    "Logo": [image.netflix],
    "Platform": ["Netflix"],
    "Link": ["https://www.netflix.com/de/title/81002747"]
  }, rent: {
    "Logo": [image.prime, image.appleTv, image.magentaTv],
    "Platform": ["Prime €3,98", "Apple TV €3,99", "Sky Go €3,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0O2SSA8EE8BYL2EI1DE0HG8XS4/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-a-new-universe/umc.cmc.4a2ypxddplsdsahwxrc5fkz4x?playableId=tvs.sbd.9001%3A1447687300"
      "https://store.sky.de/product/spider-man-a-new-universe/0a599b73-6c83-4247-9a57-b4f915b6a088"
    ]
  }, buy: {
    "Logo": [image.prime, image.appleTv, image.magentaTv],
    "Platform": ["Prime €9,99", "Apple TV €9,99", "Sky Go €9,99"],
    "Link": [
      "https://www.amazon.de/gp/video/detail/0O2SSA8EE8BYL2EI1DE0HG8XS4/ref=atv_dl_rdr?tag=justdersjd-21",
      "https://tv.apple.com/de/movie/spider-man-a-new-universe/umc.cmc.4a2ypxddplsdsahwxrc5fkz4x?playableId=tvs.sbd.9001%3A1447687300"
      "https://store.sky.de/product/spider-man-a-new-universe/0a599b73-6c83-4247-9a57-b4f915b6a088"
    ]
  }),
  //One Piece:
  Hd(id: 11, streamId: 11, streamOn: {
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
