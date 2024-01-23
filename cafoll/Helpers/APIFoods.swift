//
//  APIFoods.swift
//  cafoll
//
//  Created by mücahit öztürk on 2.01.2024.
//

import Foundation

struct Food: Codable {
    let proteinDict: Float
    let carbsDict: Float
    let caloriesDict: Float
    let fatDict: Float
    let info: String
}

var searchResults: [String: Food] = [:]
var foodDictionary: [String: Food] = [
    "elma": Food(
           proteinDict: 0.26,
           carbsDict: 13.81,
           caloriesDict: 52.00,
           fatDict: 0.17,
           info: "*Bir adet Elma 41 gr."
       ),
    "muz": Food(
        proteinDict: 1.09,
        carbsDict: 22.84,
        caloriesDict: 89.00,
        fatDict: 0.33,
        info: "*Bir adet Muz 170 gr."
    ),
    "çilek": Food(
        proteinDict: 0.67,
        carbsDict: 7.68,
        caloriesDict: 32.00,
        fatDict: 0.30,
        info: "*Bir adet Çilek 12 gr."
    ),
    "portakal": Food(
         proteinDict: 0.70,
         carbsDict: 11.54,
         caloriesDict: 46.00,
         fatDict: 0.21,
        info: "*Bir adet Portakal 220 gr."
    ),
    "karpuz": Food(
         proteinDict: 0.61,
         carbsDict: 7.55,
         caloriesDict: 30.00,
         fatDict: 0.15,
        info: "*Bir orta dilim Karpuz 350 gr."
    ),
    "ananas": Food(
         proteinDict: 0.54,
         carbsDict: 13.12,
         caloriesDict: 50.00,
         fatDict: 0.12,
        info: "*Bir orta dilim Ananas 80 gr."
    ),
    "armut": Food(
         proteinDict: 0.36,
         carbsDict: 15.23,
         caloriesDict: 57.00,
         fatDict: 0.14,
        info: "*Bir adet Armut 200 gr."
    ),
    "şeftali": Food(
         proteinDict: 0.91,
         carbsDict: 9.54,
         caloriesDict: 39.00,
         fatDict: 0.25,
        info: "*Bir adet Şeftali 250 gr. "
    ),
    "kiraz": Food(
         proteinDict: 1.06,
         carbsDict: 16.01,
         caloriesDict: 63.00,
         fatDict: 0.20,
        info: "*Bir adet Kiraz 7 gr."
    ),
    "mandalina": Food(
         proteinDict: 0.81,
         carbsDict: 13.34,
         caloriesDict: 53.00,
         fatDict: 0.31,
        info: "*Bir adet Mandalina 125 gr."
    ),
    "nar": Food(
         proteinDict: 1.67,
         carbsDict: 18.70,
         caloriesDict: 83.00,
         fatDict: 0.17,
        info: "*Bir adet Nar 160 gr."
    ),
    "mango": Food(
         proteinDict: 0.82,
         carbsDict: 14.98,
         caloriesDict: 60.00,
         fatDict: 0.38,
        info: "*Bir adet Mango 290 gr."
    ),
    "erik": Food(
         proteinDict: 0.70,
         carbsDict: 11.42,
         caloriesDict: 46.00,
         fatDict: 0.28,
        info: "*Bir adet Erik 20 gr."
    ),
    "ahududu": Food(
         proteinDict: 1.20,
         carbsDict: 11.94,
         caloriesDict: 52.00,
         fatDict: 0.65,
        info: "*Bir adet Ahududu 10 gr."
    ),
    "dut": Food(
         proteinDict: 1.30,
         carbsDict: 8.10,
         caloriesDict: 44.00,
         fatDict: 0.00,
        info: "*Bir avuç Dut 50 gr."
    ),
    "kavun": Food(
         proteinDict: 1.11,
         carbsDict: 6.58,
         caloriesDict: 28.00,
         fatDict: 0.10,
        info: "*Bir orta dilim Kavun 270 gr."
    ),
    "ayva": Food(
         proteinDict: 0.35,
         carbsDict: 13.92,
         caloriesDict: 60.00,
         fatDict: 0.14,
        info: "*Bir Adet Ayva 250 gr."
    ),
    "limon": Food(
         proteinDict: 0.44,
         carbsDict: 8.73,
         caloriesDict: 46.00,
         fatDict: 0.36,
        info: "*Bir adet Limon 100 gr."
    ),
    "üzüm": Food(
         proteinDict: 0.72,
         carbsDict: 18.10,
         caloriesDict: 69.00,
         fatDict: 0.16,
        info: "*Bir kase Üzüm 230 gr."
    ),
    "kivi": Food(
         proteinDict: 0.14,
         carbsDict: 14.66,
         caloriesDict: 61.00,
         fatDict: 0.52,
        info: "*Bir adet Kivi 100 gr."
    ),
    "avakado": Food(
         proteinDict: 2.00,
         carbsDict: 8.53,
         caloriesDict: 160.00,
         fatDict: 14.66,
        info: "*Bir adet Avakado 140 gr."
    ),
    "ceviz": Food(
         proteinDict: 15.20,
         carbsDict: 13.71,
         caloriesDict: 654.0,
         fatDict: 65.20,
        info: "*Bir adet Ceviz 5 gr."
    ),
    "antep fıstığı": Food(
         proteinDict: 17.64,
         carbsDict: 11.55,
         caloriesDict: 575.0,
         fatDict: 51.60,
        info: "*Bir adet Antep Fıstığı (kabuksuz) 2 gr. "
    ),
    "yulaf ezmesi": Food(
         proteinDict: 16.89,
         carbsDict: 66.27,
         caloriesDict: 389.0,
         fatDict: 6.90,
        info: "*Bir çorba kaşığı Yulaf Ezmesi 6 gr."
    ),
    "beyaz peynir": Food(
         proteinDict: 20.38,
         carbsDict: 2.53,
         caloriesDict: 310.0,
         fatDict: 24.31,
        info: "*Bir dilim Beyaz Peynir 30 gr."
    ),
    "yumurta": Food(
         proteinDict: 12.56,
         carbsDict: 0.72,
         caloriesDict: 143.0,
         fatDict: 9.51,
        info: "*Bir adet Yumurta 50 gr."
    ),
    "zeytin": Food(
         proteinDict: 1.80,
         carbsDict: 1.10,
         caloriesDict: 207.0,
         fatDict: 21.00,
        info: "*Bir adet Zeytin 4 gr."
    ),
    "domates": Food(
         proteinDict: 0.88,
         carbsDict: 3.89,
         caloriesDict: 18.00,
         fatDict: 0.20,
        info: "*Bir adet Domates 110 gr."
    ),
    "salatalık": Food(
         proteinDict: 0.62,
         carbsDict: 1.81,
         caloriesDict: 12.00,
         fatDict: 0.20,
        info: "*Bir adet Salatalık 120 gr."
    ),
    "bal": Food(
         proteinDict: 0.38,
         carbsDict: 82.40,
         caloriesDict: 304.0,
         fatDict: 0.00,
        info: "*Bir tatlı kaşığı Bal 10 gr."
    ),
    "yoğurt": Food(
         proteinDict: 3.47,
         carbsDict: 4.66,
         caloriesDict: 61.00,
         fatDict: 3.25,
        info: "*Bir kase Yoğurt 180 gr."
    ),
    "süt": Food(
         proteinDict: 3.30,
         carbsDict: 4.70,
         caloriesDict: 61.00,
         fatDict: 3.30,
        info: "*Bir su bardağı Süt 200 gr."
    ),
    "tam buğday ekmek": Food(
         proteinDict: 12.45,
         carbsDict: 42.71,
         caloriesDict: 252.0,
         fatDict: 3.50,
        info: "*Bir ince dilim Tam Buğday Ekmeği 25 gr."
    ),
    "fındık": Food(
         proteinDict: 14.95,
         carbsDict: 16.70,
         caloriesDict: 628.0,
         fatDict: 60.75,
        info: "*Bir adet Fındık 2 gr."
    ),
    "badem": Food(
         proteinDict: 18.60,
         carbsDict: 19.50,
         caloriesDict: 598.0,
         fatDict: 54.20,
        info: "*Bir adet Badem 2 gr."
    ),
    "kayısı": Food(
         proteinDict: 1.40,
         carbsDict: 11.12,
         caloriesDict: 48.00,
         fatDict: 0.39,
        info: "*Bir adet Kayısı 30 gr."
    ),
    "ayran": Food(
          proteinDict: 1.98,
          carbsDict: 2.71,
          caloriesDict: 37.00,
          fatDict: 2.00,
         info: "*Bir su bardağı Ayran 200 gr."
    ),
    "portakal suyu": Food(
         proteinDict: 0.40,
         carbsDict: 14.64,
         caloriesDict: 60.00,
         fatDict: 0.17,
        info: "*Bir su bardağı Portakal Suyu 200 gr."
    ),
    "fıstık ezmesi": Food(
         proteinDict: 24.06,
         carbsDict: 21.57,
         caloriesDict: 589.0,
         fatDict: 49.94,
        info: "*Bir tatlı kaşığı Fıstık Ezmesi 6 gr."
    ),
    "pastırma": Food(
         proteinDict: 29.5,
         carbsDict: 0.00,
         caloriesDict: 250.0,
         fatDict: 13.90,
        info: "*Bir dilim Pastırma 10 gr."
    ),
    "antrikot": Food(
         proteinDict: 18.90,
         carbsDict: 0.58,
         caloriesDict: 182.0,
         fatDict: 11.04,
        info: "*Bir adet Antrikot 150 gr."
    ),
    "balık": Food(
         proteinDict: 18.30,
         carbsDict: 0.00,
         caloriesDict: 82.00,
         fatDict: 0.90,
        info: "*Bir porsiyon Balık 200 gr."
    ),
    "mercimek çorbası": Food(
         proteinDict: 1.11,
         carbsDict: 3.99,
         caloriesDict: 23.00,
         fatDict: 0.11,
        info: "*Bir kase Mercimek Çorbası 200 gr."
    ),
    "hindi but": Food(
         proteinDict: 27.87,
         carbsDict: 0.00,
         caloriesDict: 208.0,
         fatDict: 9.82,
        info: "*Bir porsiyon Hindi But 90 gr."
    ),
    "karnabahar": Food(
         proteinDict: 1.84,
         carbsDict: 4.11,
         caloriesDict: 23.00,
         fatDict: 0.45,
        info: "*Bir porsion pişmiş Karnabahar 150 gr."
    ),
    "kuru fasulye": Food(
         proteinDict: 6.57,
         carbsDict: 9.91,
         caloriesDict: 97.00,
         fatDict: 1.35,
        info: "*Bir porsiyon Kuru Fasulye 275 gr."
    ),
    "patlıcan ezme": Food(
         proteinDict: 1.28,
         carbsDict: 3.25,
         caloriesDict: 29.00,
         fatDict: 1.20,
        info: "*Bir porsiyon Patlıcan Ezme 300 gr."
    ),
    "kabak": Food(
         proteinDict: 1.60,
         carbsDict: 2.05,
         caloriesDict: 19.00,
         fatDict: 0.40,
        info: "*Bir adet Kabak 150 gr."
    ),
    "Rokalı Tabule Salatası": Food(
         proteinDict: 7.14,
         carbsDict: 50.81,
         caloriesDict: 261.0,
         fatDict: 4.34,
        info: "*Bir kase Tabule 90 gr."
    ),
    "yaprak sarma (zeytinyağlı) ": Food(
         proteinDict: 3.37,
         carbsDict: 17.82,
         caloriesDict: 96.00,
         fatDict: 1.32,
        info: "*Bir adet Yaprak sarma 33 gr."
    ),
    "brokoli salatası": Food(
         proteinDict: 1.46,
         carbsDict: 7.67,
         caloriesDict: 54.00,
         fatDict: 1.63,
        info: "*Bir porsiyon Brokoli Salatası 210 gr."
    ),
    "kuzu şiş kebab": Food(
         proteinDict: 16.52,
         carbsDict: 3.82,
         caloriesDict: 167.0,
         fatDict: 9.72,
        info: "*Bir porsiyon Kuzu Şiş Kebab 205"
    ),
    "fırın patates": Food(
         proteinDict: 1.55,
         carbsDict: 14.36,
         caloriesDict: 107.0,
         fatDict: 4.79,
        info: "*Bir adet Patates 150 gr."
    ),
    "enginar": Food(
         proteinDict: 3.27,
         carbsDict: 10.51,
         caloriesDict: 47.00,
         fatDict: 0.15,
        info: "*Bir adet Enginar 100 gr."
    ),
    "ıspanak yemeği": Food(
         proteinDict: 2.55,
         carbsDict: 5.71,
         caloriesDict: 76.00,
         fatDict: 4.64,
        info: "*Bir porsiyon Ispanak 175 gr."
    ),
    "bulgur pilavı": Food(
         proteinDict: 2.78,
         carbsDict: 18.19,
         caloriesDict: 114.0,
         fatDict: 3.39,
        info: "*Bir porsiyon Bulgur Pilavı 130 gr."
    ),
    "tereyağı": Food(
        proteinDict: 0.85,
         carbsDict: 0.06,
        caloriesDict: 717.0,
        fatDict: 81.11,
        info: "*Bir çorba kaşığı Tereyağı 14 gr. "
    ),
    "tahin pekmez": Food(
        proteinDict: 10.10,
        carbsDict: 43.00,
        caloriesDict: 437.0,
        fatDict: 23.20,
         info: "*Bir yemek Kaşığı Tahinli Pekmez 15 gr."
     ),
    "ekmek": Food(
        proteinDict: 8.09,
        carbsDict: 52.80,
        caloriesDict: 256.0,
        fatDict: 0.89,
         info: "*Bir ince dilim Ekmek 25 gr."
     ),
    "pirinç pilavı": Food(
        proteinDict: 2.07,
        carbsDict: 24.79,
        caloriesDict: 162.0,
        fatDict: 5.80,
         info: "*Bir porsiyon Pirinç Pilavı 160 gr."
     ),
    "yeşil mercimek": Food(
        proteinDict: 3.00,
        carbsDict: 8.03,
        caloriesDict: 80.00,
        fatDict: 4.02,
         info: "*Bir kase Yeşil Mercimek 200 gr."
     ),
    "makarna": Food(
         proteinDict: 5.80,
         carbsDict: 30.86,
         caloriesDict: 158.0,
         fatDict: 0.93,
         info: "*Bir porsiyon Makarna 50 gr."
     ),
    "köfte": Food(
        proteinDict: 13.05,
        carbsDict: 4.92,
        caloriesDict: 168.0,
        fatDict: 10.47,
         info: "*Bir adet köfte 40 gr."
     ),
    "et döner dürüm": Food(
        proteinDict: 12.62,
        carbsDict: 8.38,
        caloriesDict: 128.0,
        fatDict: 19.82,
         info: "*Bir adet Et Döner Dürüm 235 gr."
     ),
    "havuç": Food(
        proteinDict: 0.93,
        carbsDict: 9.58,
        caloriesDict: 41.00,
        fatDict: 0.24,
         info: "*Bir adet Havuç 85 gr"
     ),
    "tavuk döner dürüm": Food(
        proteinDict: 17.24,
        carbsDict: 6.05,
        caloriesDict: 124.0,
        fatDict: 14.55,
         info: "*Bir Tavuk Döner Dürüm 250 gr."
     ),
    "tarhana çorbası": Food(
        proteinDict: 2.30,
        carbsDict: 4.99,
        caloriesDict: 60.00,
        fatDict: 3.29,
         info: "*Bir kase Tarhana Çorbası 200 gr."
     ),
    "kabak çekirdeği": Food(
        proteinDict: 0.24,
        carbsDict: 0.14,
        caloriesDict: 6.00,
        fatDict: 0.46,
         info: "*Bir avuç Kabak Çekirdeği 10 gr."
     ),
    "etli lahana sarması": Food(
        proteinDict: 4.26,
        carbsDict: 4.19,
        caloriesDict: 58.00,
        fatDict: 2.57,
         info: "*Bir orta porsiyon Etli Lahana Sarması 210 gr."
     ),
    "etli pazı sarması": Food(
        proteinDict: 7.71,
        carbsDict: 5.77,
        caloriesDict: 109.0,
        fatDict: 5.96,
         info: "*Bir orta porsiyon Etli Pazı Sarması 200 gr."
     ),
    "şalgam suyu": Food(
        proteinDict: 0.52,
        carbsDict: 1.06,
        caloriesDict: 5.00,
        fatDict: 0.11,
         info: "*Bir su bardağı Şalgam Suyu 200 gr. "
     ),
    "sivas tulum peyniri": Food(
        proteinDict: 17.00,
        carbsDict: 1.50,
        caloriesDict: 300.0,
        fatDict: 25.00,
         info: "*Bir orta dilim Sivas Tulum Peyniri 30 gr."
     ),
    "erzincan tulum peyniri": Food(
        proteinDict: 19.59,
        carbsDict: 9.21,
        caloriesDict: 334.0,
        fatDict: 24.32,
         info: "*Bir orta dilim Erzincan Tulum Peyniri 30 gr."
     ),
    "yeşil zeytin": Food(
        proteinDict: 1.30,
        carbsDict: 3.84,
        caloriesDict: 145.0,
        fatDict: 15.32,
         info: "*Bir adet Yeşil Zeytin 4 gr."
     ),
    "kaymak": Food(
        proteinDict: 0.96,
        carbsDict: 3.31,
        caloriesDict: 585.0,
        fatDict: 63.1,
         info: "Bir çorba kaşığı Kaymak 10 gr."
     ),
    "kaju fıstığı (kavrulmamış)": Food(
        proteinDict: 18.22,
        carbsDict: 30.19,
        caloriesDict: 553.0,
        fatDict: 43.85,
         info: "Bir avuç Kaju Fıstığı 25 gr."
     ),
    "XXXXXXXXX": Food(
         proteinDict: 0,
         carbsDict: 0,
         caloriesDict: 0,
         fatDict: 0,
         info: ""
     )
   
]


