//
//  WordsListPage.swift
//  BeyondU-Halogen
//
//  Created by 한경준 on 2022/05/29.
//

import SwiftUI
import Combine

struct WordsListPage: View {
    
    @Binding var count: Int
    @State var words: [String] = []
    
    var body: some View {
        //다양한 기기 해상도에 대응하기 위해 GeometryReader를 사용
        GeometryReader {geo in
            
            List {
                ForEach(words, id: \.self) { word in
                    Text(word)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height*5/7)
            .cornerRadius(16)
            .position(x: geo.size.width/2, y: geo.size.height*3/8)
            
            
            //영단어 개수 입력용 텍스트필드
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 48.0)
                            .foregroundColor(Color(UIColor.systemGray5))
                        TextField("생성할 영단어 개수를 입력하세요", value: $count, formatter: NumberFormatter())
                            //숫자 키패드 표시
                            .keyboardType(.numberPad)
                            //텍스트필드에 숫자만 입력되도록 합니다.(클립보드 방지)
                            //formatter 썼더니 int로 filter를 사용 못 하는 오류 발생
    //                        .onReceive(Just(count)) { newValue in
    //                            let filtered = newValue.filter { "0123456789".contains($0) }
    //                            if filtered != newValue {
    //                                self.count = filtered
    //                            }
    //                        }
                            .padding(.horizontal, 12.0)
                    }
                    Text("1부터 15 사이의 숫자를 입력해주세요")
                        .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color(UIColor.systemGray))
                }
            .position(x: geo.size.width/2, y: geo.size.height*5/6)
            //VStackEnd
            
            
            //영단어 생성 버튼
            Button(action: {
                Task {
                    do {
                        let url = URL(string: "https://random-word-api.herokuapp.com/word?number=\(count)")
                        let (data, _) = try await URLSession.shared.data(from: url!)
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode([String].self, from: data)
                        words = decoded
                    } catch {
                        
                    }
                }
            }) {
                Text("\(count)개의 영단어 생성하기")
                //                    Text(numberOfWords<=15 ?"\(numberOfWords)개의 영단어를 생성합니다." :"단어 수를 입력하세요")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: geo.size.width, height: 64)
                    .background(Color(UIColor.systemBlue))
                    .cornerRadius(16)
            }
            .position(x: geo.size.width/2, y: geo.size.height-40)
        }
        //GeoReaderPadding
        .padding(.horizontal, 16.0)
        .task {
            do {
                let url = URL(string: "https://random-word-api.herokuapp.com/word?number=\(count)")
                let (data, _) = try await URLSession.shared.data(from: url!)
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([String].self, from: data)
                words = decoded
            } catch {
                
            }
        }

    }
}
//
//struct WordsListPage_Previews: PreviewProvider {
//    static var previews: some View {
//        WordsListPage(count: $count)
//    }
//}

