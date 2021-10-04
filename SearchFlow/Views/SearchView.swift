//
//  SearchView.swift
//  SearchFlow
//
//  Created by Chr1s on 2021/10/4.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var vm: ViewModel
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack {
                searchBarView()
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding()
                
                if let list = vm.listData {
                    if list != [] {
                        List {
                            searchResultView(list)
                        }.listStyle(GroupedListStyle())
                        .background(Color.clear)
                    } else {
                        Spacer()
                        Text("No result").bold()
                    }
                }
                Spacer()
            }
        }
    }
}

extension SearchView {
    
    func searchBarView() -> some View {
        
        HStack {
            
            FirstResponderTextField(text: $text, placeholder: "Tap here to search") {
                vm.searchPublisher.send(text)
            }
            .frame(height: 20)
            .autocapitalization(.none)
            
            Image(systemName: "xmark")
                .onTapGesture {
                    vm.isSearch = false
                }
        }
    }
}

extension SearchView {
    
    func searchResultView(_ list: StockInfo) -> some View {
        ForEach(list, id: \.self) { item in
            Section(header: Text(item.category)) {
                ForEach(item.content, id: \.self) { content in
                     searchResultContent(content)
                }
            }
        }
    }
    
    func searchResultContent(_ content: Content) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(content.name).bold()
                Text(content.type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("$\(content.price, specifier: "%.2f")")
                .foregroundColor(content.frozen == 1 ? .blue : .gray)
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .background(content.frozen == 1 ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(12)
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
