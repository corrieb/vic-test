node("docker") {
    docker.withRegistry('https://registry.hub.docker.com', 'docker-id') {
    
        git url: "git@github.com:corrieb/vic-test.git", credentialsId: 'github-id'
    
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
    
        stage "build"
        def app = docker.build "vch-test/dockerfile/ENV"
    
        stage "publish"
        app.push 'master'
        app.push "${commit_id}"
    }
}