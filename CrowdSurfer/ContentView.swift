import SwiftUI
import PythonKit
import AVKit


struct ContentView: View {
    @StateObject var loginModel: LoginViewModel = .init()
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 500, height: 900)
                
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.clear, lineWidth: 0)
                        .background(Color.black.opacity(0.5))
                )
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("Welcome")
                            .foregroundColor(.white)
                            .font(Font.system(size: 60).weight(.bold).smallCaps())
                            .shadow(color: Color.white, radius: 2)
                        
                        Text("Login with Columbia credentials")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.bottom, 30)
                            .shadow(color: Color.white, radius: 2)
                        
                        CustomTextField(hint: "Email", text: $loginModel.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 350)
                        
                        CustomTextField(hint: "Password", text: $loginModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: 350)
                            .padding(.bottom, 30)
                        
                        NavigationLink(
                            destination: AnyView(loginModel.emailAddress.hasSuffix("COLUMBIA.EDU") ? AnyView(NewPage()) : AnyView(EmptyView())),
                            label: {
                                Text("Login")
                                    .padding()
                                    .font(Font.system(size: 20).weight(.bold).smallCaps())
                                    .foregroundColor(.white)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            }
                        )
                    }
                }
                .padding(.top, 300)
            }
        }
    }
}

struct CustomTextField: View {
    var hint: String
    @Binding var text: String
    var contentType: UITextContentType = .emailAddress
    var contentType2: UITextContentType = .password
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField(hint, text: $text)
                .textContentType(contentType)
                .padding()
        }
    }
}

struct Library: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct LibraryDetail: View {
    let library: Library
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Details for \n\(library.name)")
                .bold()
                .font(Font.system(size: 40).weight(.bold).smallCaps())
                .foregroundColor(.white)
                .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 50)
                .padding(.bottom, 50)
            Stats(value: 12)
            Text("Live View")
                .font(Font.system(size: 30).weight(.bold).smallCaps())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 50)
            VideoPlayerView(videoURL: Bundle.main.url(forResource: "output_video", withExtension: "MOV")!)
                            .frame(height: 300)
                            .padding()
        }
        .background(Color.black)
    }
    
    struct VideoPlayerView: UIViewControllerRepresentable {
        var videoURL: URL

        func makeUIViewController(context: Context) -> AVPlayerViewController {
            let controller = AVPlayerViewController()
            controller.player = AVPlayer(url: videoURL)
            controller.player?.play()
            return controller
        }

        func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
            // Update the view if needed
        }
    }
    
    func runObjectDetection() {
            PythonLibrary.useVersion(3, 11)
            let cv2 = Python.import("cv2")
            let YOLO = Python.import("ultralytics.YOLO")
            let model = YOLO("yolov8n.pt")
            let videoPath = "/Users/sultana/Downloads/DevFest/IMG_6017.MOV"
            let cap = cv2.VideoCapture(0)
            
            while Bool(cap.isOpened)! {
                let success = cap.read()
                let frame = cap.read()
                if Bool(success)! {
                    let results = model.track(frame, persist: true)
                    let annotated_frame = results[0].plot()
                    cv2.imshow("YOLOv8 Tracking", annotated_frame)
                    if Python.eval("cv2.waitKey(1) & 0xFF == ord('q')") == true {
                        break
                    }
                }
                else {
                    break
                }
            }
            cap.release()
            cv2.destroyAllWindows()
        }
}


    
    struct Stats: View {
        let value: Int
        
        var body: some View {
            Rectangle()
                .fill(colorForIndex(value))
                .frame(width: 350, height: 50)
                .overlay{
                    Text("Open Seats: " + String(value))
                        .foregroundColor(.white)
                    .font(.headline)}
                .cornerRadius(10)
        }
        
        private func colorForIndex(_ value: Int) -> Color {
            switch value {
            case 1...5:
                return .red
            case 6...10:
                return .yellow
            case 10...:
                return .green
            default:
                return .gray
            }
        }
    }
    
    
    struct NewPage: View {
        let libraries = [
            Library(name: "Butler", imageName: "Butler"),
            Library(name: "Avery", imageName: "Avery"),
            Library(name: "Milstein", imageName: "Milstein"),
            Library(name: "Engineering", imageName: "Engineering"),
            Library(name: "Business", imageName: "Business")
        ]
        
        let dining = [
            Library(name: "Ferris", imageName: "Ferris"),
            Library(name: "JJ", imageName: "JJ"),
            Library(name: "John Jay", imageName: "JohnJay"),
            Library(name: "Fac House", imageName: "FacHouse"),
            Library(name: "Grace Dodge", imageName: "GradeDodge")
        ]
        
        var body: some View {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    Text("Browse For Crowds")
                        .bold()
                        .font(Font.system(size: 40).weight(.bold).smallCaps())
                        .foregroundColor(.white)
                        .shadow(color: .white, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 40)
                    Text("Can't find a study spot during midterms? We got you! Need a group of 4 spots at Ferris? No problem!")
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    VStack(spacing: 50) {
                        LibrarySection(title: "Libraries", libraries: libraries)
                        LibrarySection(title: "Dining", libraries: dining)
                    }
                    .padding(.top, 50)
                }
                .background(Color.black)
            }
        }
    }
    
    struct LibrarySection: View {
        let title: String
        let libraries: [Library]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(Font.system(size: 25).weight(.bold))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(libraries) { library in
                            NavigationLink(destination: LibraryDetail(library: library)) {
                                LibraryItem(library: library)
                            }
                        }
                    }
                    .padding(.horizontal, 7)
                }
            }
        }
    }
    
    
    struct LibraryItem: View {
        let library: Library
        
        var body: some View {
            VStack {
                Image(library.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 100)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0)
                            .background(Color.black.opacity(0.3))
                            .shadow(color: .gray, radius: 2)
                    )
                    .overlay(
                        Text(library.name)
                            .foregroundColor(.white)
                            .shadow(color: Color.black, radius: 2)
                    )
            }
            .padding(.horizontal, 5)
        }
    }
    
    class LoginViewModel: ObservableObject {
        @Published var emailAddress: String = ""
        @Published var password: String = ""
    }
    
    

#Preview {
    ContentView()
}
