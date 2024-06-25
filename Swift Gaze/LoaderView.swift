import SwiftUI

struct LoaderView: View {
    
    var isReview = true
    
    var body: some View {
        ZStack {
//                        Color.bgColor.edgesIgnoringSafeArea(.all)
            
            Image(isReview ? "Loader" : "Loader")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            
            ProgressView() // Используем ProgressView для отображения спиннера
                .progressViewStyle(CircularProgressViewStyle()) // Устанавливаем стиль спиннера (круглый в данном случае)
                .scaleEffect(3.0) // Масштабируем спиннер
                .padding() // Добавляем немного отступа
                .accentColor(Color.buttonNormal)
                .offset(y: 200)
            
            // Добавьте спиннер или анимацию загрузки
        }
    }
}

#Preview {
    LoaderView()
}
