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
        
        try {
           stage ("pull") {
              sh "docker -H ${env["TEST_VCH"]} pull bensdoings/vch-test:${commit_id}"
           }
           stage ("test") {
              sh "docker -H ${env["TEST_VCH"]} run --rm bensdoings/vch-test:${commit_id}"
           }
        } finally {
           stage ("cleanup") {
              sh "docker -H ${env["TEST_VCH"]} rmi bensdoings/vch-test:${commit_id}"
           }
        }                
}
