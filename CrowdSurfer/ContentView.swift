import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticationSuccessful = false
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .frame(width: 500, height: 900)
                .cornerRadius(15)
            
            VStack {
                Text("Welcome!")
                    .foregroundColor(.white)
                    .font(Font.system(size: 60).weight(.bold).smallCaps())
                    .offset(y: -27)
                
                VStack {
                    TextField("Columbia Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        authenticate()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color.black.opacity(0.5))
                .cornerRadius(15)
                .padding()
                .offset(y: 100)
                
                if isAuthenticationSuccessful {
                    Text("Authentication Successful!")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
        .padding()
    }
    
    private func authenticate() {
        // Implement your authentication logic here.
        // Check if the entered email and password are valid Columbia University credentials.
        // For simplicity, let's consider authentication successful if the email contains "@columbia.edu".
        if email.lowercased().contains("@columbia.edu") {
            isAuthenticationSuccessful = true
        } else {
            isAuthenticationSuccessful = false
            // Optionally, you can show an error message.
        }
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
