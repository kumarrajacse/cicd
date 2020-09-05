pipeline{
    agent any
    stages{
        stage('checkout'){
            steps{
               git 'https://github.com/kumarrajacse/cicd.git'
            }
        }
        stage('Build'){
            steps{
               sh 'mvn clean package'
            }
            post{
                success{
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage('SonarQube analysis') {
            steps{
                withSonarQubeEnv('sonar'){
                   sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.6.0.1398:sonar'
                }
            }
			}
        stage ('building docker image'){
          steps
            {
           echo "building the docker image "
           sh 'docker build -t kumarartech/tomcat:2.0 .'
            }
            }
		
		stage('Push the docker image to hub'){
		steps
		{
		echo "login into docker hub "
		withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'passwd', usernameVariable: 'username')]) 
		{
		sh 'docker login -u ${username} -p ${passwd}'
		}
		sh 'docker push kumarartech/tomcat:2.0'
		}
	    }
	stage('Creating an infrastructure using terraform') 
          {
		  steps
		  {
		  
           withCredentials([string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                      string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')])
           {
            
           sh script: """
           terraform init
           terraform apply -auto-approve
           
           """       
         }
        }
		}
    stage('Deploying to the k8 environment')
        {
		steps {
           
             sleep 30
            sh script:"""
            
            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu  -i ~/workspace/$JOB_NAME/inventory --private-key=/home/ubuntu/privkey Installingdocker.yml
            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu  -i ~/workspace/$JOB_NAME/inventory --private-key=/home/ubuntu/privkey installingk8.yml -v
            ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu  -i ~/workspace/$JOB_NAME/inventory --private-key=/home/ubuntu/privkey Deploymentk8.yml 
            """
           sleep 30
		   }
        } 
       
     }
	
    }


