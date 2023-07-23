
const jsonTest = {
  "listGroup":[
    jsonTestFromMapGroup1,
    jsonTestFromMapGroup2
  ]
};
const jsonTestFromMapGroup1 = {
  "id_group":"p9d23hnd2323dwd8ny292",
  "listObject": [
    {
      /// Тип обьекта, для того чтобы знать как его отрисовать
      "type": "circular",
      //TODO: направление малого обьекта revers = true / false
      //TODO: направление основного обьекта 
      /// В какую сторону движется
      "direction": "right",
      // 47.215762,39.758243
      // < 90 / > -90
      "lat": 47.215762,
      "lon": 39.758243,
      "id_object": "sad328923dfdgfhds893283",
      // Радиус в метрах
      "radius_object": 120.673,
      "name": "КЛ43 М.А.",
    },
    {
      /// Тип обьекта, для того чтобы знать как его отрисовать
      "type": "circular",
      //TODO: направление малого обьекта revers = true / false
      //TODO: направление основного обьекта 
      /// В какую сторону движется
      "direction": "left",
      //47.216229,39.771555
      "lat": 47.216229,
      "lon": 39.771555,
      "id_object": "b79dsb8f72f",
      // Радиус в метрах
      "radius_object": 70.673,
      "name": "12GP-SU",
    }
  ]
};

const jsonTestFromMapGroup2 = {
  "id_group":"2893yrn398rn23yfbdp9efbdwa",
  "listObject": [
    {
      /// Тип обьекта, для того чтобы знать как его отрисовать
      "type": "circular",
      //TODO: направление малого обьекта revers = true / false
      //TODO: направление основного обьекта 
      /// В какую сторону движется
      "direction": "right",
      // 47.059281,39.491416
      "lat": 47.059281,
      "lon": 39.491416,
      "id_object": "sad328923dfdgfhds893283",
      // Радиус в метрах
      "radius_object": 200.673,
      "name": "КЛ43 М.А.",
    },
    {
      /// Тип обьекта, для того чтобы знать как его отрисовать
      "type": "circular",
      //TODO: направление малого обьекта revers = true / false
      //TODO: направление основного обьекта 
      /// В какую сторону движется
      "direction": "left",
      //47.034349,39.530335
      "lat": 47.034349,
      "lon": 39.530335,
      "id_object": "b79dsb8f72f",
      // Радиус в метрах
      "radius_object": 200.673,
      "name": "12GP-SU",
    }
  ]
};


// var fff = {
//     "listGroup": [
//         {
//             "id_group": "p9d23hnd2323dwd8ny292",
//             "listObject": [
//                 {
//                     "type": "circular",
//                     "direction": "right",
//                     "lat": 47.215762,
//                     "lon": 39.758243,
//                     "id_object": "sad328923dfdgfhds893283",
//                     "radius_object": 2312.673,
//                     "name": "КЛ43 М.А."
//                 },
//                 {
//                     "type": "circular",
//                     "direction": "left",
//                     "lat": 47.216229,
//                     "lon": 39.771555,
//                     "id_object": "b79dsb8f72f",
//                     "radius_object": 1421.673,
//                     "name": "12GP-SU"
//                 }
//             ]
//         }
//     ]
// };

