pipeline {
	agent {
		label 'master'
	}
//	parameters {
//		string(name: 'OVERRIDE', defaultValue: 'stable', description: 'Version to use (tested with "stable" & "mainline")(don't add "-alpine")', trim: true)
//		string(name: 'OVERRIDERUNADDITIONALCONTAINER', defaultValue: 'intrepidde/arm64-forego:latest', description: 'foergo container to use', trim: true)
//	}
	triggers {
		cron('H H(3-8) * * 2')
	}
	options {
//		skipStagesAfterUnstable()
		disableResume()
		timestamps()
		timeout(time: 4, unit: 'HOURS') 
	}
	environment {
		DEBUG = "1"
		REGISTRY = "intrepidde"
		EMAIL_TO = 'olli.jenkins.prometheus@intrepid.de'
		SECONDARYREGISTRY = "nexus.intrepid.local:4000"
		TARGETSTRING = "NGINX_VERSION"
		BASETYPE = "nginx"
		SECONDARYSOFTWAREVERSION = "0.7.4"
		SECONDARYSOFTWARESTRING = "<<DOCKERGENVERSION>>"
		ADDITIONALCONTAINERSTRING = "<<TRANSFER>>"
	}
	stages {
		stage('ARM64') {
			agent {
				label 'ARM64 && Docker'
			}
			environment {
				ACTION = "all"
				NAME = "arm64-nginx-proxy"
				SECONDARYNAME = "${NAME}"
				BASECONTAINER = "arm64v8/nginx:stable-alpine"
				ADDITIONALCONTAINERTRANSFER = "${NAME}-transport"
				ADDITIONALCONTAINER = "intrepidde/arm64-forego:latest"
			}
			steps {
				sh '/bin/bash ./action.sh'
			}
		}
		stage('ARM32V6') {
			agent {
				label 'arm32v6 && Docker'
			}
			environment {
				ACTION = "all"
				NAME = "rpi-nginx-proxy"
				SECONDARYNAME = "${NAME}"
				BASECONTAINER = "arm32v6/nginx:stable-alpine"
				ADDITIONALCONTAINERTRANSFER = "${NAME}-transport"
				ADDITIONALCONTAINER = "intrepidde/rpi-forego:latest"
			}
			steps {
				sh '/bin/bash ./action.sh'
			}
		}
	}
}
