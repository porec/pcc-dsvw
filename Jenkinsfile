node {
    def app

    stage('Clone Repository to Build Server') {
        // Let's make sure we have the repository cloned to our workspace
        checkout scm
    }


    stage('Check image dependencies using Prisma Cloud Compute Policies') {
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

    stage('Scan Image using Prisma Cloud Compute Policies and Publish to Jenkins') {
        try {
            prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: "porcer/pcc-dsvw:${env.BUILD_ID}", key: '', logLevel: 'debug', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json'
        } finally {
            prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
        }
    }

    stage('Scan Image using Prisma Cloud Compute Policies with twistcli tool') {
        withCredentials([usernamePassword(credentialsId: 'twistlock_creds', passwordVariable: 'TL_PASS', usernameVariable: 'TL_USER')]) {
            sh 'curl -k -u $TL_USER:$TL_PASS --output ./twistcli https://$TL_CONSOLE:8083/api/v1/util/twistcli'
            sh 'sudo chmod a+x ./twistcli'
            sh "./twistcli images scan --u $TL_USER --p $TL_PASS --address https://$TL_CONSOLE:8083  --details porcer/pcc-dsvw:${env.BUILD_ID}"
        }
    }

    stage('Publish Image to Repository') {
      withDockerRegistry([ credentialsId: 'docker-hub-credentials', url: '' ]) {
        app.push("${env.BUILD_NUMBER}")
        app.push("latest")
          }
      }

      stage('Check deployment file with Checkov') {
      	try {
                   response = sh(script:"checkov --file deploy/pcc-dsvw.yaml -o junitxml > result.xml || true", returnStdout:true).trim() // -o junitxml > result.xml || true"
      	           print "${response}"
                   junit skipPublishingChecks: true, testResults: "result.xml"
      	}
      	catch (err) {
                  echo err.getMessage()
                  echo "Error detected"
      	}
      }

      stage('Check deployment file with BridgeCrew integration') {
      try {
      	     withCredentials([
                  	string(
                    		credentialsId: 'bc-api-key',
                    		variable: 'BC_API')
                   ]) {
      		response = sh(script:"checkov --file deploy/pcc-dsvw.yaml --bc-api-key $BC_API --repo-id porec/pcc-dsvw -b main")
                   }
      	     print "${response}"
      	}
      	catch (err) {
                  echo err.getMessage()
                  echo "Results are published in BridgeCrew Console"
      	}
      }

      stage('Deploy Application') {
          sh 'sudo kubectl apply -f deploy/pcc-dsvw.yaml'
          sh 'sudo sleep 10'
      }

}
