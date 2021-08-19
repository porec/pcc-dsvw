node {
    def app

    stage('Clone repository') {
        // Let's make sure we have the repository cloned to our workspace
        checkout scm
    }


    stage('Check image Git dependencies with jenkins plugin') {
       try {
         echo 'before plugin  scanning'
        withCredentials([usernamePassword(credentialsId: 'twistlock_creds', passwordVariable: 'TL_PASS', usernameVariable: 'TL_USER')]) {
        prismaCloudScanCode excludedPaths: '', explicitFiles: '', logLevel: 'debug', pythonVersion: '', repositoryName: 'pcc-dsvw', repositoryPath: '.', resultsFile: 'prisma-cloud-scan-results.json'
         }
        echo 'after  scanning'

        } finally {
          prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
           }
    }

    stage('Build image') {
        // This builds the actual image; synonymous to docker build on the command line
        app = docker.build("porcer/pcc-dsvw:${env.BUILD_ID}")
    }

    stage('Scan Image and Publish to Jenkins') {
        try {
            prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: "porcer/pcc-dsvw:${env.BUILD_ID}", key: '', logLevel: 'debug', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json'
        } finally {
            prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
        }
    }

    stage('Scan image with twistcli') {
        withCredentials([usernamePassword(credentialsId: 'twistlock_creds', passwordVariable: 'TL_PASS', usernameVariable: 'TL_USER')]) {
            sh 'curl -k -u $TL_USER:$TL_PASS --output ./twistcli https://$TL_CONSOLE:8083/api/v1/util/twistcli'
            sh 'sudo chmod a+x ./twistcli'
            sh "./twistcli images scan --u $TL_USER --p $TL_PASS --address https://$TL_CONSOLE:8083  --details porcer/pcc-dsvw:${env.BUILD_ID}"
        }
    }

    stage('Publish') {
      withDockerRegistry([ credentialsId: 'docker-hub-credentials', url: '' ]) {
        app.push("${env.BUILD_NUMBER}")
        app.push("latest")
          }
      }

      stage('Deploy Vulnerable Web Python Application') {
          sh 'sudo kubectl apply -f deploy/pcc-dsvw.yaml'
          sh 'sudo sleep 10'
      }

}
