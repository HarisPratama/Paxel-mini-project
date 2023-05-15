//
//  HomeView.swift
//  Test
//
//  Created by Haris Pratama on 15/05/23.
//

import SwiftUI


struct HomeView: View {
    @State private var keyword: String = ""
    @State var results = [Items]()
    @State private var isLoading = false
    
    var body: some View {
        VStack() {
            HStack() {
                HStack {
                    TextField("Type a project's name", text: $keyword)
                        .disableAutocorrection(true)
                    
                    Button(
                        action: loadData,
                        label: {
                            Text("Search")
                                .font(.custom("Poppins-Bold", size: 14))
                                .foregroundColor(Color("Navy"))
                        }
                    )
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Gray"), lineWidth: 1)
                )
            }
            .padding(.horizontal, 30.0)
            
            if isLoading {
                ProgressView("Loading...")
            } else {
                List(results, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Button(action: {
                            if let url = URL(string: item.html_url) {
                                UIApplication.shared.open(url)
                            }
                        }){
                            HStack{
                                Image(systemName: "person.fill").data(url:  URL(string: item.owner.avatar_url)!)
                                    .frame(width: 100.0, height: 100.0)
                                VStack(alignment: .leading){
                                    Text(item.full_name)
                                        .font(.custom("Poppins-SemiBold", size: 22))
                                        .foregroundColor(Color("Navy"))
                                    Text(item.owner.login)
                                        .font(.custom("Poppins-SemiBold", size: 16))
                                        .foregroundColor(Color("Orange"))
                                    Text(item.description ?? "-").font(.custom("Poppins-SemiBold", size: 16))
                                        .foregroundColor(Color("Gray"))
                                }
                                
                            }
                        }
                    }.padding(.horizontal, 30.0)
                }
                .refreshable {
                    loadData()
                }
                .listStyle(PlainListStyle()) // set the list style to plain
                .foregroundColor(.white)
            }
        }
        .frame(
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
    
    func loadData() {
        // Define the URL endpoint
        isLoading = true
        let url = URL(string: "https://api.github.com/search/repositories?q=" + keyword)!

        // Create a URLSession instance
        let session = URLSession.shared

        // Create a data task to retrieve the data from the API
        let task = session.dataTask(with: url) { data, response, error in
            // Handle any errors that occur
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Ensure that a response was received
            guard let response = response as? HTTPURLResponse else {
                print("No response received")
                return
            }
            
            // Ensure that the response was successful
            guard response.statusCode == 200 else {
                print("Invalid status code: \(response.statusCode)")
                return
            }
            
            // Ensure that the data was received
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Decode the data into a custom struct or class using JSONDecoder
            let decoder = JSONDecoder()
            do {
                let todo = try decoder.decode(Resp.self, from: data)
                DispatchQueue.main.async {
                    isLoading = false
                }
                self.results = todo.items
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()

        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension Image {
    func data(url:URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage:  UIImage(data: data)!).resizable()
        }
        
        return self.resizable()
    }
}
