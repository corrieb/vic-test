node("docker") {

    withCredentials([usernamePassword(credentialsId: 'docker-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
       sh 'docker login -u $USERNAME -p $PASSWORD'
    }

        git url: "git@github.com:corrieb/vic-test.git", credentialsId: 'github-id'
    
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
        def app
    
        stage ("build") {
           dir ("dockerfile/ENV") {
              app = docker.build("bensdoings/vch-test")
           }
        }

        stage ("publish") {
           app.push 'master'
           app.push "${commit_id}"
        }
}
