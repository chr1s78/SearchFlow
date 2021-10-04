//
//  HomeView.swift
//  SearchFlow
//
//  Created by Chr1s on 2021/10/4.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            
            ZStack {
                
                Color(.systemGray6).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    
                    searchBar()
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("Search")
        }
    }
}

extension HomeView {
    
    func searchBar() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            
            Button(action: {
                vm.isSearch = true
            }, label: {
                Text("Tap here to search")
                    .foregroundColor(.black.opacity(0.7))
            })
            
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
