//
//  APIFoods.swift
//  cafoll
//
//  Created by mücahit öztürk on 2.01.2024.
//

import Foundation


var searchResults: [String: [String: Float]] = [:]
var foodDictionary: [String: [String: Float]] = [
    "elma": [
        "protein": 0.26,
        "carbs": 13.81,
        "calories": 52.00,
        "fat": 0.17
    ],
    "muz": [
        "protein": 1.09,
        "carbs": 22.84,
        "calories": 89.00,
        "fat": 0.33
    ],
    "çilek": [
        "protein": 0.67,
        "carbs": 7.68,
        "calories": 32.00,
        "fat": 0.30
    ],
    "portakal": [
        "protein": 0.70,
        "carbs": 11.54,
        "calories": 46.00,
        "fat": 0.21
    ],
    "karpuz": [
        "protein": 0.61,
        "carbs": 7.55,
        "calories": 30.00,
        "fat": 0.15
    ],
    "ananas": [
        "protein": 0.54,
        "carbs": 13.12,
        "calories": 50.00,
        "fat": 0.12
    ],
    "armut": [
        "protein": 0.36,
        "carbs": 15.23,
        "calories": 57.00,
        "fat": 0.14
    ],
    "şeftali": [
        "protein": 0.91,
        "carbs": 9.54,
        "calories": 39.00,
        "fat": 0.25
    ],
    "kiraz": [
        "protein": 1.06,
        "carbs": 16.01,
        "calories": 63.00,
        "fat": 0.20
    ],
    "mandalina": [
        "protein": 0.81,
        "carbs": 13.34,
        "calories": 53.00,
        "fat": 0.31
    ],
    "nar": [
        "protein": 1.67,
        "carbs": 18.70,
        "calories": 83.00,
        "fat": 0.17
    ],
    "mango": [
        "protein": 0.82,
        "carbs": 14.98,
        "calories": 60.00,
        "fat": 0.38
    ],
    "erik": [
        "protein": 0.70,
        "carbs": 11.42,
        "calories": 46.00,
        "fat": 0.28
    ],
    "ahududu": [
        "protein": 1.20,
        "carbs": 11.94,
        "calories": 52.00,
        "fat": 0.65
    ],
    "dut": [
        "protein": 1.30,
        "carbs": 8.10,
        "calories": 44.00,
        "fat": 0.00
    ],
    "kavun": [
        "protein": 1.11,
        "carbs": 6.58,
        "calories": 28.00,
        "fat": 0.10
    ],
    "ayva": [
        "protein": 0.35,
        "carbs": 13.92,
        "calories": 60.00,
        "fat": 0.14
    ],
    "limon": [
        "protein": 0.44,
        "carbs": 8.73,
        "calories": 46.00,
        "fat": 0.36
    ],
    "üzüm": [
        "protein": 0.72,
        "carbs": 18.10,
        "calories": 69.00,
        "fat": 0.16
    ],
    "kivi": [
        "protein": 0.14,
        "carbs": 14.66,
        "calories": 61.00,
        "fat": 0.52
    ],
    "avakado": [
        "protein": 2.00,
        "carbs": 8.53,
        "calories": 160.00,
        "fat": 14.66
    ],
    "ceviz": [
        "protein": 15.20,
        "carbs": 13.71,
        "calories": 654.00,
        "fat": 65.20
    ],
    "antep fıstığı": [
        "protein": 17.64,
        "carbs": 11.55,
        "calories": 575.00,
        "fat": 51.60
    ],
    "yulaf ezmesi": [
        "protein": 16.89,
        "carbs": 66.27,
        "calories": 389.00,
        "fat": 6.90
    ],
    "beyaz peynir": [
        "protein": 20.38,
        "carbs": 2.53,
        "calories": 310.00,
        "fat": 24.31
    ],
    "yumurta": [
        "protein": 12.56,
        "carbs": 0.72,
        "calories": 143.00,
        "fat": 9.51
    ],
    "zeytin": [
        "protein": 1.80,
        "carbs": 1.10,
        "calories": 207.00,
        "fat": 21.00
    ],
    "domates": [
        "protein": 0.88,
        "carbs": 3.89,
        "calories": 18.00,
        "fat": 0.20
    ],
    "salatalık": [
        "protein": 0.62,
        "carbs": 1.81,
        "calories": 12.00,
        "fat": 0.20
    ],
    "bal": [
        "protein": 0.38,
        "carbs": 82.40,
        "calories": 304.00,
        "fat": 0.00
    ],
    "yoğurt": [
        "protein": 3.47,
        "carbs": 4.66,
        "calories": 61.00,
        "fat": 3.25
    ],
    "süt": [
        "protein": 3.30,
        "carbs": 4.70,
        "calories": 61.00,
        "fat": 3.30
    ],
    "tam buğday ekmek": [
        "protein": 12.45,
        "carbs": 42.71,
        "calories": 252.00,
        "fat": 3.50
    ],
    "fındık": [
        "protein": 14.95,
        "carbs": 16.70,
        "calories": 628.00,
        "fat": 60.75
    ],
    "badem": [
        "protein": 18.60,
        "carbs": 19.50,
        "calories": 598.00,
        "fat": 54.20
    ],
    "kayısı": [
        "protein": 1.40,
        "carbs": 11.12,
        "calories": 48.00,
        "fat": 0.39
    ],
    "ayran": [
        "protein": 1.98,
        "carbs": 2.71,
        "calories": 37.00,
        "fat": 2.00
    ],
    "portakal suyu": [
        "protein": 0.40,
        "carbs": 14.64,
        "calories": 60.00,
        "fat": 0.17
    ],
    "fıstık ezmesi": [
        "protein": 24.06,
        "carbs": 21.57,
        "calories": 589.00,
        "fat": 49.94
    ],
    "pastırma": [
        "protein": 29.5,
        "carbs": 0.00,
        "calories": 250.00,
        "fat": 13.90
    ],
    "ızgara antrikot": [
        "protein": 18.90,
        "carbs": 0.58,
        "calories": 182.00,
        "fat": 11.04
    ],
    "balık": [
        "protein": 18.30,
        "carbs": 0.00,
        "calories": 82.00,
        "fat": 0.90
    ],
    "mercimek çorbası": [
        "protein": 1.11,
        "carbs": 3.99,
        "calories": 23.00,
        "fat": 0.11
    ],
    "hindi but": [
        "protein": 27.87,
        "carbs": 0.00,
        "calories": 208.00,
        "fat": 9.82
    ],
    "karnabahar": [
        "protein": 1.84,
        "carbs": 4.11,
        "calories": 23.00,
        "fat": 0.45
    ],
    "kuru fasulye": [
        "protein": 6.57,
        "carbs": 9.91,
        "calories": 97.00,
        "fat": 1.35
    ],
    "patlıcan ezme": [
        "protein": 1.28,
        "carbs": 3.25,
        "calories": 29.00,
        "fat": 1.20
    ],
    "kabak": [
        "protein": 1.60,
        "carbs": 2.05,
        "calories": 19.00,
        "fat": 0.40
    ],
    "tabule": [
        "protein": 7.14,
        "carbs": 50.81,
        "calories": 261.00,
        "fat": 4.34
    ],
    "yaprak sarma": [
        "protein": 3.37,
        "carbs": 17.82,
        "calories": 96.00,
        "fat": 1.32
    ],
    "brokoli salatası": [
        "protein": 1.46,
        "carbs": 7.67,
        "calories": 54.00,
        "fat": 1.63
    ],
    "kuzu şiş": [
        "protein": 16.52,
        "carbs": 3.82,
        "calories": 167.00,
        "fat": 9.72
    ],
    "fırın patates": [
        "protein": 1.55,
        "carbs": 14.36,
        "calories": 107.00,
        "fat": 4.79
    ],
    "enginar": [
        "protein": 3.27,
        "carbs": 10.51,
        "calories": 47.00,
        "fat": 0.15
    ],
    "ıspanak yemeği": [
        "protein": 2.55,
        "carbs": 5.71,
        "calories": 76.00,
        "fat": 4.64
    ],
    "bulgur pilavı": [
        "protein": 2.78,
        "carbs": 18.19,
        "calories": 114.00,
        "fat": 3.39
    ],
    "kuzu kıyma": [
        "protein": 16.56,
        "carbs": 0.00,
        "calories": 282.00,
        "fat": 23.41
    ],
    "FOOOOOD": [
        "protein": 0,
        "carbs": 0,
        "calories": 0,
        "fat": 0
    ]
   
]


