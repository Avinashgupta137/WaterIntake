//
//  ContentView.swift
//  WaterIntakeUI
//
//  Created by Avinash Gupta on 14/08/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterIntake.date, ascending: false)],
        animation: .default)
    private var waterLogs: FetchedResults<WaterIntake>

    @State private var amount: Double = 0
    @State private var unit: String = "ml"
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
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
                }

                Button(action: addLog) {
                    Text(isEditing ? "Update Log" : "Add Log")
                        .foregroundColor(.white)
                        .padding()
                        .background(isEditing ? Color.green : Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                List {
                    ForEach(waterLogs) { log in
                        NavigationLink(destination: LogDetailView(log: log)) {
                            HStack {
                                Text("\(log.amount, specifier: "%.0f") \(log.unit ?? "")")
                                Spacer()
                                Text(log.date ?? Date(), style: .time)
                            }
                        }
                    }
                    .onDelete(perform: deleteLogs)
                }
            }
            .padding()
            .navigationTitle("Water Intake")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func addLog() {
        withAnimation {
            if isEditing {
                // Update existing log
                let existingLog = waterLogs.first { $0.date?.isInToday ?? false }
                existingLog?.amount = amount
                existingLog?.unit = unit
            } else {
                // Create a new log
                let newLog = WaterIntake(context: viewContext)
                newLog.id = UUID()
                newLog.date = Date()
                newLog.amount = amount
                newLog.unit = unit
            }

            saveContext()
        }
    }

    private func deleteLogs(offsets: IndexSet) {
        withAnimation {
            offsets.map { waterLogs[$0] }.forEach(viewContext.delete)
            saveContext()
        }
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
