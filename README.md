# rib
Release In Build: VSTS Task - create and run release in build (intended for use to add release as a branch policy)

## What Is rib?

Although it is possible to add a build as a branch policy in VSTS, it is not yet currently possible to add a release as a branch policy. Consequently you are unable to run tests that require a deployment of code or infrastructure. However if you call a release via the VSTS REST API within a build you can kick off the release. In fact we needto take this back one step and kick off the build that starts a release after the build that creates the artifacts for the release has completed creating all artifacts. 
