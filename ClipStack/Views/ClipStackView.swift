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
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.content)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .font(.body)
                        Text(item.date, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.togglePin(for: item)
                    }) {
                        Image(systemName: item.isPinned ? "pin.fill" : "pin")
                            .foregroundColor(item.isPinned ? .yellow : .gray)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
                .contentShape(Rectangle()) // クリック領域拡大
                .onTapGesture {
                    viewModel.copyToClipboard(item)
                }
            }
        }
        .frame(minWidth: 400, minHeight: 600)
    }
}
