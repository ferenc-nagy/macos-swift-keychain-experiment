import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let credentials = vm.credentials {
                VStack(alignment: .leading) {
                    Text("Currently stored")
                    Text("Username: \(credentials.username)")
                    Text("Password: \(credentials.password)")
                    
                    // TODO: anytime I change the value of this text, I have to enter my password again for the keychain
                    Text("Testasdss")
                    Button("Delete existing credentials") {
                        vm.deleteCredentials()
                    }
                    .disabled(vm.credentials == nil)
                }
            } else {
                Text("There are no stored credentials currently!")
            }
            
            Divider().padding([.top, .bottom])
            
            Form {
                VStack(alignment: .leading) {
                    TextField("Enter Username", text: $vm.username)
                    TextField("Enter Password", text: $vm.password)
                    Button("Submit") {
                        vm.updateCredentials()
                    }
                    .disabled(vm.username.isEmpty || vm.password.isEmpty)
                    .padding(.top)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
