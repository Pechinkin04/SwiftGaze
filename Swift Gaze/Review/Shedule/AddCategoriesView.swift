//
//  AddCategoriesView.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 20.06.2024.
//

import SwiftUI

struct AddCategoriesView: View {
    
    @Binding var categories: [CategoryRecord]
    @Binding var shedule: [Record]
    @Binding var showAddCategoriesView: Bool
    
    @State var showDeleteAlert = false
    @State var deleteAlertIndex = UUID()
    
    @State private var isKeyboardActive = false
    
    @State var showPickImageBool = false
    @State var showPickImageIndex = UUID()
    var pickImages = ["hands.sparkles.fill", "star.fill", "bolt.fill", "flame.fill", "hand.draw.fill", "heart.fill"]

    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color.textWhite
                
                VStack {
                    
                    List($categories) { $category in
                        VStack {
                            HStack {
                                
                                Button {
                                    withAnimation(.smooth) {
                                        if showPickImageBool == false {
                                            showPickImageBool = true
                                            showPickImageIndex = category.id
                                        } else if showPickImageIndex != category.id {
                                            showPickImageIndex = category.id
                                        } else {
                                            showPickImageBool = false
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        Color.buttonNormal
                                        
                                        Image(systemName: category.img.rawValue)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.textWhite)
                                    }
                                    .frame(width: 48, height: 48)
                                    .cornerRadius(8)
                                }
//                                    .onTapGesture {
//                                        if showPickImageBool == false {
//                                            showPickImageBool = true
//                                            showPickImageIndex = category.id
//                                        } else if showPickImageIndex != category.id {
//                                            showPickImageIndex = category.id
//                                        } else {
//                                            showPickImageBool = false
//                                        }
////                                        showPickImageBool.toggle()
////                                        showPickImageIndex = category.id
//                                    }
                                
                                
                                Spacer().frame(width: 20)
                                
                                TextField("Text", text: $category.text)
                                    .font(.body)
                                    .foregroundColor(.textBlack)
                                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                                        isKeyboardActive = true
                                    }
                                    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                        isKeyboardActive = false
                                    }
                                
                                
                                
                                Spacer()
//                                
//                                Button {
//                                    //                                showDeleteAlert.toggle()
//                                    withAnimation {
//                                        deleteCategory(category)
//                                    }
//                                } label: {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.buttonNormal)
//                                }
                                        .onTapGesture {
                                            showDeleteAlert.toggle()
                                            deleteAlertIndex = category.id
//                                            deleteCategory(category)
                                        }
                                .alert(isPresented: $showDeleteAlert, content: {
                                    Alert(title: Text("Are you sure?"),
                                          message: Text("Records in this category\nwill also be deleted"),
                                          primaryButton: .destructive(Text("Delete"),
                                                                      action: {
                                        withAnimation {
                                            deleteCategory(deleteAlertIndex)
                                        }
                                    }),
                                          secondaryButton: .cancel(Text("Cancel")))
                                })
                            }
                            
                            if showPickImageBool, showPickImageIndex == category.id {
                                HStack {
                                    ForEach(ImageCategory.allCases, id: \.self) { categoryIMG in
                                        ZStack {
                                            if category.img.rawValue == categoryIMG.rawValue {
                                                Color.buttonNormal
                                            } else {
                                                Color.buttonDisabled
                                            }
                                            
                                            Image(systemName: categoryIMG.rawValue)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.textWhite)
                                        }
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            category.img = categoryIMG
                                        }
                                        
                                        if categoryIMG != ImageCategory.allCases.last {
                                            Spacer()
                                        }
                                    }
                                }
                                .frame(width: .infinity)
                            }
                        }
                    }
                    .listStyle(.plain)
                 
                    Button {
                        withAnimation {
                            categories.append(CategoryRecord(img: .fire, text: ""))
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.buttonNormal, lineWidth: 2)
                            
                            Label("Add", systemImage: "plus")
                                .font(.body)
                                .foregroundColor(.buttonNormal)
                        }
                        .frame(width: .infinity, height: 56)
                        .padding()
                    }
                    
                    Spacer()
                }
                
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Categories")
            .navigationBarItems(trailing:
                Button {
                    showAddCategoriesView = false
                } label: {
                    Text("Save")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.buttonSave)
                })
        }
        
    }
    
    private func deleteCategory(_ categoryID: UUID) {
        for i in 0..<categories.count {
            print(categoryID, categories[i].id)
            
            if categories[i].id == categoryID {
                categories.remove(at: i)
                var j = shedule.count - 1
                while j >= 0 {
                    print(shedule[j].category.text, shedule[j].text, j)
                    if shedule[j].category.id == categoryID {
                        deleteRecord(shedule[j])
                    }
                    j -= 1
                }
                return
            }
            
        }
    }
    
    private func deleteRecord(_ record: Record) {
        var i = shedule.count - 1
//        for i in 0..<shedule.count {
        while i >= 0 {
            if record.id == shedule[i].id {
                shedule.remove(at: i)
                return
            }
            i -= 1
        }
    }
}

#Preview {
    AddCategoriesView(categories: .constant(MockData.categories),
                      shedule: .constant(MockData.shedule),
                      showAddCategoriesView: .constant(true))
}
