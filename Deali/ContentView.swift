//
//  ContentView.swift
//  Deali
//
//  Created by Kirill Pukhov on 12.07.24.
//

import SwiftUI

struct MainView: View {
    @State var events: [Event] = []
    @State var lifes: [Life] = []

    var body: some View {
        VStack(spacing: 8) {
            Text("Клеточное наполнение")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.init(top: 16, leading: 0, bottom: 12, trailing: 0))

            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVStack {
                        ForEach(Array(events.enumerated()), id: \.0) { index, event in
                            cell(for: event)
                                .padding(.vertical, 2)
                                .id(index)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .onChange(of: events) { _ in
                    withAnimation {
                        scrollViewProxy.scrollTo(events.count - 1)
                    }
                }
            }

            createButton
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: .init(
                    colors: [
                        .init(red: 40/255, green: 0/255, blue: 80/255),
                        .black
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    @ViewBuilder
    private var createButton: some View {
        Button(action: createButtonAction) {
            Text("СОТВОРИТЬ")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 90/255, green: 52/255, blue: 144/255))
                )
        }
    }
    
    @ViewBuilder
    private func cell(for event: Event) -> some View {
        let eventType = event.type

        HStack(spacing: 16) {
            Text(eventType.iconEmoji)
                .font(.system(size: 20))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: .init(colors: eventType.iconGradientColors),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )

            VStack(alignment: .leading, spacing: 0) {
                Text(eventType.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.black)

                Text(eventType.subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
        )
    }

    private func createButtonAction() {
        let lastEvents = events.suffix(3)

        if lastEvents.count == 3 {
            var aliveCells = 0
            var deadCells = 0

            for event in lastEvents {
                if case .cellCreation(let cell) = event.type {
                    aliveCells += cell.state == .alive ? 1 : 0
                    deadCells += cell.state == .dead ? 1 : 0
                }
            }

            if aliveCells == 3 {
                let newLife = Life()
                lifes.append(newLife)
                events.append(Event(type: .lifeBirth(newLife)))

                return
            } else if deadCells == 3 {
                if let firstAliveLifeIndex = lifes.firstIndex(where: { $0.state == .alive }) {
                    lifes[firstAliveLifeIndex].state = .dead
                    events.append(Event(type: .lifeDeath(lifes[firstAliveLifeIndex])))

                    return
                }
            }
        }

        events.append(Event(type: .cellCreation(Cell(state: Bool.random() ? .alive : .dead))))
    }
}

private extension EventType {
    var iconEmoji: String {
        switch self {
        case .cellCreation(let cell):
            if cell.state == .alive {
                return "💥"
            } else {
                return "💀"
            }
        case .lifeBirth:
            return "🐣"
        case .lifeDeath:
            return "☠️"
        }
    }

    var iconGradientColors: [Color] {
        switch self {
        case .cellCreation(let cell):
            if cell.state == .alive {
                return [
                    .init(red: 255/255, green: 184/255, blue: 0/255),
                    .init(red: 255/255, green: 247/255, blue: 176/255)
                ]
            } else {
                return [
                    .init(red: 13/255, green: 101/255, blue: 138/255),
                    .init(red: 176/255, green: 255/255, blue: 180/255)
                ]
            }
        case .lifeBirth:
            return [
                .init(red: 173/255, green: 0/255, blue: 255/255),
                .init(red: 255/255, green: 176/255, blue: 233/255)
            ]
        case .lifeDeath:
            return [
                .init(red: 7/255, green: 28/255, blue: 54/255),
                .init(red: 74/255, green: 109/255, blue: 130/255)
            ]
        }
    }

    var title: String {
        switch self {
        case .cellCreation(let cell):
            if cell.state == .alive {
                return "Живая"
            } else {
                return "Мёртвая"
            }
        case .lifeBirth:
            return "Жизнь"
        case .lifeDeath:
            return "Смерть"
        }
    }

    var subtitle: String {
        switch self {
        case .cellCreation(let cell):
            if cell.state == .alive {
                return "И шивелится!"
            } else {
                return "Или прикидывается?"
            }
        case .lifeBirth:
            return "Ку-ку!"
        case .lifeDeath:
            return "Прощай..."
        }
    }
}

#Preview {
    MainView()
}
