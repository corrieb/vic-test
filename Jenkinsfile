node("docker") {

        git url: "git@github.com:corrieb/vic-test.git", credentialsId: 'github-id'
    
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
        def env_app
        def workdir_app
        def test_vch = "${env["TEST_VCH"]}"
        def registry_id = "${env["REGISTRY_ID"]}"
        def env_image_name = "${registry_id}/df-env-test"
        def workdir_image_name = "${registry_id}/df-workdir-test"
    
        stage ("build") {
           dir ("dockerfile/ENV") {
              env_app = docker.build("${env_image_name}")
           }
           dir ("dockerfile/WORKDIR") {
              workdir_app = docker.build("${workdir_image_name}")
           }
        }

        stage ("publish") {
           withCredentials([usernamePassword(credentialsId: 'docker-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
              sh 'docker login -u $USERNAME -p $PASSWORD'
           }

           env_app.push 'master'
           env_app.push "${commit_id}"
           workdir_app.push 'master'
           workdir_app.push "${commit_id}"
        }
        
        try {
           stage ("pull") {
              sh "docker -H ${test_vch} pull ${env_image_name}:${commit_id}"
              sh "docker -H ${test_vch} pull ${workdir_image_name}:${commit_id}"
           }
           stage ("test") {
              sh "docker -H ${test_vch} run --rm ${env_image_name}:${commit_id}"
              sh "docker -H ${test_vch} run --rm ${workdir_image_name}:${commit_id}"
           }
        } finally {
           stage ("cleanup") {
              sh "docker -H ${test_vch} rmi ${env_image_name}:${commit_id}"
              sh "docker -H ${test_vch} rmi ${workdir_image_name}:${commit_id}"
           }
        }                
}
