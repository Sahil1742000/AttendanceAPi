node {
    // Define environment variables
    def pythonVersion = '3.8'
    def venvDir = '.venv'
    def reportDir = 'reports'

    try {
        stage('Checkout') {
            // Checkout the latest code from the GitHub repository
            checkout scm
        }

        stage('Setup Python Environment') {
            // Set up the Python virtual environment and install dependencies
            sh """
                python${pythonVersion} -m venv ${venvDir}
                source ${venvDir}/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
            """
        }

        stage('Static Code Analysis (Pylint)') {
            // Run static code analysis using pylint
            sh """
                source ${venvDir}/bin/activate
                pylint --output-format=text > ${reportDir}/pylint_report.txt
            """
        }

        stage('Bug Analysis (Snyk or Checkmarx)') {
            // Run static bug analysis with Snyk or Checkmarx
            // Replace with actual tool like Checkmarx if needed
            sh """
                source ${venvDir}/bin/activate
                snyk test --all-projects --json > ${reportDir}/snyk_report.json
            """
        }

        stage('Unit Testing') {
            // Run unit tests using pytest
            sh """
                source ${venvDir}/bin/activate
                pytest --maxfail=5 --disable-warnings --tb=short > ${reportDir}/pytest_report.xml
            """
        }

        stage('Code Coverage (Coverage.py)') {
            // Run code coverage using coverage.py and generate report
            sh """
                source ${venvDir}/bin/activate
                coverage run -m pytest
                coverage report > ${reportDir}/coverage_report.txt
                coverage html -d ${reportDir}/coverage_html_report
            """
        }

        stage('Dependency Scanning (OWASP Dependency-Check)') {
            // Run dependency scanning with OWASP Dependency-Check
            sh """
                source ${venvDir}/bin/activate
                dependency-check --project "Python API" --scan . --out ${reportDir}/dependency_check_report
            """
        }

        stage('Dynamic Application Security Testing (DAST)') {
            // Run DAST with OWASP ZAP
            // Replace `your-api-url.com` with the actual API URL to scan
            sh """
                source ${venvDir}/bin/activate
                zap-baseline.py -t http://your-api-url.com -g gen.conf -r ${reportDir}/zap_report.html
            """
        }

    } catch (Exception e) {
        currentBuild.result = 'FAILURE'
        throw e
    } finally {
        // Always archive reports and test results
        archiveArtifacts allowEmptyArchive: true, artifacts: "${reportDir}/**/*"
        junit "${reportDir}/pytest_report.xml"
        cobertura coberturaReportFile: "${reportDir}/coverage_report.xml"
    }

    // Send failure notifications if needed
    if (currentBuild.result == 'FAILURE') {
        mail to: 'team@example.com', subject: "Build failed in Jenkins", body: "Please check the Jenkins job for details."
    }
}

