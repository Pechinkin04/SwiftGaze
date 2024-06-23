//
//  SheduleView.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 19.06.2024.
//

import SwiftUI

struct SheduleView: View {
    
    @Binding var shedule: [Record]
//    @EnvironmentObject var shedule: SheduleObservable
    @Binding var categories: [CategoryRecord]
    
    @State var showAddRecord = false
    
    @State var pickedCategory: CategoryRecord?
    
    @State private var pickedGroup = "Upcoming"
    var groups = ["Upcoming", "Completed"]
    
    var filterGroup: [Record] {
        if pickedGroup ==  "Upcoming" {
            shedule.filter { $0.completed == false }
        } else {
            shedule.filter { $0.completed == true }
        }
    }
    
    var filterCategory: [Record] {
        if pickedCategory == nil {
            filterGroup
        } else {
            filterGroup.filter { $0.category.id == pickedCategory?.id}
        }
    }
    
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
                    Text("Shedule")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.textWhite)
                    
                    ScrollCategory(pickedCategory: $pickedCategory, categories: $categories, shedule: $shedule)
                    
                    Picker("Picked group:", selection: $pickedGroup) {
                        ForEach(groups, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    if filterCategory.isEmpty {
                        EmptyRecordCard(showAddRecord: $showAddRecord)
                    } else {
                        List(filterCategory) { record in
                            RecordCard(record: record, shedule: $shedule)
                        }
                        .listStyle(.plain)
                        .animation(.linear)
                    }

                    
                    Spacer()
                }
                .opacity(showAddRecord ? 0.4 : 1)
                .disabled(showAddRecord)
                
                AddRecordView(showAddRecord: $showAddRecord,
                              shedule: $shedule,
                              categories: $categories)
                
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

}

#Preview {
    SheduleView(shedule: .constant(MockData.shedule), 
                categories: .constant(MockData.categories))
}

struct CategoryCard: View {
    
    @Binding var pickedCategory: CategoryRecord?
    var category: CategoryRecord?
    var isAll = false
    
    var body: some View {
        ZStack {
            Color.bgCard1
            
            HStack {
                ZStack {
                    if pickedCategory == nil, isAll {
                        Color.buttonNormal
                    } else if pickedCategory?.id == category?.id {
                        Color.buttonNormal
                    } else {
                        Color.buttonDisabled
                    }
                    Image(systemName: isAll ? "scroll.fill" : category?.img.rawValue ?? "")
                        .foregroundColor(.textWhite)
                }
                .frame(width: 48, height: 48)
                .cornerRadius(8)
                
                Text(isAll ? "All" : category?.text ?? "")
                    .font(.callout)
                    .foregroundColor(.textBlack)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .frame(height: 72)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.3), radius: 3, y: 6)
        .padding(.vertical, 4)
    }
}

struct RecordCard: View {
    
    @State var record: Record
    @Binding var shedule: [Record]
    
    @State var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.white
            
            HStack {
                VStack {
                    if record.completed {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.buttonSave)
                    } else {
                        Image(systemName: "circle")
                    }
                }
                .onTapGesture {
                    toogleCompleteRecord(record)
                }
                
                Spacer().frame(width: 12)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(record.text)
                            .font(.body)
                            .foregroundColor(.textBlack)
                        
                        Text("\(formatDate(record.date))")
                            .font(.subheadline)
                            .foregroundColor(.textGray)
                    }
                    
                    Spacer()
                    
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.buttonNormal, lineWidth: 2)
                        
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.buttonNormal)
                    }
                    .padding(1)
                    .frame(width: 56, height: 56)
                    .onTapGesture {
                        showDeleteAlert.toggle()
                        //                        deleteRecord(record)
                    }
                    .alert(isPresented: $showDeleteAlert, content: {
                        Alert(title: Text("Are you sure?"),
                              primaryButton: .destructive(Text("Delete"),
                                                          action: {
                            withAnimation {
                                deleteRecord(record)
                            }
                        }),
                              secondaryButton: .cancel(Text("Cancel")))
                    })
                    
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .cornerRadius(16)
        .listRowBackground(Color.bgDark)
    }
    
    
    private func toogleCompleteRecord(_ record: Record) {
        for i in 0..<shedule.count {
            print(record.id, shedule[i].id)
            if shedule[i].id == record.id {
                var newRecord = record
                newRecord.completed = !record.completed
                shedule[i] = newRecord
                return
            }
        }
    }
    
    private func deleteRecord(_ record: Record) {
        for i in 0..<shedule.count {
            print(record.id, shedule[i].id)
            if shedule[i].id == record.id {
                shedule.remove(at: i)
                return
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}

struct AddRecordView: View {
    
    @Binding var showAddRecord: Bool
    
    @Binding var shedule: [Record]
    @Binding var categories: [CategoryRecord]
    @State var pickedCategory: CategoryRecord?
    
    @State var textNewRecord = ""
    @State var datePicker = Date()
    
    var body: some View {
        VStack {
            Text("Record")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textBlack)
                .padding()
            
            if categories.isEmpty {
                Button {
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.buttonNormal, lineWidth: 2)
                        
                        Label("Add a category", systemImage: "plus")
                            .font(.body)
                            .foregroundColor(.buttonNormal)
                    }
                    .frame(width: .infinity, height: 56)
                }
                .sheet(isPresented: $showAddRecord) {
                    AddCategoriesView(categories: $categories, shedule: $shedule, showAddCategoriesView: $showAddRecord)
                }
            } else {
                ScrollCategory(pickedCategory: $pickedCategory, categories: $categories, shedule: $shedule)
            }
            
            TextField("Text", text: $textNewRecord)
                .font(.body)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.textGray, lineWidth: 2)
                )
                .padding(.vertical)
            
            DatePicker("Date of record",
                       selection: $datePicker,
                       displayedComponents: .date)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.textGray, lineWidth: 2)
            )
            
            HStack(spacing: 12) {
                Button {
                    withAnimation {
                        showAddRecord = false
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.buttonNormal, lineWidth: 2)
                        
                        Text("Cancel")
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                    
                }
                
                Button {
                    withAnimation {
                        shedule.insert(Record(category: pickedCategory ?? categories[0],
                                              text: textNewRecord,
                                              date: datePicker,
                                              completed: false, 
                                              tasks: []),
                                       at: 0)
                        showAddRecord = false
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.buttonNormal)
                        
                        Text("Add")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.textWhite)
                    }
                    
                }
                
            }
            .frame(height: 56)
            .padding(.top)
            
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(20)
        .frame(height: 366)
        .opacity(showAddRecord ? 1 : 0)
        .padding()
    }
}

struct ScrollCategory: View {
    
    @Binding var pickedCategory: CategoryRecord?
    @Binding var categories: [CategoryRecord]
    @Binding var shedule: [Record]
    @State var showAddCategoriesView = false
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                
                Button {
                    showAddCategoriesView.toggle()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.buttonNormal, lineWidth: 2)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.buttonNormal)
                    }
                    .padding(1)
                    .frame(width: 56, height: 74)
                }
                .sheet(isPresented: $showAddCategoriesView, content: {
                    AddCategoriesView(categories: $categories,
                                      shedule: $shedule,
                                      showAddCategoriesView: $showAddCategoriesView)
                })
                
                Button {
                    withAnimation {
                        pickedCategory = nil
                    }
                } label: {
                    CategoryCard(pickedCategory: $pickedCategory, isAll: true)
                }
                
                ForEach(categories) { category in
                    Button {
                        withAnimation {
                            pickedCategory = category
                        }
                    } label: {
                        CategoryCard(pickedCategory: $pickedCategory, category: category)
                    }
                }
            }
        }
    }
}
