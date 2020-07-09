////
////  Test.swift
////  iShop
////
////  Created by Chris Filiatrault on 24/5/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    let array = ["Peter", "Paul", "Mary", "Anna-Lena", "George", "John", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara"]
//    @State private var searchText = ""
//    @State private var showCancelButton: Bool = false
//
//    var body: some View {
//
//        NavigationView {
//            VStack {
//                // Search view
//                HStack {
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//
//                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
//                            self.showCancelButton = true
//                        }, onCommit: {
//                            print("onCommit")
//                        }).foregroundColor(.primary)
//
//                        Button(action: {
//                            self.searchText = ""
//                        }) {
//                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
//                        }
//                    }
//                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
//                    .foregroundColor(.secondary)
//                    .background(Color(.secondarySystemBackground))
//                    .cornerRadius(10.0)
//
//                    if showCancelButton  {
//                        Button("Cancel") {
//                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
//                                self.searchText = ""
//                                self.showCancelButton = false
//                        }
//                        .foregroundColor(Color(.systemBlue))
//                    }
//                }
//                .padding(10)
//                //.navigationBarHidden(showCancelButton).animation(.default) // animation does not work properly
//
//               
//               
//               
//               
//                List {
//                    // Filtered list of names
//                    ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
//                        searchText in Text(searchText)
//                    }
//                }
//                  
//                  
//                  
//                  
//                  
//                  
//                  
//                .navigationBarTitle(Text("Search"), displayMode: .inline)
//              //  .resignKeyboardOnDragGesture()
//            }
//        }
//    }
//}
//
//
//
//
//
//// Needed?
//extension UIApplication {
//    func endEditing(_ force: Bool) {
//        self.windows
//            .filter{$0.isKeyWindow}
//            .first?
//            .endEditing(force)
//    }
//}
//
//



import SwiftUI

struct ContentView: View {

    let topTier:[String] = ["Apple", "Banana", "Cherry"]
    let nextTier:[String] = ["Abalone", "Brie", "Cheddar"]


    var body: some View {
        List {

            ForEach (topTier.indices, id: \.self) { a in
                Group {
                    Text(self.topTier[a])

                    ForEach (self.nextTier.indices, id: \.self) { b in

                        Text(self.nextTier[b]).padding(.leading, 20)

                    }
                }
            }
        }
    }
}
