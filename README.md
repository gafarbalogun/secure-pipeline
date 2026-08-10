# secure-pipeline

This was made a while back, before I really knew Docker or how any of this worked. What I did understand was the basic idea: before code ships to prod, it should get scanned for problems first, not after.

So this is my first attempt at recreating that. A small Flask app, a Dockerfile that runs it as a non-root user, and two scripts that scan it before it deploys:

- [`scripts/app-sec-check.sh`](scripts/app-sec-check.sh) runs [Bandit](https://github.com/PyCQA/bandit) against the app code (static analysis, catches things like hardcoded secrets, unsafe functions, debug mode left on)
- [`scripts/image-check.sh`](scripts/image-check.sh) runs [Trivy](https://github.com/aquasecurity/trivy) against the built image (catches known CVEs in the base image and dependencies)

`deploy.sh` runs both before it builds and starts the container. If either scan fails, the deploy stops.

I'm a lot further along now — see [`cnapp-eks`](https://github.com/gafarbalogun/cnapp-eks) for the current project. Keeping this one around as a record of where it started.
