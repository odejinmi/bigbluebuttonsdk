import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/Drawnpath.dart';
import '../view/annotations.dart';
import 'websocket.dart';

class Whiteboardcontroller extends GetxController{
  String jsonData = '''{"lines":[{"points":[{"x":202.16864013671875,"y":83.83525085449219,"pressure":0.5},{"x":202.16864013671875,"y":88.68904113769531,"pressure":0.5},{"x":202.16864013671875,"y":104.09542846679688,"pressure":0.5},{"x":202.16864013671875,"y":121.39901733398438,"pressure":0.5},{"x":202.16864013671875,"y":130.31289672851562,"pressure":0.5},{"x":202.16864013671875,"y":172.6826171875,"pressure":0.5},{"x":202.16864013671875,"y":203.68963623046875,"pressure":0.5},{"x":202.16864013671875,"y":215.6309814453125,"pressure":0.5},{"x":202.16864013671875,"y":241.62667846679688,"pressure":0.5},{"x":202.16864013671875,"y":269.10052490234375,"pressure":0.5},{"x":203.4683837890625,"y":295.0962219238281,"pressure":0.5},{"x":207.039794921875,"y":316.52471923828125,"pressure":0.5},{"x":211.58355712890625,"y":335.8355712890625,"pressure":0.5},{"x":217.26318359375,"y":355.1464538574219,"pressure":0.5},{"x":222.39862060546875,"y":370.5528564453125,"pressure":0.5},{"x":224.344482421875,"y":375.7418212890625,"pressure":0.5},{"x":229.531005859375,"y":385.25042724609375,"pressure":0.5},{"x":236.87957763671875,"y":395.35467529296875,"pressure":0.5},{"x":243.794921875,"y":403.13446044921875,"pressure":0.5},{"x":249.8458251953125,"y":407.672607421875,"pressure":0.5},{"x":256.16790771484375,"y":410.482421875,"pressure":0.5},{"x":269.7869873046875,"y":414.37359619140625,"pressure":0.5},{"x":278.58856201171875,"y":414.37359619140625,"pressure":0.5},{"x":292.2076416015625,"y":414.37359619140625,"pressure":0.5},{"x":304.85394287109375,"y":408.536865234375,"pressure":0.5},{"x":332.6763916015625,"y":389.50042724609375,"pressure":0.5},{"x":342.404296875,"y":379.77252197265625,"pressure":0.5},{"x":362.626953125,"y":359.5499267578125,"pressure":0.5},{"x":379.524169921875,"y":338.75335693359375,"pressure":0.5},{"x":396.43701171875,"y":311.9745788574219,"pressure":0.5},{"x":411.337158203125,"y":287.592529296875,"pressure":0.5},{"x":424.8826904296875,"y":261.85595703125,"pressure":0.5},{"x":435.281005859375,"y":237.1600341796875,"pressure":0.5},{"x":444.3795166015625,"y":212.46417236328125,"pressure":0.5},{"x":446.000244140625,"y":203.55029296875,"pressure":0.5},{"x":450.3260498046875,"y":186.2467041015625,"pressure":0.5},{"x":453.4073486328125,"y":170.84030151367188,"pressure":0.5},{"x":454.0560302734375,"y":165.65130615234375,"pressure":0.5},{"x":454.8123779296875,"y":158.08767700195312,"pressure":0.5},{"x":455.5147705078125,"y":151.76556396484375,"pressure":0.5},{"x":455.5147705078125,"y":148.51840209960938,"pressure":0.5},{"x":455.5147705078125,"y":146.08038330078125,"pressure":0.5},{"x":452.0504150390625,"y":151.0933837890625,"pressure":0.5},{"x":446.64306640625,"y":168.39697265625,"pressure":0.5},{"x":440.4176025390625,"y":192.05364990234375,"pressure":0.5},{"x":432.54541015625,"y":231.41461181640625,"pressure":0.5},{"x":423.8446044921875,"y":280.13946533203125,"pressure":0.5},{"x":418.2913818359375,"y":335.671142578125,"pressure":0.5},{"x":412.4046630859375,"y":398.4632568359375,"pressure":0.5},{"x":408.7025146484375,"y":453.994873046875,"pressure":0.5},{"x":407.45751953125,"y":477.651611328125,"pressure":0.5},{"x":407.45751953125,"y":523.1425170898438,"pressure":0.5},{"x":407.45751953125,"y":536.7615966796875,"pressure":0.5},{"x":407.45751953125,"y":562.7572631835938,"pressure":0.5},{"x":407.45751953125,"y":569.079345703125,"pressure":0.5},{"x":407.45751953125,"y":582.6984252929688,"pressure":0.5},{"x":407.45751953125,"y":591.6123046875,"pressure":0.5},{"x":407.45751953125,"y":595.7763671875,"pressure":0.5},{"x":407.9986572265625,"y":599.0235595703125,"pressure":0.5},{"x":409.9490966796875,"y":600.9739990234375,"pressure":0.5},{"x":414.1131591796875,"y":601.56884765625,"pressure":0.5},{"x":419.3021240234375,"y":601.56884765625,"pressure":0.5},{"x":434.4427490234375,"y":591.8355712890625,"pressure":0.5},{"x":451.8740234375,"y":575.6494140625,"pressure":0.5},{"x":472.1923828125,"y":555.3310546875,"pressure":0.5},{"x":498.957763671875,"y":525.416748046875,"pressure":0.5},{"x":527.6002197265625,"y":488.35003662109375,"pressure":0.5},{"x":557.1832275390625,"y":448.3260498046875,"pressure":0.5},{"x":583.2857666015625,"y":406.5618896484375,"pressure":0.5},{"x":605.9080810546875,"y":363.05755615234375,"pressure":0.5},{"x":613.859619140625,"y":344.88262939453125,"pressure":0.5},{"x":629.0531005859375,"y":311.4569091796875,"pressure":0.5},{"x":640.328369140625,"y":281.85931396484375,"pressure":0.5},{"x":642.921630859375,"y":271.48626708984375,"pressure":0.5},{"x":647.4437255859375,"y":252.26715087890625,"pressure":0.5},{"x":648.0924072265625,"y":247.07818603515625,"pressure":0.5},{"x":650.5234375,"y":238.164306640625,"pressure":0.5},{"x":651.1719970703125,"y":232.97531127929688,"pressure":0.5},{"x":651.7132568359375,"y":229.7281494140625,"pressure":0.5},{"x":651.7132568359375,"y":227.29013061523438,"pressure":0.5},{"x":648.1920166015625,"y":228.37249755859375,"pressure":0.5},{"x":635.69677734375,"y":243.1396484375,"pressure":0.5},{"x":622.6015625,"y":260.9967041015625,"pressure":0.5},{"x":607.701416015625,"y":286.73333740234375,"pressure":0.5},{"x":598.614013671875,"y":303.7723388671875,"pressure":0.5},{"x":583.9705810546875,"y":334.52349853515625,"pressure":0.5},{"x":571.285888671875,"y":364.12109375,"pressure":0.5},{"x":561.803955078125,"y":391.2122802734375,"pressure":0.5},{"x":559.3729248046875,"y":400.1260986328125,"pressure":0.5},{"x":558.6705322265625,"y":406.4482421875,"pressure":0.5},{"x":556.8333740234375,"y":418.38958740234375,"pressure":0.5},{"x":555.751953125,"y":435.69317626953125,"pressure":0.5},{"x":555.751953125,"y":440.88214111328125,"pressure":0.5},{"x":559.53369140625,"y":447.689453125,"pressure":0.5},{"x":568.4476318359375,"y":450.1204833984375,"pressure":0.5},{"x":580.388916015625,"y":451.9576416015625,"pressure":0.5},{"x":608.834716796875,"y":451.9576416015625,"pressure":0.5},{"x":635.037109375,"y":451.9576416015625,"pressure":0.5},{"x":648.6561279296875,"y":450.0120849609375,"pressure":0.5},{"x":674.65185546875,"y":443.51312255859375,"pressure":0.5},{"x":706.8673095703125,"y":433.26275634765625,"pressure":0.5},{"x":733.95849609375,"y":422.42626953125,"pressure":0.5},{"x":758.6544189453125,"y":412.02801513671875,"pressure":0.5},{"x":765.947509765625,"y":406.3555908203125,"pressure":0.5},{"x":782.986572265625,"y":396.13214111328125,"pressure":0.5},{"x":795.3116455078125,"y":385.8612060546875,"pressure":0.5},{"x":805.03955078125,"y":375.1605224609375,"pressure":0.5},{"x":812.3880615234375,"y":365.05633544921875,"pressure":0.5},{"x":816.710205078125,"y":355.5477294921875,"pressure":0.5},{"x":819.1412353515625,"y":346.63385009765625,"pressure":0.5},{"x":820.22265625,"y":329.33026123046875,"pressure":0.5},{"x":820.22265625,"y":320.4163818359375,"pressure":0.5},{"x":812.8741455078125,"y":310.3121337890625,"pressure":0.5},{"x":794.1978759765625,"y":294.1260070800781,"pressure":0.5},{"x":783.8248291015625,"y":291.5327453613281,"pressure":0.5},{"x":764.513916015625,"y":285.85308837890625,"pressure":0.5},{"x":740.8572998046875,"y":283.3629150390625,"pressure":0.5},{"x":717.2999267578125,"y":283.3629150390625,"pressure":0.5},{"x":693.6431884765625,"y":283.3629150390625,"pressure":0.5},{"x":685.5396728515625,"y":287.4146728515625,"pressure":0.5},{"x":669.317626953125,"y":293.90350341796875,"pressure":0.5},{"x":664.400390625,"y":298.11822509765625,"pressure":0.5},{"x":656.296875,"y":302.9803466796875,"pressure":0.5},{"x":650.2459716796875,"y":307.5185546875,"pressure":0.5},{"x":646.6767578125,"y":309.89801025390625,"pressure":0.5},{"x":644.726318359375,"y":311.848388671875,"pressure":0.5},{"x":650.1077880859375,"y":311.739013671875,"pressure":0.5},{"x":662.754150390625,"y":304.92950439453125,"pressure":0.5},{"x":673.77685546875,"y":299.4180908203125,"pressure":0.5},{"x":694.943359375,"y":288.2122802734375,"pressure":0.5},{"x":718.3394775390625,"y":276.5142517089844,"pressure":0.5},{"x":739.5059814453125,"y":265.3084716796875,"pressure":0.5},{"x":749.0146484375,"y":260.1219482421875,"pressure":0.5},{"x":766.0535888671875,"y":249.89852905273438,"pressure":0.5},{"x":770.593994140625,"y":246.6553955078125,"pressure":0.5},{"x":780.1026611328125,"y":241.4688720703125,"pressure":0.5},{"x":785.7222900390625,"y":237.95660400390625,"pressure":0.5},{"x":789.29150390625,"y":235.5771484375,"pressure":0.5},{"x":791.2418212890625,"y":234.11434936523438,"pressure":0.5},{"x":775.0277099609375,"y":232.91180419921875,"pressure":0.5},{"x":757.72412109375,"y":233.99325561523438,"pressure":0.5},{"x":729.2784423828125,"y":240.76605224609375,"pressure":0.5},{"x":695.5985107421875,"y":248.08773803710938,"pressure":0.5},{"x":676.2877197265625,"y":252.6314697265625,"pressure":0.5},{"x":639.8232421875,"y":261.74755859375,"pressure":0.5},{"x":606.1434326171875,"y":270.5335998535156,"pressure":0.5},{"x":595.7703857421875,"y":273.1268615722656,"pressure":0.5},{"x":574.3419189453125,"y":280.2696838378906,"pressure":0.5},{"x":568.019775390625,"y":282.3770446777344,"pressure":0.5},{"x":556.9969482421875,"y":286.9698486328125,"pressure":0.5},{"x":550.6749267578125,"y":289.07720947265625,"pressure":0.5},{"x":546.5587158203125,"y":290.8412780761719,"pressure":0.5},{"x":544.1207275390625,"y":291.81646728515625,"pressure":0.5},{"x":552.3543701171875,"y":290.31396484375,"pressure":0.5},{"x":565.70654296875,"y":282.09722900390625,"pressure":0.5},{"x":585.6279296875,"y":268.4012451171875,"pressure":0.5},{"x":610.010009765625,"y":252.14657592773438,"pressure":0.5},{"x":623.3621826171875,"y":242.90274047851562,"pressure":0.5},{"x":648.7315673828125,"y":224.58041381835938,"pressure":0.5},{"x":672.6915283203125,"y":204.84869384765625,"pressure":0.5},{"x":680.4713134765625,"y":197.06890869140625,"pressure":0.5},{"x":695.238525390625,"y":183.43768310546875,"pressure":0.5},{"x":699.4532470703125,"y":178.5205078125,"pressure":0.5},{"x":706.8017578125,"y":168.41632080078125,"pressure":0.5},{"x":712.0963134765625,"y":162.36538696289062,"pressure":0.5},{"x":714.6907958984375,"y":157.82501220703125,"pressure":0.5},{"x":716.095703125,"y":151.5029296875,"pressure":0.5},{"x":716.095703125,"y":148.2557373046875,"pressure":0.5},{"x":711.178466796875,"y":143.33856201171875,"pressure":0.5},{"x":693.8748779296875,"y":141.17562866210938,"pressure":0.5},{"x":667.8792724609375,"y":141.17562866210938,"pressure":0.5},{"x":605.3206787109375,"y":141.17562866210938,"pressure":0.5},{"x":576.875,"y":146.5938720703125,"pressure":0.5},{"x":473.4365234375,"y":176.86849975585938,"pressure":0.5},{"x":442.6854248046875,"y":191.51190185546875,"pressure":0.5},{"x":376.324951171875,"y":220.54458618164062,"pressure":0.5},{"x":312.03826904296875,"y":251.65103149414062,"pressure":0.5},{"x":249.82537841796875,"y":286.905029296875,"pressure":0.5},{"x":198.3468017578125,"y":317.41082763671875,"pressure":0.5},{"x":179.29925537109375,"y":329.3155517578125,"pressure":0.5},{"x":164.1585693359375,"y":337.96734619140625,"pressure":0.5},{"x":135.97039794921875,"y":353.4708557128906,"pressure":0.5},{"x":130.78143310546875,"y":356.0653381347656,"pressure":0.5},{"x":118.1351318359375,"y":361.9020690917969,"pressure":0.5},{"x":111.81304931640625,"y":364.7119140625,"pressure":0.5},{"x":107.64892578125,"y":365.901611328125,"pressure":0.5},{"x":104.40179443359375,"y":366.44281005859375,"pressure":0.5},{"x":104.40179443359375,"y":351.08740234375,"pressure":0.5},{"x":113.925537109375,"y":330.849365234375,"pressure":0.5},{"x":126.1165771484375,"y":305.11279296875,"pressure":0.5},{"x":132.92608642578125,"y":292.46649169921875,"pressure":0.5},{"x":137.48284912109375,"y":280.618896484375,"pressure":0.5},{"x":141.53460693359375,"y":272.515380859375,"pressure":0.5},{"x":147.371337890625,"y":259.86907958984375,"pressure":0.5},{"x":150.61273193359375,"y":250.9552001953125,"pressure":0.5},{"x":152.55859375,"y":245.7662353515625,"pressure":0.5},{"x":153.74835205078125,"y":241.60214233398438,"pressure":0.5},{"x":153.74835205078125,"y":237.43804931640625,"pressure":0.5},{"x":139.802001953125,"y":236.78350830078125,"pressure":0.5},{"x":124.3956298828125,"y":236.78350830078125,"pressure":0.5},{"x":102.03240966796875,"y":245.48028564453125,"pressure":0.5},{"x":72.43475341796875,"y":258.16497802734375,"pressure":0.5},{"x":41.68359375,"y":272.80841064453125,"pressure":0.5},{"x":28.3314208984375,"y":281.025146484375,"pressure":0.5},{"x":16.657958984375,"y":288.80743408203125,"pressure":0.5}],"color":4278190080,"width":5.0},{"points":[{"x":183.681884765625,"y":529.5870361328125,"pressure":0.5},{"x":183.44317626953125,"y":522.0851440429688,"pressure":0.5},{"x":183.44317626953125,"y":514.521484375,"pressure":0.5},{"x":183.44317626953125,"y":502.58013916015625,"pressure":0.5},{"x":184.68829345703125,"y":478.9234619140625,"pressure":0.5},{"x":190.640625,"y":457.4949951171875,"pressure":0.5},{"x":201.47705078125,"y":430.40380859375,"pressure":0.5},{"x":216.9805908203125,"y":402.21563720703125,"pressure":0.5},{"x":237.44830322265625,"y":367.5780029296875,"pressure":0.5},{"x":261.892333984375,"y":331.7266845703125,"pressure":0.5},{"x":291.47528076171875,"y":291.70269775390625,"pressure":0.5},{"x":325.1868896484375,"y":254.61996459960938,"pressure":0.5},{"x":361.098388671875,"y":216.91290283203125,"pressure":0.5},{"x":373.193603515625,"y":206.83352661132812,"pressure":0.5},{"x":400.5418701171875,"y":182.52392578125,"pressure":0.5},{"x":408.6075439453125,"y":177.6845703125,"pressure":0.5},{"x":413.7965087890625,"y":175.090087890625,"pressure":0.5},{"x":427.148681640625,"y":165.84625244140625,"pressure":0.5},{"x":435.252197265625,"y":161.79449462890625,"pressure":0.5},{"x":440.441162109375,"y":159.8486328125,"pressure":0.5},{"x":443.6883544921875,"y":158.7662353515625,"pressure":0.5},{"x":446.1263427734375,"y":158.7662353515625,"pressure":0.5},{"x":448.673095703125,"y":167.68011474609375,"pressure":0.5},{"x":448.673095703125,"y":183.08648681640625,"pressure":0.5},{"x":448.673095703125,"y":211.5322265625,"pressure":0.5},{"x":448.673095703125,"y":247.99661254882812,"pressure":0.5},{"x":443.7843017578125,"y":290.3663330078125,"pressure":0.5},{"x":441.4033203125,"y":311.7948303222656,"pressure":0.5},{"x":439.2403564453125,"y":329.0984191894531,"pressure":0.5},{"x":437.511474609375,"y":339.4714660644531,"pressure":0.5},{"x":434.2982177734375,"y":356.60906982421875,"pressure":0.5},{"x":433.379638671875,"y":368.5504150390625,"pressure":0.5},{"x":431.9747314453125,"y":374.87255859375,"pressure":0.5},{"x":431.9747314453125,"y":378.1197509765625,"pressure":0.5},{"x":434.434326171875,"y":375.42889404296875,"pressure":0.5},{"x":443.6781005859375,"y":362.07666015625,"pressure":0.5},{"x":459.57470703125,"y":338.23187255859375,"pressure":0.5},{"x":482.3648681640625,"y":309.36419677734375,"pressure":0.5},{"x":506.3560791015625,"y":279.375244140625,"pressure":0.5},{"x":518.851318359375,"y":264.6081237792969,"pressure":0.5},{"x":528.5792236328125,"y":254.88021850585938,"pressure":0.5},{"x":533.4964599609375,"y":249.96304321289062,"pressure":0.5},{"x":545.392578125,"y":236.9853515625,"pressure":0.5},{"x":551.87548828125,"y":230.50253295898438,"pressure":0.5},{"x":555.7672119140625,"y":226.61077880859375,"pressure":0.5},{"x":557.717529296875,"y":224.660400390625,"pressure":0.5},{"x":559.5072021484375,"y":226.01611328125,"pressure":0.5},{"x":559.5072021484375,"y":236.31222534179688,"pressure":0.5},{"x":557.5616455078125,"y":249.9312744140625,"pressure":0.5},{"x":555.2926025390625,"y":257.49493408203125,"pressure":0.5},{"x":554.69775390625,"y":261.6590270996094,"pressure":0.5},{"x":552.6561279296875,"y":267.7839050292969,"pressure":0.5},{"x":552.0074462890625,"y":272.972900390625,"pressure":0.5},{"x":552.0074462890625,"y":275.410888671875,"pressure":0.5},{"x":552.0074462890625,"y":277.848876953125,"pressure":0.5},{"x":559.5711669921875,"y":276.61016845703125,"pressure":0.5},{"x":572.4609375,"y":267.68646240234375,"pressure":0.5},{"x":583.4837646484375,"y":261.25653076171875,"pressure":0.5},{"x":600.522705078125,"y":251.03311157226562,"pressure":0.5},{"x":607.3299560546875,"y":247.25128173828125,"pressure":0.5},{"x":611.494140625,"y":245.4666748046875,"pressure":0.5},{"x":619.59765625,"y":241.4149169921875,"pressure":0.5},{"x":624.78662109375,"y":238.8204345703125,"pressure":0.5},{"x":628.0338134765625,"y":237.73806762695312,"pressure":0.5},{"x":630.4718017578125,"y":237.25048828125,"pressure":0.5},{"x":632.5887451171875,"y":238.39239501953125,"pressure":0.5},{"x":632.5887451171875,"y":250.333740234375,"pressure":0.5},{"x":632.5887451171875,"y":262.2751159667969,"pressure":0.5},{"x":632.5887451171875,"y":281.48944091796875,"pressure":0.5},{"x":631.670166015625,"y":293.4308166503906,"pressure":0.5},{"x":630.913818359375,"y":300.99444580078125,"pressure":0.5},{"x":630.0667724609375,"y":311.15899658203125,"pressure":0.5},{"x":628.5540771484375,"y":318.72265625,"pressure":0.5},{"x":628.5540771484375,"y":323.91162109375,"pressure":0.5},{"x":628.5540771484375,"y":327.13861083984375,"pressure":0.5},{"x":628.1199951171875,"y":330.0168762207031,"pressure":0.5},{"x":628.1199951171875,"y":335.1185607910156,"pressure":0.5},{"x":628.1199951171875,"y":338.36572265625,"pressure":0.5},{"x":628.1199951171875,"y":343.5547180175781,"pressure":0.5},{"x":628.6068115234375,"y":345.9891052246094,"pressure":0.5},{"x":629.20166015625,"y":350.1531982421875,"pressure":0.5},{"x":629.6893310546875,"y":352.5911865234375,"pressure":0.5},{"x":630.5040283203125,"y":355.4694519042969,"pressure":0.5},{"x":633.7095947265625,"y":356.504638671875,"pressure":0.5},{"x":637.8736572265625,"y":355.9097900390625,"pressure":0.5},{"x":643.924560546875,"y":350.615234375,"pressure":0.5},{"x":648.4649658203125,"y":347.3721008300781,"pressure":0.5},{"x":655.758056640625,"y":341.69964599609375,"pressure":0.5},{"x":658.464111328125,"y":339.53485107421875,"pressure":0.5},{"x":663.00439453125,"y":336.291748046875,"pressure":0.5},{"x":666.5736083984375,"y":333.9122619628906,"pressure":0.5},{"x":669.0115966796875,"y":332.449462890625,"pressure":0.5},{"x":671.889892578125,"y":331.20068359375,"pressure":0.5},{"x":674.1739501953125,"y":333.638671875,"pressure":0.5},{"x":674.87646484375,"y":339.96075439453125,"pressure":0.5},{"x":675.5250244140625,"y":345.1497497558594,"pressure":0.5},{"x":676.2813720703125,"y":352.71337890625,"pressure":0.5},{"x":676.76904296875,"y":355.1513977050781,"pressure":0.5},{"x":677.4176025390625,"y":360.34039306640625,"pressure":0.5},{"x":677.9588623046875,"y":363.5875244140625,"pressure":0.5},{"x":678.9339599609375,"y":366.02557373046875,"pressure":0.5},{"x":679.7486572265625,"y":368.90380859375,"pressure":0.5},{"x":680.3436279296875,"y":373.06787109375,"pressure":0.5},{"x":682.6126708984375,"y":380.63153076171875,"pressure":0.5},{"x":684.4498291015625,"y":392.5728759765625,"pressure":0.5},{"x":685.422607421875,"y":406.19195556640625,"pressure":0.5},{"x":687.6944580078125,"y":425.5028076171875,"pressure":0.5},{"x":688.9859619140625,"y":451.33233642578125,"pressure":0.5},{"x":690.28564453125,"y":477.3280029296875,"pressure":0.5},{"x":691.2042236328125,"y":489.2694091796875,"pressure":0.5},{"x":691.2042236328125,"y":510.6978759765625,"pressure":0.5},{"x":691.2042236328125,"y":517.02001953125,"pressure":0.5},{"x":691.2042236328125,"y":528.9613647460938,"pressure":0.5},{"x":691.2042236328125,"y":536.5250244140625,"pressure":0.5},{"x":691.2042236328125,"y":541.7139892578125,"pressure":0.5},{"x":691.2042236328125,"y":544.1494750976562,"pressure":0.5},{"x":690.9302978515625,"y":546.219970703125,"pressure":0.5},{"x":687.6702880859375,"y":546.4939575195312,"pressure":0.5},{"x":680.1065673828125,"y":543.468505859375,"pressure":0.5},{"x":663.884521484375,"y":535.898193359375,"pressure":0.5},{"x":641.54736328125,"y":527.2115478515625,"pressure":0.5},{"x":606.6024169921875,"y":515.0567626953125,"pressure":0.5},{"x":564.232666015625,"y":503.6495361328125,"pressure":0.5},{"x":521.8629150390625,"y":495.50152587890625,"pressure":0.5},{"x":473.1380615234375,"y":488.54083251953125,"pressure":0.5},{"x":433.0283203125,"y":485.56976318359375,"pressure":0.5},{"x":411.599853515625,"y":485.56976318359375,"pressure":0.5},{"x":369.2301025390625,"y":485.56976318359375,"pressure":0.5},{"x":332.7657470703125,"y":485.56976318359375,"pressure":0.5},{"x":296.30133056640625,"y":485.56976318359375,"pressure":0.5},{"x":284.3599853515625,"y":486.48828125,"pressure":0.5},{"x":260.70330810546875,"y":487.7333984375,"pressure":0.5},{"x":241.576416015625,"y":488.8585205078125,"pressure":0.5},{"x":226.1700439453125,"y":488.8585205078125,"pressure":0.5},{"x":212.55096435546875,"y":488.8585205078125,"pressure":0.5},{"x":203.6370849609375,"y":488.8585205078125,"pressure":0.5},{"x":195.5335693359375,"y":484.8067626953125,"pressure":0.5},{"x":189.48260498046875,"y":480.2685546875,"pressure":0.5},{"x":183.8101806640625,"y":472.97540283203125,"pressure":0.5},{"x":177.97344970703125,"y":460.3291015625,"pressure":0.5},{"x":176.13629150390625,"y":448.38775634765625,"pressure":0.5},{"x":176.13629150390625,"y":432.98138427734375,"pressure":0.5},{"x":176.13629150390625,"y":417.574951171875,"pressure":0.5},{"x":188.29107666015625,"y":382.62994384765625,"pressure":0.5},{"x":206.6134033203125,"y":357.26055908203125,"pressure":0.5},{"x":232.4423828125,"y":329.9122314453125,"pressure":0.5},{"x":269.50909423828125,"y":302.95465087890625,"pressure":0.5},{"x":306.989990234375,"y":281.769775390625,"pressure":0.5},{"x":347.7301025390625,"y":265.4737548828125,"pressure":0.5},{"x":367.041015625,"y":262.06597900390625,"pressure":0.5},{"x":403.50537109375,"y":255.98858642578125,"pressure":0.5},{"x":437.1851806640625,"y":255.98858642578125,"pressure":0.5},{"x":465.630859375,"y":255.98858642578125,"pressure":0.5},{"x":489.28759765625,"y":258.478759765625,"pressure":0.5},{"x":508.3350830078125,"y":270.3834533691406,"pressure":0.5},{"x":527.011474609375,"y":286.569580078125,"pressure":0.5},{"x":554.7147216796875,"y":319.16168212890625,"pressure":0.5},{"x":568.7860107421875,"y":347.30426025390625,"pressure":0.5},{"x":580.9407958984375,"y":382.24932861328125,"pressure":0.5},{"x":585.2667236328125,"y":399.55291748046875,"pressure":0.5},{"x":602.927001953125,"y":460.38275146484375,"pressure":0.5},{"x":607.035400390625,"y":475.78912353515625,"pressure":0.5},{"x":609.9537353515625,"y":489.408203125,"pressure":0.5},{"x":615.9061279296875,"y":510.836669921875,"pressure":0.5},{"x":617.8519287109375,"y":516.0256958007812,"pressure":0.5},{"x":622.4447021484375,"y":527.967041015625,"pressure":0.5},{"x":625.47021484375,"y":535.5307006835938,"pressure":0.5},{"x":632.8187255859375,"y":545.6348876953125,"pressure":0.5},{"x":636.06591796875,"y":547.2584838867188,"pressure":0.5},{"x":643.6295166015625,"y":548.771240234375,"pressure":0.5},{"x":651.1932373046875,"y":548.771240234375,"pressure":0.5},{"x":663.0047607421875,"y":548.771240234375,"pressure":0.5},{"x":678.4111328125,"y":543.6357421875,"pressure":0.5},{"x":694.6331787109375,"y":536.0654296875,"pressure":0.5},{"x":715.7996826171875,"y":524.859619140625,"pressure":0.5},{"x":739.19580078125,"y":511.86181640625,"pressure":0.5},{"x":758.243408203125,"y":499.95709228515625,"pressure":0.5},{"x":765.4970703125,"y":494.3153076171875,"pressure":0.5},{"x":771.11669921875,"y":490.8031005859375,"pressure":0.5},{"x":781.220947265625,"y":484.37310791015625,"pressure":0.5},{"x":787.2718505859375,"y":479.8349609375,"pressure":0.5},{"x":790.841064453125,"y":476.860595703125,"pressure":0.5},{"x":792.7978515625,"y":474.90380859375,"pressure":0.5},{"x":789.583251953125,"y":479.1663818359375,"pressure":0.5},{"x":784.7210693359375,"y":487.2698974609375,"pressure":0.5},{"x":782.1265869140625,"y":492.4588623046875,"pressure":0.5},{"x":778.0748291015625,"y":500.5623779296875,"pressure":0.5},{"x":776.290283203125,"y":504.72650146484375,"pressure":0.5},{"x":774.3443603515625,"y":509.91546630859375,"pressure":0.5},{"x":773.1546630859375,"y":514.07958984375,"pressure":0.5},{"x":772.072265625,"y":517.3267211914062,"pressure":0.5},{"x":772.072265625,"y":520.7993774414062,"pressure":0.5},{"x":780.77783203125,"y":521.1800537109375,"pressure":0.5},{"x":791.15087890625,"y":517.7223510742188,"pressure":0.5},{"x":815.532958984375,"y":501.4676513671875,"pressure":0.5},{"x":836.3294677734375,"y":484.57049560546875,"pressure":0.5},{"x":860.23095703125,"y":463.48095703125,"pressure":0.5},{"x":884.54052734375,"y":436.13262939453125,"pressure":0.5},{"x":892.75732421875,"y":422.78045654296875,"pressure":0.5},{"x":911.793701171875,"y":394.95794677734375,"pressure":0.5},{"x":923.9847412109375,"y":367.8668212890625,"pressure":0.5},{"x":935.260009765625,"y":338.2691955566406,"pressure":0.5}],"color":4278190080,"width":5.0},{"points":[{"x":92.19000244140625,"y":103.57820129394531,"pressure":0.5},{"x":94.25140380859375,"y":103.57820129394531,"pressure":0.5},{"x":96.68939208984375,"y":103.57820129394531,"pressure":0.5},{"x":100.85345458984375,"y":103.57820129394531,"pressure":0.5},{"x":104.10064697265625,"y":103.57820129394531,"pressure":0.5},{"x":108.2647705078125,"y":103.57820129394531,"pressure":0.5},{"x":113.4537353515625,"y":103.57820129394531,"pressure":0.5},{"x":118.6427001953125,"y":103.57820129394531,"pressure":0.5},{"x":123.8316650390625,"y":104.22682189941406,"pressure":0.5},{"x":130.14935302734375,"y":104.92878723144531,"pressure":0.5},{"x":139.063232421875,"y":107.35986328125,"pressure":0.5},{"x":146.5987548828125,"y":108.1134033203125,"pressure":0.5},{"x":155.51263427734375,"y":110.54443359375,"pressure":0.5},{"x":164.0321044921875,"y":112.09344482421875,"pressure":0.5},{"x":172.94598388671875,"y":113.714111328125,"pressure":0.5},{"x":183.31903076171875,"y":116.307373046875,"pressure":0.5},{"x":193.69207763671875,"y":118.03622436523438,"pressure":0.5},{"x":202.60595703125,"y":119.65692138671875,"pressure":0.5},{"x":211.11334228515625,"y":121.2037353515625,"pressure":0.5},{"x":220.0272216796875,"y":122.82440185546875,"pressure":0.5},{"x":227.59088134765625,"y":124.337158203125,"pressure":0.5},{"x":236.5047607421875,"y":125.14749145507812,"pressure":0.5},{"x":244.068359375,"y":125.90386962890625,"pressure":0.5},{"x":251.63201904296875,"y":126.66021728515625,"pressure":0.5},{"x":257.9541015625,"y":127.3626708984375,"pressure":0.5},{"x":264.2762451171875,"y":127.3626708984375,"pressure":0.5},{"x":270.59832763671875,"y":127.3626708984375,"pressure":0.5},{"x":273.84552001953125,"y":127.3626708984375,"pressure":0.5},{"x":281.40911865234375,"y":127.3626708984375,"pressure":0.5},{"x":286.57440185546875,"y":127.3626708984375,"pressure":0.5},{"x":290.73846435546875,"y":127.3626708984375,"pressure":0.5},{"x":294.902587890625,"y":126.17294311523438,"pressure":0.5},{"x":299.0185546875,"y":124.408935546875,"pressure":0.5},{"x":303.18267822265625,"y":123.21923828125,"pressure":0.5},{"x":307.7230224609375,"y":120.624755859375,"pressure":0.5},{"x":311.8870849609375,"y":118.84014892578125,"pressure":0.5},{"x":316.427490234375,"y":116.24566650390625,"pressure":0.5},{"x":320.591552734375,"y":114.4610595703125,"pressure":0.5},{"x":325.13189697265625,"y":111.8665771484375,"pressure":0.5},{"x":329.67230224609375,"y":109.2720947265625,"pressure":0.5},{"x":334.12451171875,"y":106.72796630859375,"pressure":0.5},{"x":338.66485595703125,"y":104.13346862792969,"pressure":0.5},{"x":342.18157958984375,"y":101.78900146484375,"pressure":0.5},{"x":346.345703125,"y":100.00439453125,"pressure":0.5},{"x":350.509765625,"y":98.21978759765625,"pressure":0.5},{"x":354.6666259765625,"y":96.43827819824219,"pressure":0.5},{"x":359.20703125,"y":93.84379577636719,"pressure":0.5},{"x":364.39599609375,"y":92.54655456542969,"pressure":0.5},{"x":368.5216064453125,"y":90.77841186523438,"pressure":0.5},{"x":372.685791015625,"y":88.99380493164062,"pressure":0.5},{"x":377.874755859375,"y":87.04794311523438,"pressure":0.5},{"x":383.063720703125,"y":85.75070190429688,"pressure":0.5},{"x":389.3858642578125,"y":83.64334106445312,"pressure":0.5},{"x":394.5748291015625,"y":82.34609985351562,"pressure":0.5},{"x":399.7637939453125,"y":81.04885864257812,"pressure":0.5},{"x":404.9527587890625,"y":79.10299682617188,"pressure":0.5},{"x":411.27490234375,"y":78.40054321289062,"pressure":0.5},{"x":416.4638671875,"y":77.10330200195312,"pressure":0.5},{"x":421.65283203125,"y":75.80606079101562,"pressure":0.5},{"x":427.974853515625,"y":74.40115356445312,"pressure":0.5},{"x":434.2969970703125,"y":73.69869995117188,"pressure":0.5},{"x":440.619140625,"y":72.29379272460938,"pressure":0.5},{"x":448.1827392578125,"y":71.53742980957031,"pressure":0.5},{"x":455.746337890625,"y":70.78106689453125,"pressure":0.5},{"x":464.5750732421875,"y":69.97846984863281,"pressure":0.5},{"x":473.489013671875,"y":69.16812133789062,"pressure":0.5},{"x":481.0526123046875,"y":69.16812133789062,"pressure":0.5},{"x":488.6162109375,"y":68.41175842285156,"pressure":0.5},{"x":496.179931640625,"y":68.41175842285156,"pressure":0.5},{"x":503.7435302734375,"y":68.41175842285156,"pressure":0.5},{"x":511.3072509765625,"y":68.41175842285156,"pressure":0.5},{"x":516.4962158203125,"y":68.41175842285156,"pressure":0.5},{"x":518.9342041015625,"y":68.41175842285156,"pressure":0.5},{"x":524.1231689453125,"y":68.41175842285156,"pressure":0.5},{"x":529.3121337890625,"y":68.41175842285156,"pressure":0.5},{"x":532.559326171875,"y":68.41175842285156,"pressure":0.5},{"x":535.8065185546875,"y":68.95294189453125,"pressure":0.5},{"x":539.02880859375,"y":70.02705383300781,"pressure":0.5},{"x":541.4669189453125,"y":71.00224304199219,"pressure":0.5},{"x":544.7139892578125,"y":72.08462524414062,"pressure":0.5},{"x":547.152099609375,"y":72.57221984863281,"pressure":0.5},{"x":549.590087890625,"y":73.54740905761719,"pressure":0.5},{"x":552.028076171875,"y":74.52259826660156,"pressure":0.5},{"x":554.466064453125,"y":75.49778747558594,"pressure":0.5},{"x":556.904052734375,"y":76.47297668457031,"pressure":0.5},{"x":561.055419921875,"y":78.25212097167969,"pressure":0.5},{"x":566.0068359375,"y":79.75791931152344,"pressure":0.5},{"x":568.44482421875,"y":80.73310852050781,"pressure":0.5},{"x":571.642333984375,"y":81.79891967773438,"pressure":0.5},{"x":574.080322265625,"y":82.77410888671875,"pressure":0.5},{"x":577.3275146484375,"y":83.85649108886719,"pressure":0.5},{"x":579.7655029296875,"y":84.83168029785156,"pressure":0.5},{"x":583.858154296875,"y":86.58566284179688,"pressure":0.5}],"color":4278190080,"width":5.0}]}''';

  var websocket =Get.find<Websocket>();

  nextpresentation({required String page}){
    websocket.websocketsub(["{\"msg\":\"method\",\"id\":\"33\",\"method\":\"switchSlide\",\"params\":[$page,\"DEFAULT_PRESENTATION_POD\"]}"]);
  }

  void parsedata(var data){
    print("data json drawing");
    print(data);
    if(data["msg"] == "added") {
      pathse.add(annotationsFromJson(jsonEncode(data)));
    }else if(data["msg"] == "removed") {
      erase(id: data["id"]);
    }
  }

  var _zoomLevel = 1.0.obs; // Initial zoom level (100%)
  set zoomLevel(value) => _zoomLevel.value = value;
  get zoomLevel => _zoomLevel.value;

  void zoomIn() {
    zoomLevel += 0.1; // Increase zoom level
    if (zoomLevel > 2.0) zoomLevel = 2.0; // Maximum 200% zoom
  }

  get zoomPercentage => (zoomLevel * 100).toInt();

  void zoomOut() {
    zoomLevel -= 0.1; // Decrease zoom level
    if (zoomLevel < 0.5) zoomLevel = 0.5; // Minimum 50% zoom
  }

  var _slideposition = 1.obs; // Initial zoom level (100%)
  set slideposition(value) => _slideposition.value = value;
  get slideposition => _slideposition.value;

  var _pointerPosition = Rx<List<double>?>(null);
  set pointerPosition (value) => _pointerPosition.value = value;
  List<double>? get pointerPosition => _pointerPosition.value;

  var _pathse = <Annotations>[].obs;
  set pathse (List<Annotations> value) => _pathse.value = value;
  List<Annotations> get pathse => _pathse.value;

  var _currentPathPoints = <List<double>>[].obs;
  set currentPathPoints (List<List<double>> value) => _currentPathPoints.value = value;
  List<List<double>> get currentPathPoints => _currentPathPoints.value;

  var _currentColor = Colors.black.obs;
  set currentColor (value) => _currentColor.value = value;
  get currentColor => _currentColor.value;

  var _currentStrokeWidth = 6.0.obs;
  set currentStrokeWidth (value) => _currentStrokeWidth.value = value;
  get currentStrokeWidth => _currentStrokeWidth.value;

  var _currentMode = "draw".obs;
  set currentMode (value) => _currentMode.value = value;
  get currentMode => _currentMode.value;

  var  _startPoint = Rx<Offset?>(null);
  set startPoint (value) => _startPoint.value = value;
  get startPoint => _startPoint.value;

  var _eraserRadius = 20.0.obs;
  set eraserRadius (value) => _eraserRadius.value = value;
  get eraserRadius => _eraserRadius.value;

  var _textPosition = Rx<Offset?>(null);
  set textPosition (value) => _textPosition.value = value;
  get textPosition => _textPosition.value;

  var _currentText = "".obs;
  set currentText (value) => _currentText.value = value;
  get currentText => _currentText.value;

  var _actions = <DrawAction>[].obs;
  set actions (value) => _actions.value = value;
  get actions => _actions.value;

  var _undoStack = <List<DrawAction>>[].obs;
  set undoStack (value) => _undoStack.value = value;
  get undoStack => _undoStack.value;

  var _redoStack = <List<DrawAction>>[].obs;
  set redoStack (value) => _redoStack.value = value;
  get redoStack => _redoStack.value;

  void erase({Offset? position,String? id}) {
    if (position != null) {
      pathse.removeWhere((Annotations path) =>
          path.fields!.annotationInfo!.points!.any((p) => (Offset(p[0],p[1]) - position).distance < eraserRadius));
    }else if(id != null){
      pathse.removeWhere((path) => path.id == id);
    }
  }
  // Modify the eraser function to only erase part of the shapes or lines
  // void erase(Offset position) {
  //
  //     List<DrawnPath> newPaths = [];
  //     for (var path in pathse) {
  //       if (path.mode == DrawMode.line) {
  //         // Partial erase for lines
  //         newPaths.addAll(eraseLine(path, position));
  //       } else if (path.mode == DrawMode.triangle || path.mode == DrawMode.square || path.mode == DrawMode.ellipse) {
  //         // Partial erase for shapes
  //         newPaths.addAll(eraseShape(path, position:position));
  //       }
  //     }
  //     pathse = newPaths;
  // }
  //
  // List<DrawnPath> eraseLine(DrawnPath path, Offset position) {
  //   List<List<Offset>> newSegments = [];
  //   List<Offset> currentSegment = [];
  //
  //
  //   for (int i = 0; i < path.points.length; i++) {
  //     Offset point = path.points[i];
  //     if ((point - position).distance > eraserRadius) {
  //       currentSegment.add(point);
  //     } else {
  //       if (currentSegment.isNotEmpty) {
  //         newSegments.add(currentSegment);
  //         currentSegment = [];
  //       }
  //     }
  //   }
  //   if (currentSegment.isNotEmpty) {
  //     newSegments.add(currentSegment);
  //   }
  //
  //   return newSegments
  //       .where((segment) => segment.length > 1) // Filter out empty segments
  //       .map((segment) => DrawnPath(
  //     points: segment,
  //     color: path.color,
  //     strokeWidth: path.strokeWidth,
  //     mode: path.mode,
  //   ))
  //       .toList();
  // }
  //
  // List<DrawnPath> eraseShape(DrawnPath path, {Offset? position,String? id}) {
  //   // We will split the shape at points where it intersects with the eraser
  //   // Here, we check each point in the shape and remove segments near the eraser
  //   List<Offset> remainingPoints = path.points
  //       .where((point) => (point - position!).distance > eraserRadius)
  //       .toList();
  //
  //   if (remainingPoints.length >= 2) {
  //     return [
  //       DrawnPath(
  //         points: remainingPoints,
  //         color: path.color,
  //         strokeWidth: path.strokeWidth,
  //         mode: path.mode,
  //       )
  //     ];
  //   }
  //
  //   return [];
  // }


  void onCanvasTap(TapUpDetails details) {
    if (currentMode == "text") {
        textPosition = details.localPosition;
    }
  }

  void addTextEntry() {
    if (_currentText.isNotEmpty && _textPosition != null) {
      saveToUndoStack();
        actions.add(DrawAction.text(currentText, textPosition!));
        currentText = "";
        textPosition = null;
    }
  }

  void saveToUndoStack() {
    undoStack.add(List.from(_actions));
    redoStack.clear(); // Clear redo stack when a new action is made
  }

  void undo() {
    if (undoStack.isNotEmpty) {
      redoStack.add(List.from(_actions));
        actions = undoStack.removeLast();
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      undoStack.add(List.from(_actions));
      actions = _redoStack.removeLast();
    }
  }


  void addShape(Offset start, Offset end) {
    List<double> points = [];
    switch (currentMode) {
      case "triangle":
        points = [
          start.dx, end.dy,
          ((start.dx + end.dx) / 2), start.dy,
          end.dx, end.dy,
        ];
        break;
      case "rectangle":
        points = [start.dx, start.dy, end.dx, start.dy, end.dx, end.dy, start.dx, end.dy];
        break;
      case "ellipse":
        points = [start.dx, start.dy, end.dx, end.dy];
        break;
      default:
        return;
    }
    pathse.add(Annotations(
      fields: Fields(
        annotationInfo: AnnotationInfo(
          point: points,
          style: Style(
            scale: currentStrokeWidth,
            color: currentColor
          ),
          type: currentMode
        )
      ),));
  }

  // Convert the list of DrawnPath to JSON
  String exportToJson() {
    final jsonPaths = pathse.last;
    return jsonEncode({'paths': jsonPaths});
  }

  // Load paths from JSON and redraw
  void importFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final paths = (decoded['paths'] as List)
        .map((pathJson) => Annotations.fromJson(pathJson as Map<String, dynamic>))
        .toList();
      pathse = paths;
  }

  void onPointerHover(PointerHoverEvent event) {
    // if (_currentMode == DrawMode.pointer) {
      var newy = event.localPosition.dy-40;
      var newx = event.localPosition.dx-60;
      pointerPosition = Offset(newx, newy);
    // }
  }
}