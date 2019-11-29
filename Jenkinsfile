pipeline {
	agent {
		label 'ARM64 && Docker'
	}
	parameters {
//		string(name: 'OVERRIDE', defaultValue: 'stable', description: 'Version to use (tested with "stable" & "mainline")(don't add "-alpine")', trim: true)
		string(name: 'OVERRIDERUNADDITIONALCONTAINER', defaultValue: 'intrepidde/arm64-forego:latest', description: 'foergo container to use', trim: true)
	}
	triggers {
		cron('H H(2-7) * * 2')
	}
	options {
		skipStagesAfterUnstable()
		disableResume()
		timestamps()
	}
	environment {
		DEBUG = "1"
		REGISTRY = "intrepidde"
		EMAIL_TO = 'olli.jenkins.prometheus@intrepid.de'
		NAME = "arm64-nginx-proxy"
		SECONDARYREGISTRY = "nexus.intrepid.local:4000"
		SECONDARYNAME = "${NAME}"
		TARGETSTRING = "NGINX_VERSION"
		BASETYPE = "nginx"
		BASECONTAINER = "arm64v8/nginx:stable-alpine"
		SECONDARYSOFTWAREVERSION = "0.7.4"
		SECONDARYSOFTWARESTRING = "<<DOCKERGENVERSION>>"
		ADDITIONALCONTAINER = "${OVERRIDERUNADDITIONALCONTAINER}"
		ADDITIONALCONTAINERTRANSFER = "${NAME}-transport"
		ADDITIONALCONTAINERSTRING = "<<TRANSFER>>"
	}
	stages {
		stage('Build') {
			environment {
				ACTION = "build"
			}
			steps {
				sh '/bin/bash ./action.sh'
			}
		}
		stage('Push') {
			environment {
				ACTION = "push"
			}
			steps {
				sh '/bin/bash ./action.sh'
			}
		}
	}
	post {
		always {
			cleanWs()
		}
		success {
			echo 'BUILD OK'
		}
		failure {
			emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}',
			to: EMAIL_TO,
			subject: 'Build failed in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
		}
		unstable {
			emailext body: 'Check console output at $BUILD_URL to view the results. \n\n ${CHANGES} \n\n -------------------------------------------------- \n${BUILD_LOG, maxLines=100, escapeHtml=false}',
			to: EMAIL_TO,
			subject: 'Unstable build in Jenkins: $PROJECT_NAME - #$BUILD_NUMBER'
		}
		changed {
			emailext body: 'Check console output at $BUILD_URL to view the results.',
			to: EMAIL_TO,
			subject: 'Jenkins build is back to normal: $PROJECT_NAME - #$BUILD_NUMBER'
		}
	}
}
