//
//  EditTaskView.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 22.06.2024.
//

import SwiftUI

struct EditTaskView: View {
    
    @Binding var showEditTaskView: Bool
    
    @Binding var shedule: [Record]
    @State var idRecord: Int
    
    var filteredTasks: [TaskRecord] {
            shedule[idRecord].tasks.filter { $0.group == pickedGroup }
    }
    
    @Binding var pickedGroup: TaskGroup
    var groups = [TaskGroup.urgently,
                  TaskGroup.secondary,
                  TaskGroup.notUrgent]
    
    init(showEditTaskView: Binding<Bool>, shedule: Binding<[Record]>, idRecord: Int, pickedGroup: Binding<TaskGroup>) {
        self._showEditTaskView = showEditTaskView
        self._shedule = shedule
        self.idRecord = idRecord
        self._pickedGroup = pickedGroup
        
        // Sets the background color of the Picker
        UISegmentedControl.appearance().backgroundColor = .white
        // Disappears the divider
        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        // Changes the color for the selected item
        UISegmentedControl.appearance().selectedSegmentTintColor = .buttonNormal
        // Changes the text color for the selected item
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    
    }
    
    var body: some View {
        NavigationView {
            
            ZStack {
                Color.textWhite
                
                VStack {
                    Picker("Picked group:", selection: $pickedGroup) {
                        ForEach(groups, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    
                    List(filteredTasks.indices, id: \.self) { index in
                        let normalIndex = findIndexFilteredInRecord(index)
                        let task = shedule[idRecord].tasks[normalIndex]
                        HStack{
                            Image(systemName: task.done ? "checkmark.circle" : "circle")
                                .font(.body)
                                .foregroundColor(task.done ? .buttonSave : .textGray)
                                .onTapGesture {
                                    toggleDone(index)
                                    UserDefaults.standard.setShedule(shedule, forKey: "sheduleSwift")
                                }
                            
                            //                            TextField("Text", text: .constant(task.text))
                            TextField("Text", text: $shedule[idRecord].tasks[normalIndex].text)
                            //                            Text(task.text)
                                .font(.body)
                                .foregroundColor(.textBlack)
                            
                            Spacer()
                            
                            Image(systemName: "trash")
                                .font(.body)
                                .foregroundColor(.red)
                                .onTapGesture {
                                    deleteFilteredRecord(index)
                                }
                        }
                        
                    }
                    .listStyle(.plain)
                    .padding()
                    
                    Button {
                        withAnimation {
                            shedule[idRecord].tasks.insert(TaskRecord(text: "",
                                                                      done: false,
                                                                      group: pickedGroup),
                                                           at: 0)
                            UserDefaults.standard.setShedule(shedule, forKey: "sheduleSwift")
//                            print("\n====\n")
//                            for task in shedule[idRecord].tasks { print(task, terminator: "!!\n")}
////                            print(shedule[idRecord].tasks, terminator: "!!!!\n\n")
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.buttonNormal, lineWidth: 2)
                            Label("Add", systemImage: "plus")
                                .font(.body)
                                .background(Color.white)
                        }
                        .frame(height: 56)
                    }
                    .padding(.horizontal)
                    
                }
                
            }
        
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(shedule[idRecord].text)
            .navigationBarItems(trailing: Button {
                showEditTaskView = false
            } label: {
                Text("Save")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.buttonSave)
            })
        }
        
    }
    
    private func findIndexFilteredInRecord(_ index: Int) -> Int {
        for i in 0..<shedule[idRecord].tasks.count {
            if shedule[idRecord].tasks[i] == filteredTasks[index] {
                return i
            }
        }
        return 0
    }
    
    private func toggleDone(_ index: Int) {
        let normalIndex = findIndexFilteredInRecord(index)
        shedule[idRecord].tasks[normalIndex].done.toggle()
        UserDefaults.standard.setShedule(shedule, forKey: "sheduleSwift")
    }
    
    private func deleteFilteredRecord(_ index: Int) {
        let normalIndex = findIndexFilteredInRecord(index)
        shedule[idRecord].tasks.remove(at: normalIndex)
        UserDefaults.standard.setShedule(shedule, forKey: "sheduleSwift")
    }
}

#Preview {
    EditTaskView(showEditTaskView: .constant(true), 
                 shedule: .constant(MockData.shedule),
                 idRecord: 4,
                 pickedGroup: .constant(.urgently))
}
