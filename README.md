# secure-pipeline

**Reusable for:** demonstrating and adapting a *local* deployment gate that checks application code and a Docker image before replacing a running container.

This is a small Flask application, a Dockerfile using a non-root runtime user, and Bash scripts that combine two security checks:

- [`scripts/app-sec-check.sh`](scripts/app-sec-check.sh) invokes **Bandit** against `app/` (`-ll`, medium/high severity) and writes `security-report.json`.
- [`scripts/image-check.sh`](scripts/image-check.sh) invokes **Trivy** against `secure-app:latest` and exits unsuccessfully for HIGH or CRITICAL findings.
- [`deploy.sh`](deploy.sh) builds and scans the new image **before** replacing the existing `secure-app` container.

## Try the example

**Requirements:** Bash, Docker Engine running locally, the `bandit` CLI, and the `trivy` CLI on your `PATH`. Install them from their respective official projects for your operating system.

```bash
git clone https://github.com/gafarbalogun/secure-pipeline.git
cd secure-pipeline
chmod +x deploy.sh scripts/*.sh
./deploy.sh
```

If the security gates pass, the Flask app runs locally at <http://localhost:5050>:

```bash
curl --fail http://localhost:5050/
docker ps --filter name=secure-app
```

The expected HTTP response is `Hello, Flask!`. If either scanner fails, the script exits without replacing the existing container. Scanner results depend on current advisories, image contents, and tool versions; a fresh clone is **not guaranteed to pass**.

To run the checks independently:

```bash
./scripts/app-sec-check.sh
docker build -t secure-app:latest .
./scripts/image-check.sh
```

## Adapt it for your own lab

1. Change `app/` and `app/requirements.txt` to represent the application you want to test.
2. Adjust the `Dockerfile` for that application's runtime.
3. Review Bandit's `-ll` threshold and Trivy's HIGH/CRITICAL threshold for your use case.
4. Keep the build-and-scan-before-replacement order so a failed scan does not stop the old container.

## Scope and limitations

This is an educational **local deployment pattern**, not a production-ready CI/CD pipeline. It does not provide zero-downtime deployment, rollback, registry signing, integration with a CI runner, or comprehensive security coverage. A failed container launch after the old container is removed can still cause downtime. Review dependencies and run it in a lab environment.

The reference can be expanded as new checks or examples become useful; it does not need to be considered permanently "finished" to be reusable.
