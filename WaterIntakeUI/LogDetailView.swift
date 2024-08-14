//
//  LogDetailView.swift
//  WaterIntakeUI
//
//  Created by Avinash Gupta on 14/08/24.
//

import SwiftUI
import CoreData

struct LogDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var log: WaterIntake
    @State private var amount: Double
    @State private var unit: String

    init(log: WaterIntake) {
        self.log = log
        _amount = State(initialValue: log.amount)
        _unit = State(initialValue: log.unit ?? "ml")
    }

    var body: some View {
        VStack {
            TextField("Amount", value: $amount, format: .number)
                .keyboardType(.decimalPad)
                .padding()
                .border(Color.gray)

            Picker("Unit", selection: $unit) {
                Text("ml").tag("ml")
                Text("oz").tag("oz")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button(action: saveChanges) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            Button(action: deleteLog) {
                Text("Delete")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    private func saveChanges() {
        log.amount = amount
        log.unit = unit

        saveContext()
    }

    private func deleteLog() {
        viewContext.delete(log)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
extension Date {
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
}
