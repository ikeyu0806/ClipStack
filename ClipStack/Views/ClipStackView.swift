import SwiftUI

struct ClipStackView: View {
    @StateObject private var viewModel = ClipStackViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("ClipStack")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button("Clear") {
                    viewModel.clearHistory()
                }
            }
            .padding()
            
            List(viewModel.history) { item in
                VStack(alignment: .leading) {
                    Text(item.content)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .font(.body)
                    Text(item.date, style: .time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle()) // クリック判定を広げる
                .onTapGesture {
                    viewModel.copyToClipboard(item)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 600)
    }
}
