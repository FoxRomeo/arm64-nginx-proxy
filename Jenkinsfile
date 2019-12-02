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
	}
	environment {
		DEBUG = "1"
		NAMEBASE = "nginx-proxy"
		REGISTRY = "intrepidde"
		SECONDARYREGISTRY = "nexus.intrepid.local:4000"
		EMAIL_TO = 'olli.jenkins.prometheus@intrepid.de'
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
			options {
				timeout(time: 1, unit: 'HOURS') 
			}
			environment {
				NAME = "arm64-${NAMEBASE}"
				SECONDARYNAME = "${NAME}"
				BASECONTAINER = "arm64v8/nginx:stable-alpine"
				ADDITIONALCONTAINERTRANSFER = "${NAME}-transport"
				ADDITIONALCONTAINER = "intrepidde/arm64-forego:latest"
			}
			stages {
				stage('Build'){
					environment {
						ACTION = "build"
					}
					steps {
						sh '/bin/bash ./action.sh'
					}
				}
				stage('Push'){
					environment {
						ACTION = "push"
					}
					steps {
						sh '/bin/bash ./action.sh'
					}
				}
			}
		}
		stage('ARM32V6') {
			agent {
				label 'arm32v6 && Docker'
			}
			options {
				timeout(time: 4, unit: 'HOURS') 
			}
			environment {
				NAME = "rpi-${NAMEBASE}"
				SECONDARYNAME = "${NAME}"
				BASECONTAINER = "arm32v6/nginx:stable-alpine"
				ADDITIONALCONTAINERTRANSFER = "${NAME}-transport"
				ADDITIONALCONTAINER = "intrepidde/rpi-forego:latest"
			}
			stages {
				stage('Build'){
					environment {
						ACTION = "build"
					}
					steps {
						sh '/bin/bash ./action.sh'
					}
				}
				stage('Push'){
					environment {
						ACTION = "push"
					}
					steps {
						sh '/bin/bash ./action.sh'
					}
				}
			}
		}
	}
}
