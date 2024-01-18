//
//  APIFoods.swift
//  cafoll
//
//  Created by mücahit öztürk on 2.01.2024.
//

import Foundation

struct Food: Codable {
    let protein: Float
    let carbs: Float
    let calories: Float
    let fat: Float
    let info: String
}

var searchResults: [String: Food] = [:]
var foodDictionary: [String: Food] = [
    "elma": Food(
           protein: 0.26,
           carbs: 13.81,
           calories: 52.00,
           fat: 0.17,
           info: "Bir adet Elma 41 gr."
       ),
    "muz": Food(
        protein: 1.09,
        carbs: 22.84,
        calories: 89.00,
        fat: 0.33,
        info: "Bir adet Muz 170 gr."
    ),
    "çilek": Food(
        protein: 0.67,
        carbs: 7.68,
        calories: 32.00,
        fat: 0.30,
        info: "Bir adet Çilek 12 gr."
    ),
    "portakal": Food(
         protein: 0.70,
         carbs: 11.54,
         calories: 46.00,
         fat: 0.21,
        info: "Bir adet Portakal 220 gr."
    ),
    "karpuz": Food(
         protein: 0.61,
         carbs: 7.55,
         calories: 30.00,
         fat: 0.15,
        info: "Bir orta dilim Karpuz 350 gr."
    ),
    "ananas": Food(
         protein: 0.54,
         carbs: 13.12,
         calories: 50.00,
         fat: 0.12,
        info: "Bir orta dilim Ananas 80 gr."
    ),
    "armut": Food(
         protein: 0.36,
         carbs: 15.23,
         calories: 57.00,
         fat: 0.14,
        info: "Bir adet Armut 200 gr."
    ),
    "şeftali": Food(
         protein: 0.91,
         carbs: 9.54,
         calories: 39.00,
         fat: 0.25,
        info: "Bir adet Şeftali 250 gr. "
    ),
    "kiraz": Food(
         protein: 1.06,
         carbs: 16.01,
         calories: 63.00,
         fat: 0.20,
        info: "Bir adet Kiraz 7 gr."
    ),
    "mandalina": Food(
         protein: 0.81,
         carbs: 13.34,
         calories: 53.00,
         fat: 0.31,
        info: "Bir adet Mandalina 125 gr."
    ),
    "nar": Food(
         protein: 1.67,
         carbs: 18.70,
         calories: 83.00,
         fat: 0.17,
        info: "Bir adet Nar 160 gr."
    ),
    "mango": Food(
         protein: 0.82,
         carbs: 14.98,
         calories: 60.00,
         fat: 0.38,
        info: "Bir adet Mango 290 gr."
    ),
    "erik": Food(
         protein: 0.70,
         carbs: 11.42,
         calories: 46.00,
         fat: 0.28,
        info: "Bir adet Erik 20 gr."
    ),
    "ahududu": Food(
         protein: 1.20,
         carbs: 11.94,
         calories: 52.00,
         fat: 0.65,
        info: "Bir adet Ahududu 10 gr."
    ),
    "dut": Food(
         protein: 1.30,
         carbs: 8.10,
         calories: 44.00,
         fat: 0.00,
        info: "Bir avuç Dut 50 gr."
    ),
    "kavun": Food(
         protein: 1.11,
         carbs: 6.58,
         calories: 28.00,
         fat: 0.10,
        info: "Bir orta dilim Kavun 270 gr."
    ),
    "ayva": Food(
         protein: 0.35,
         carbs: 13.92,
         calories: 60.00,
         fat: 0.14,
        info: "Bir Adet Ayva 250 gr."
    ),
    "limon": Food(
         protein: 0.44,
         carbs: 8.73,
         calories: 46.00,
         fat: 0.36,
        info: "Bir adet Limon 100 gr."
    ),
    "üzüm": Food(
         protein: 0.72,
         carbs: 18.10,
         calories: 69.00,
         fat: 0.16,
        info: "Bir kase Üzüm 230 gr."
    ),
    "kivi": Food(
         protein: 0.14,
         carbs: 14.66,
         calories: 61.00,
         fat: 0.52,
        info: "Bir adet Kivi 100 gr."
    ),
    "avakado": Food(
         protein: 2.00,
         carbs: 8.53,
         calories: 160.00,
         fat: 14.66,
        info: "Bir adet Avakado 140 gr."
    ),
    "ceviz": Food(
         protein: 15.20,
         carbs: 13.71,
         calories: 654.0,
         fat: 65.20,
        info: "Bir adet Ceviz 5 gr."
    ),
    "antep fıstığı": Food(
         protein: 17.64,
         carbs: 11.55,
         calories: 575.0,
         fat: 51.60,
        info: "Bir adet Antep Fıstığı (kabuksuz) 2 gr. "
    ),
    "yulaf ezmesi": Food(
         protein: 16.89,
         carbs: 66.27,
         calories: 389.0,
         fat: 6.90,
        info: "Bir çorba kaşığı Yulaf Ezmesi 6 gr."
    ),
    "beyaz peynir": Food(
         protein: 20.38,
         carbs: 2.53,
         calories: 310.0,
         fat: 24.31,
        info: "Bir dilim Beyaz Peynir 30 gr."
    ),
    "yumurta": Food(
         protein: 12.56,
         carbs: 0.72,
         calories: 143.0,
         fat: 9.51,
        info: "Bir adet Yumurta 50 gr."
    ),
    "zeytin": Food(
         protein: 1.80,
         carbs: 1.10,
         calories: 207.0,
         fat: 21.00,
        info: "Bir adet Zeytin 4 gr."
    ),
    "domates": Food(
         protein: 0.88,
         carbs: 3.89,
         calories: 18.00,
         fat: 0.20,
        info: "Bir adet Domates 110 gr."
    ),
    "salatalık": Food(
         protein: 0.62,
         carbs: 1.81,
         calories: 12.00,
         fat: 0.20,
        info: "Bir adet Salatalık 120 gr."
    ),
    "bal": Food(
         protein: 0.38,
         carbs: 82.40,
         calories: 304.0,
         fat: 0.00,
        info: "Bir tatlı kaşığı Bal 10 gr."
    ),
    "yoğurt": Food(
         protein: 3.47,
         carbs: 4.66,
         calories: 61.00,
         fat: 3.25,
        info: "Bir kase Yoğurt 180 gr."
    ),
    "süt": Food(
         protein: 3.30,
         carbs: 4.70,
         calories: 61.00,
         fat: 3.30,
        info: "Bir su bardağı Süt 200 gr."
    ),
    "tam buğday ekmek": Food(
         protein: 12.45,
         carbs: 42.71,
         calories: 252.0,
         fat: 3.50,
        info: "Bir ince dilim Tam Buğday Ekmeği 25 gr."
    ),
    "fındık": Food(
         protein: 14.95,
         carbs: 16.70,
         calories: 628.0,
         fat: 60.75,
        info: "Bir adet Fındık 2 gr."
    ),
    "badem": Food(
         protein: 18.60,
         carbs: 19.50,
         calories: 598.0,
         fat: 54.20,
        info: "Bir adet Badem 2 gr."
    ),
    "kayısı": Food(
         protein: 1.40,
         carbs: 11.12,
         calories: 48.00,
         fat: 0.39,
        info: "Bir adet Kayısı 30 gr."
    ),
    "ayran": Food(
          protein: 1.98,
          carbs: 2.71,
          calories: 37.00,
          fat: 2.00,
         info: "Bir su bardağı Ayran 200 gr."
    ),
    "portakal suyu": Food(
         protein: 0.40,
         carbs: 14.64,
         calories: 60.00,
         fat: 0.17,
        info: "Bir su bardağı Portakal Suyu 200 gr."
    ),
    "fıstık ezmesi": Food(
         protein: 24.06,
         carbs: 21.57,
         calories: 589.0,
         fat: 49.94,
        info: "Bir tatlı kaşığı Fıstık Ezmesi 6 gr."
    ),
    "pastırma": Food(
         protein: 29.5,
         carbs: 0.00,
         calories: 250.0,
         fat: 13.90,
        info: "Bir dilim Pastırma 10 gr."
    ),
    "antrikot": Food(
         protein: 18.90,
         carbs: 0.58,
         calories: 182.0,
         fat: 11.04,
        info: "Bir adet Antrikot 150 gr."
    ),
    "balık": Food(
         protein: 18.30,
         carbs: 0.00,
         calories: 82.00,
         fat: 0.90,
        info: "Bir porsiyon Balık 200 gr."
    ),
    "mercimek çorbası": Food(
         protein: 1.11,
         carbs: 3.99,
         calories: 23.00,
         fat: 0.11,
        info: "Bir kase Mercimek Çorbası 200 gr."
    ),
    "hindi but": Food(
         protein: 27.87,
         carbs: 0.00,
         calories: 208.0,
         fat: 9.82,
        info: "Bir porsiyon Hindi But 90 gr."
    ),
    "karnabahar": Food(
         protein: 1.84,
         carbs: 4.11,
         calories: 23.00,
         fat: 0.45,
        info: "Bir porsion pişmiş Karnabahar 150 gr."
    ),
    "kuru fasulye": Food(
         protein: 6.57,
         carbs: 9.91,
         calories: 97.00,
         fat: 1.35,
        info: "Bir porsiyon Kuru Fasulye 275 gr."
    ),
    "patlıcan ezme": Food(
         protein: 1.28,
         carbs: 3.25,
         calories: 29.00,
         fat: 1.20,
        info: "Bir porsiyon Patlıcan Ezme 300 gr."
    ),
    "kabak": Food(
         protein: 1.60,
         carbs: 2.05,
         calories: 19.00,
         fat: 0.40,
        info: "Bir adet Kabak 150 gr."
    ),
    "Rokalı Tabule Salatası": Food(
         protein: 7.14,
         carbs: 50.81,
         calories: 261.0,
         fat: 4.34,
        info: "Bir kase Tabule 90 gr."
    ),
    "yaprak sarma (zeytinyağlı) ": Food(
         protein: 3.37,
         carbs: 17.82,
         calories: 96.00,
         fat: 1.32,
        info: "Bir adet Yaprak sarma 33 gr."
    ),
    "brokoli salatası": Food(
         protein: 1.46,
         carbs: 7.67,
         calories: 54.00,
         fat: 1.63,
        info: "Bir porsiyon Brokoli Salatası 210 gr."
    ),
    "kuzu şiş kebab": Food(
         protein: 16.52,
         carbs: 3.82,
         calories: 167.0,
         fat: 9.72,
        info: "Bir porsiyon Kuzu Şiş Kebab 205"
    ),
    "fırın patates": Food(
         protein: 1.55,
         carbs: 14.36,
         calories: 107.0,
         fat: 4.79,
        info: "Bir adet Patates 150 gr."
    ),
    "enginar": Food(
         protein: 3.27,
         carbs: 10.51,
         calories: 47.00,
         fat: 0.15,
        info: "Bir adet Enginar 100 gr."
    ),
    "ıspanak yemeği": Food(
         protein: 2.55,
         carbs: 5.71,
         calories: 76.00,
         fat: 4.64,
        info: "Bir porsiyon Ispanak 175 gr."
    ),
    "bulgur pilavı": Food(
         protein: 2.78,
         carbs: 18.19,
         calories: 114.0,
         fat: 3.39,
        info: "Bir porsiyon Bulgur Pilavı 130 gr."
    ),
    "tereyağı": Food(
        protein: 0.85,
         carbs: 0.06,
        calories: 717.0,
        fat: 81.11,
        info: "Bir çorba kaşığı Tereyağı 14 gr. "
    ),
    "tahin pekmez": Food(
        protein: 10.10,
        carbs: 43.00,
        calories: 437.0,
        fat: 23.20,
         info: "Bir yemek Kaşığı Tahinli Pekmez 15 gr."
     ),
    "ekmek": Food(
        protein: 8.09,
        carbs: 52.80,
        calories: 256.0,
        fat: 0.89,
         info: "Bir ince dilim Ekmek 25 gr."
     ),
    "pirinç pilavı": Food(
        protein: 2.07,
        carbs: 24.79,
        calories: 162.0,
        fat: 5.80,
         info: "Bir porsiyon Pirinç Pilavı 160 gr."
     ),
    "yeşil mercimek": Food(
        protein: 3.00,
        carbs: 8.03,
        calories: 80.00,
        fat: 4.02,
         info: "Bir kase Yeşil Mercimek 200 gr."
     ),
    "makarna": Food(
         protein: 5.80,
         carbs: 30.86,
         calories: 158.0,
         fat: 0.93,
         info: "Bir porsiyon Makarna 50 gr."
     ),
    "köfte": Food(
        protein: 13.05,
        carbs: 4.92,
        calories: 168.0,
        fat: 10.47,
         info: "Bir adet köfte 40 gr."
     ),
    "et döner dürüm": Food(
        protein: 12.62,
        carbs: 8.38,
        calories: 128.0,
        fat: 19.82,
         info: "Bir adet Et Döner Dürüm 235 gr."
     ),
    "havuç": Food(
        protein: 0.93,
        carbs: 9.58,
        calories: 41.00,
        fat: 0.24,
         info: "Bir adet Havuç 85 gr"
     ),
    "tavuk döner dürüm": Food(
        protein: 17.24,
        carbs: 6.05,
        calories: 124.0,
        fat: 14.55,
         info: "Bir Tavuk Döner Dürüm 250 gr."
     ),
    "XXXXXXXXX": Food(
         protein: 0,
         carbs: 0,
         calories: 0,
         fat: 0,
         info: ""
     )
   
]


