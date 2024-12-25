import SwiftUI
import SwiftData

struct EditSnipets: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var folders: [Folder]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(folders) { folder in
                    NavigationLink {
                        Text("Folder at \(folder.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(folder.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteFolder)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            .toolbar {
                ToolbarItem {
                    Button(action: addFolder) {
                        Label("Add Folder", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addFolder() {
        withAnimation {
            let newFolder = Folder(name: "Test")
            modelContext.insert(newFolder)
        }
    }

    private func deleteFolder(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(folders[index])
            }
        }
    }
}

#Preview {
    EditSnipets()
        .modelContainer(for: Folder.self, inMemory: true)
}
