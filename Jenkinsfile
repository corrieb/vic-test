def createBuildAndPush(dockerfile_dir, image_name, commit_id) {
  return {
    stage("Build and push image ${image_name}") { 
      node("docker") {
         def app
         dir ("${dockerfile_dir}") {
            app = docker.build("${image_name}")
         }
         app.push "${commit_id}"
         app.push 'master'
      }
    }
  }
}

// Required due to JENKINS-27421
@NonCPS
List<List<?>> mapToList(Map map) {
  return map.collect { it ->
    [it.key, it.value]
  }
}

node("docker") {

        git url: "git@github.com:corrieb/vic-test.git", credentialsId: 'github-id'
    
        sh "git rev-parse HEAD > .git/commit-id"
        def commit_id = readFile('.git/commit-id').trim()
        println commit_id
        def env_app
        def workdir_app

        def test_vch = "${env["TEST_VCH"]}"
        def registry_id = "${env["REGISTRY_ID"]}"

        def images = [
           "dockerfile/ENV": "${registry_id}/df-env-test",
           "dockerfile/WORKDIR": "${registry_id}/df-workdir-test",
        ]
        
        work = [:]
        for (kv in mapToList(images)) {
            work[kv[0]] = createBuildAndPush(kv[0], kv[1], "${commit_id}")
        }
 
        withCredentials([usernamePassword(credentialsId: 'docker-id', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
           sh 'docker login -u $USERNAME -p $PASSWORD'
        }

        parallel work
        
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
