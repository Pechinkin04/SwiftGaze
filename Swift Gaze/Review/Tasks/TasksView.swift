//
//  TasksView.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 21.06.2024.
//

import SwiftUI

struct TasksView: View {
    
    @Binding var shedule: [Record]
    @Binding var categories: [CategoryRecord]
    
    @State var showAddRecord = false
    
    @State var showEditRecord = false
    @State var pickerEditRecordIndex = 0
    
    @State private var pickedGroup = TaskGroup.urgently
    var groups = [TaskGroup.urgently,
                  TaskGroup.secondary,
                  TaskGroup.notUrgent]
    
    init(shedule: Binding<[Record]>, categories: Binding<[CategoryRecord]>) {
        self._shedule = shedule
        self._categories = categories
        
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
                Color.bgDark.ignoresSafeArea()
                //                Color.bgDark.edgesIgnoringSafeArea(.top)
                
                VStack {
                    Text("Tasks")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.textWhite)
                    
                    Picker("Picked group:", selection: $pickedGroup) {
                        ForEach(groups, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if shedule.isEmpty {
                        EmptyRecordCard(showAddRecord: $showAddRecord)
                    } else {
                        List($shedule) { record in
                            Button {
                                pickerEditRecordIndex = findIndexPick(record.wrappedValue)
                                print(pickerEditRecordIndex, record.text)
                                showEditRecord = true
                            } label : {
                                ZStack {
                                    Color.textWhite
                                    
                                    VStack(spacing: 8) {
                                        HStack {
                                            Text(record.text.wrappedValue)
                                                .font(.headline)
                                                .foregroundColor(.textBlack)
                                            Spacer()
                                            
                                            Group {
                                                Text("All")
                                                    .fontWeight(.semibold)
                                                Image(systemName: "chevron.right")
                                            }
                                            .font(.body)
                                            .foregroundColor(.buttonNormal)
                                        }
                                        
                                        var filteredTasks: [TaskRecord] {
                                            Array(record.tasks.wrappedValue.filter { $0.group == pickedGroup }.prefix(3))
                                        }
                                        
                                        ForEach(filteredTasks, id: \.self) { task in
                                            HStack{
                                                Image(systemName: task.done ? "checkmark.circle" : "circle")
                                                    .font(.body)
                                                    .foregroundColor(task.done ? .buttonSave : .textGray)
                                                
                                                Text(task.text)
                                                    .font(.body)
                                                    .foregroundColor(.textBlack)
                                                
                                                Spacer()
                                            }
                                        }
                                        .padding(.top, 2)
                                    }
                                    .padding(24)
                                }
                                    
                            }
//                                .onTapGesture {
//                                    //                                    showEditRecord.toggle()
//                                    pickerEditRecordID = record.wrappedValue.id
//                                    print(pickerEditRecordID, record.wrappedValue.id)
//                                    showEditRecord = true
//                                }
                            .cornerRadius(12)
                            .listRowBackground(Color.bgDark)
                            .animation(.spring)
                        }
                        .listStyle(.plain)
                    }
                    
                    Spacer()
                }
                
                .opacity(showAddRecord ? 0.4 : 1)
                .disabled(showAddRecord)
                
                AddRecordView(showAddRecord: $showAddRecord,
                              shedule: $shedule,
                              categories: $categories)
            }
            .sheet(isPresented: $showEditRecord) {
                EditTaskView(showEditTaskView: $showEditRecord,
                             shedule: $shedule, 
                             idRecord: pickerEditRecordIndex,
                             pickedGroup: $pickedGroup)
            }
            
            .navigationBarItems(trailing:
                                    Button {
                withAnimation {
                    showAddRecord = true
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.textWhite)
                    .opacity(showAddRecord ? 0 : 1)
            }
            )
        }
    }
    
    private func findIndexPick(_ record: Record) -> Int {
        for i in 0..<shedule.count {
            if shedule[i].id == record.id {
                return i
            }
        }
        return 0
    }
}

#Preview {
    TasksView(shedule: .constant(MockData.shedule),
              categories: .constant(MockData.categories))
}

struct EmptyRecordCard: View {
    
    @Binding var showAddRecord: Bool
    
    var body: some View {
        VStack {
            Text("You haven't added any entries")
                .font(.headline)
                .foregroundColor(.textBlack)
            
            Image("PersonForRecord")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
            Button {
                withAnimation {
                    showAddRecord = true
                }
            } label: {
                VStack {
                    
                    Label("Add", systemImage: "plus")
                        .font(.body)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.buttonNormal)
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.textWhite)
        .cornerRadius(16)
        .padding()
    }
}
