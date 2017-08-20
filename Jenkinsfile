node("docker") {

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
           withCredentials([usernamePassword(credentialsId: 'docker-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
              sh 'docker login -u $USERNAME -p $PASSWORD'
           }

           app.push 'master'
           app.push "${commit_id}"
        }
        
        stage('test') {
           dir ("dockerfile/ENV") {
              withEnv(["DOCKER_HOST=${env["TEST_VCH"]}"]) {
                 sh 'export'
                 sh 'docker run bensdoings/vch-test:master'
              }
           }
        }
}
