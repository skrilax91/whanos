languages = ["c", "java", "javascript", "python", "befunge"]

languages.each { language ->
	freeStyleJob("Whanos base images/whanos-$language") {
		steps {
			shell("docker build /images/$language -f /images/$language/Dockerfile.base -t whanos-$language")
		}
	}
}

freeStyleJob("Whanos base images/Build all base images") {
	publishers {
		downstream(languages.collect { language -> "Whanos base images/whanos-$language" })
	}
}

freeStyleJob("link-project") {
	parameters {
        stringParam("NAME", null, "Name for the job")
		stringParam("IMAGE_NAME", "my-image", "Name of the image (e.g.: 'my-project')")
		stringParam("GIT_URL", null, 'Git repository url (e.g.: "https://github.com/skrilax91/Kappa-Engine")')
        stringParam("GIT_BRANCH", "main", 'Git branch (e.g.: "main")')

        // Registry parameters
        booleanParam("PUSH", false, "Push to registry")
        stringParam("REGISTRY", "docker.io", "Registry url")
        stringParam("REGISTRY_USER", null, "Registry user")
        stringParam("REGISTRY_PASSWORD", null, "Registry password")
        stringParam("REGISTRY_REPO", null, "Registry repository (e.g.: 'devix69/whanos')")
        stringParam("REGISTRY_TAG", "latest", "Registry tag (e.g.: 'latest')")

        booleanParam("DEPLOY", true, "Deploy image using whanos.yml")
	}
	steps {
		dsl {
			text('''
				freeStyleJob("Projects/$NAME") {
					scm {
						git {
                            branch("$GIT_BRANCH")
							remote {
								name("origin")
								url("$GIT_URL")
							}
						}
					}
					triggers {
						scm("* * * * *")
					}
					wrappers {
						preBuildCleanup()
					}
					steps {
						shell("/jenkins/scripts/build.sh \\"$IMAGE_NAME\\"")
                        shell("/jenkins/scripts/push.sh \\"$PUSH\\" \\"$IMAGE_NAME\\" \\"$REGISTRY\\" \\"$REGISTRY_USER\\" \\"$REGISTRY_PASSWORD\\" \\"$REGISTRY_REPO\\" \\"$REGISTRY_TAG\\"")
						shell("/jenkins/scripts/deploy.sh \\"$REGISTRY_REPO\\" \\"$REGISTRY_TAG\\" \\"$IMAGE_NAME\\"")
					}
				}
			''')
		}
	}
}