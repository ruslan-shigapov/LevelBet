//
//  OnboardingPage.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 26.05.2026.
//

enum OnboardingPage {
    case coupons, statistics, profile
    
    var imageName: String {
        switch self {
        case .coupons: "flag.2.crossed.fill"
        case .statistics: "chart.bar.fill"
        case .profile: "person.crop.rectangle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .coupons: "Добавляй купоны быстро и просто"
        case .statistics: "Анализируй статистику"
        case .profile: "Получай удовольствие"
        }
    }
    
    var descriptions: [String] {
        switch self {
        case .coupons: [
            "Укажи сумму, коэффициенты и вид спорта событий в пару касаний.",
            "Отмечай статус события сразу или позже.",
            "А фильтры по периоду и статусу наглядно отобразят результаты."
        ]
        case .statistics: [
            "Используй фильтр, чтобы видеть динамику по периоду.",
            "Следи за показателями и выявляй точки роста своей стратегии.",
            "А кнопка со знаком вопроса покажет справку при необходимости."
        ]
        case .profile: [
            "Наблюдай за сериями и max значениями, чтобы быть в курсе процесса.",
            "Можешь включить Face ID для безопасного входа.",
            "Или выбери вид спорта по умолчанию для событий в купонах."
        ]
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .coupons, .statistics: "Дальше"
        case .profile: "Начать"
        }
    }
}
