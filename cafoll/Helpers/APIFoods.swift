//
//  APIFoods.swift
//  cafoll
//
//  Created by mücahit öztürk on 2.01.2024.
//

import Foundation


var searchResults: [String: [String: Double]] = [:]
var foodDictionary: [String: [String: Double]] = [
    "elma": [
        "protein": 0.01,
        "carbs": 0.12,
        "calories": 0.52,
        "fat": 0
    ],
    "muz": [
        "protein": 0.02,
        "carbs": 0.12,
        "calories": 0.89,
        "fat": 0
    ],
    "çilek": [
        "protein": 0.01,
        "carbs": 0.07,
        "calories": 0.32,
        "fat": 0
    ],
    "portakal": [
        "protein": 0,
        "carbs": 0.08,
        "calories": 0.43,
        "fat": 0
    ],
    "karpuz": [
        "protein": 0,
        "carbs": 0.06,
        "calories": 0.30,
        "fat": 0
    ],
    "ananas": [
        "protein": 0.01,
        "carbs": 0.13,
        "calories": 0.50,
        "fat": 0
    ],
    "armut": [
        "protein": 0,
        "carbs": 0.15,
        "calories": 0.57,
        "fat": 0
    ],
    "şeftali": [
        "protein": 0,
        "carbs": 0.09,
        "calories": 0.39,
        "fat": 0
    ],
    "kiraz": [
        "protein": 0.01,
        "carbs": 0.13,
        "calories": 0.50,
        "fat": 0
    ],
    "mandalina": [
        "protein": 0.01,
        "carbs": 0.13,
        "calories": 0.53,
        "fat": 0
    ],
    "nar": [
        "protein": 0.02,
        "carbs": 0.18,
        "calories": 0.83,
        "fat": 0
    ],
    "mango": [
        "protein": 0.01,
        "carbs": 0.14,
        "calories": 0.60,
        "fat": 0
    ],
    "erik": [
        "protein": 0.01,
        "carbs": 0.09,
        "calories": 0.38,
        "fat": 0
    ],
    "ahududu": [
        "protein": 0.01,
        "carbs": 0.05,
        "calories": 0.52,
        "fat": 0.01
    ],
    "dut": [
        "protein": 0.01,
        "carbs": 0.09,
        "calories": 0.48,
        "fat": 0
    ],
    "ekşi kiraz": [
        "protein": 0.01,
        "carbs": 0.09,
        "calories": 0.48,
        "fat": 0.01
    ],
    "kavun": [
        "protein": 0.01,
        "carbs": 0.07,
        "calories": 0.34,
        "fat": 0
    ],
    "ayva": [
        "protein": 0.01,
        "carbs": 0.11,
        "calories": 0.42,
        "fat": 0
    ],
    "limon": [
        "protein": 0.01,
        "carbs": 0.09,
        "calories": 0.29,
        "fat": 0
    ],
    "üzüm": [
        "protein": 0.01,
        "carbs": 0.18,
        "calories": 0.68,
        "fat": 0
    ],
    "kivi": [
        "protein": 0.01,
        "carbs": 0.09,
        "calories": 0.49,
        "fat": 0.01
    ],
    "avakado": [
        "protein": 0.02,
        "carbs": 0.09,
        "calories": 1.57,
        "fat": 0.15
    ],
    "ceviz": [
        "protein": 0.15,
        "carbs": 0.01,
        "calories": 6.36,
        "fat": 0.13
    ],
    "antep fıstığı": [
        "protein": 0.22,
        "carbs": 0.03,
        "calories": 5.58,
        "fat": 0.09
    ],
    "yulaf ezmesi": [
        "protein": 0.025,
        "carbs": 0.003,
        "calories": 0.696,
        "fat": 0.015
    ],
    "peynir": [
        "protein": 0.227,
        "carbs": 0.005,
        "calories": 3.939,
        "fat": 0.33
    ],
    "yumurta": [
        "protein": 0.125,
        "carbs": 0.004,
        "calories": 1.47,
        "fat": 0.097
    ],
    "zeytin": [
        "protein": 0.008,
        "carbs": 0,
        "calories": 1.134,
        "fat": 0.108
    ],
    "domates": [
        "protein": 0.009,
        "carbs": 0.026,
        "calories": 0.182,
        "fat": 0.002
    ],
    "salatalık": [
        "protein": 0.006,
        "carbs": 0.017,
        "calories": 0.153,
        "fat": 0.001
    ],
    "reçel": [
        "protein": 0.003,
        "carbs": 0.826,
        "calories": 3.029,
        "fat": 0
    ],
    "bal": [
        "protein": 0.003,
        "carbs": 0.048,
        "calories": 0.602,
        "fat": 0.032
    ],
    "yoğurt": [
        "protein": 0.053,
        "carbs": 0.071,
        "calories": 0.642,
        "fat": 0.016
    ],
    "süt": [
        "protein": 0.032,
        "carbs": 0.048,
        "calories": 0.602,
        "fat": 0.032
    ],
    "tam buğday ekmek": [
        "protein": 0.124,
        "carbs": 0.06,
        "calories": 2.463,
        "fat": 0.034
    ],
    "fındık": [
        "protein": 0.149,
        "carbs": 0.094,
        "calories": 6.562,
        "fat": 0.615
    ],
    "badem": [
        "protein": 0.207,
        "carbs": 0.108,
        "calories": 6.068,
        "fat": 0.517
    ],
    "kayısı": [
        "protein": 0.014,
        "carbs": 0.02,
        "calories": 0.483,
        "fat": 0.004
    ],
    "ayran": [
        "protein": 0.033,
        "carbs": 0,
        "calories": 0.402,
        "fat": 0.009
    ],
    "portakal suyu": [
        "protein": 0.007,
        "carbs": 0.003,
        "calories": 0.464,
        "fat": 0.001
    ],
    "fıstık ezmesi": [
        "protein": 0.221,
        "carbs": 0.056,
        "calories": 5.797,
        "fat": 0.496
    ],
    "pastırma": [
        "protein": 0.218,
        "carbs": 0.001,
        "calories": 1.466,
        "fat": 0.058
    ],
    "ızgara tavuk": [
        "protein": 0.295,
        "carbs": 0,
        "calories": 1.524,
        "fat": 0.035
    ],
    "balık": [
        "protein": 0.26,
        "carbs": 0,
        "calories": 1.292,
        "fat": 0.027
    ],
    "mercimek çorbası": [
        "protein": 0.113,
        "carbs": 0.081,
        "calories": 0.564,
        "fat": 0.011
    ],
    "hindi": [
        "protein": 0.286,
        "carbs": 0.001,
        "calories": 0.193,
        "fat": 0.074
    ],
    "karnabahar püresi": [
        "protein": 0.029,
        "carbs": 0.021,
        "calories": 0.09,
        "fat": 0.074
    ],
    "fasulye": [
        "protein": 0.087,
        "carbs": 0.019,
        "calories": 0.129,
        "fat": 0.005
    ],
    "ratatuy": [
        "protein": 0.01,
        "carbs": 0.021,
        "calories": 0.058,
        "fat": 0.033
    ],
    "kabak": [
        "protein": 0.011,
        "carbs": 0.017,
        "calories": 0.014,
        "fat": 0.004
    ],
    "tabule": [
        "protein": 0.02,
        "carbs": 0.009,
        "calories": 0.086,
        "fat": 0.045
    ],
    "yaprak sarma": [
        "protein": 0.11,
        "carbs": 0.022,
        "calories": 0.193,
        "fat": 0.116
    ],
    "brokoli salatası": [
        "protein": 0.09,
        "carbs": 0.078,
        "calories": 0.113,
        "fat": 0.004
    ],
    "kuzu şiş": [
        "protein": 0.244,
        "carbs": 0,
        "calories": 0.126,
        "fat": 0.086
    ],
    "fırın patates": [
        "protein": 0.025,
        "carbs": 0.005,
        "calories": 0.038,
        "fat": 0.001
    ],
    "enginar": [
        "protein": 0.029,
        "carbs": 0.057,
        "calories": 0.022,
        "fat": 0.003
    ],
    "ıspanak": [
        "protein": 0.029,
        "carbs": 0.004,
        "calories": 0.01,
        "fat": 0.003
    ],
    "bulgur": [
        "protein": 0.031,
        "carbs": 0.001,
        "calories": 0.042,
        "fat": 0
    ],
    "kuzu tandır": [
        "protein": 0.244,
        "carbs": 0,
        "calories": 2,
        "fat": 0.086
    ],
    "FOOOOOD": [
        "protein": 0,
        "carbs": 0,
        "calories": 0,
        "fat": 0
    ]
   
]


