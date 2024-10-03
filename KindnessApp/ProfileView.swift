import Foundation
import SwiftUI
import CoreData

struct ProfileView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: ProfileBadge.entity(), sortDescriptors: []) var badges: FetchedResults<ProfileBadge>
    
    @FetchRequest(entity: UserProfile.entity(), sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var grade = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                ProfileImage(imageName: "my-profile").padding()
                if let userProfile = userProfiles.first {
                    Text("Total Points: \(userProfile.totalPoints)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#95D2DB"))
                        .padding()
                }
                Form {
                    Section(header: Text("Personal Info")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Grade", text: $grade)
                    }
                }
                HStack {
                    ForEach(badges, id: \.self) { badge in
                        Image(badge.imageName ?? "badge1000")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                HStack {
                    NavigationLink(destination: LogView()) {
                        Image("log").resizable()
                            .scaledToFit().frame(width:70, height:70).clipShape(Circle())
                    }
                    NavigationLink(destination: FeedView()) {
                        Image("feed").resizable()
                            .scaledToFit().frame(width:70, height:70).clipShape(Circle())
                    }
                    NavigationLink(destination: CalView()) {
                        Image("cal").resizable()
                            .scaledToFit().frame(width:70, height:70).clipShape(Circle())
                    }
                }
            }
            .navigationTitle("Profile")
        }.navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.pink)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let context = DataController().container.viewContext
        return ProfileView()
            .environment(\.managedObjectContext, context)
    }
}

struct ProfileImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            .shadow(radius: 10)
    }
}
struct LogView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: ProfileBadge.entity(), sortDescriptors: []) var badges: FetchedResults<ProfileBadge>
    
    @FetchRequest(
        entity: KindnessAct.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \KindnessAct.points, ascending: true)]
    ) var kindnessActs: FetchedResults<KindnessAct>
    
    @FetchRequest(entity: UserProfile.entity(), sortDescriptors: []) var userProfiles: FetchedResults<UserProfile>

    @State private var showingCustomAct = false
    @State private var customActTitle = ""
    @State private var customActPoints = ""
    
    var body: some View {
        ScrollView {
            ForEach(kindnessActs, id: \.self) { act in
                VStack(alignment: .leading) {
                    ImageTextView(image: Image(act.imageName ?? "defaultImage"), title: act.name ?? "", subtitle: "\(act.points) points")
                    Spacer()
                    Button("Log") {
                        logKindnessAct(kindnessAct: act)
                    }.padding()
                        .background(Color(hex: "#95D2DB"))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .frame(minHeight: 200)
            }
            Button("Log your own") {
                showingCustomAct = true
            }.padding()
                .background(Color(hex: "#37AEDD"))
                .cornerRadius(10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .sheet(isPresented: $showingCustomAct) {
            CustomActEntryView(customActTitle: $customActTitle, customActPoints: $customActPoints) { title, points in
                if let pointsValue = Int16(points), !title.isEmpty {
                    let newAct = KindnessAct(context: moc)
                    newAct.name = title
                    newAct.points = Int64(pointsValue)
                    newAct.imageName = "userAdded"
                    logKindnessAct(kindnessAct: newAct)
                }
                showingCustomAct = false
                customActTitle = ""
                customActPoints = ""
            }
        }
        .navigationTitle("Log Kindness Act")
    }
    
    func logKindnessAct(kindnessAct: KindnessAct) {
        guard let userProfile = userProfiles.first else { return }
        
        userProfile.totalPoints += kindnessAct.points
        checkAndAssignBadge(for: userProfile.totalPoints)
        
        do {
            try moc.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }

    func checkAndAssignBadge(for points: Int64) {
        let milestones = [1000, 2000, 3000]
        let existingBadges = userProfiles.first?.badges as? Set<ProfileBadge> ?? []
        
        for milestone in milestones {
            if points >= Int64(milestone) && !existingBadges.contains(where: { $0.milestone == Int64(milestone) }) {
                let newBadge = ProfileBadge(context: moc)
                newBadge.milestone = Int64(milestone)
                newBadge.imageName = "badge\(milestone)"
                userProfiles.first?.addToBadges(newBadge)
            }
        }
    }
}

struct CustomActEntryView: View {
    @Binding var customActTitle: String
    @Binding var customActPoints: String
    var onSave: (String, String) -> Void
    
    var body: some View {
        VStack {
            TextField("Title", text: $customActTitle)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Points", text: $customActPoints)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save") {
                onSave(customActTitle, customActPoints)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct FeedView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ImageTextView(
                    image: Image("log"),
                    title: "Title",
                    subtitle: "Sub goes here"
                )
                
                ImageTextView(
                    image: Image("cal"),
                    title: "Title",
                    subtitle: "Subtitle here"
                )
                
                ImageTextView(
                    image: Image("feed"),
                    title: "Title",
                    subtitle: "Subtitle here"
                )
            }
        }
        .navigationTitle("Find Inspiration")
    }
}

struct CalView: View {
    var body: some View {
        VStack {
            Button {
                // Action
            } label: {
                Label("see upcoming kindness activities", systemImage: "heart.circle")
            }
        }
        .navigationTitle("Calendar")
    }
}

struct ImageTextView: View {
    var image: Image
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            image.resizable().aspectRatio(contentMode: .fit).clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .fontWeight(.black)
                
                Text(subtitle)
                    .font(.headline)
            }
            .padding(10)
        }
        .padding(.bottom, 20)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue:  Double(b) / 255, opacity: Double(a) / 255)
    }
}
