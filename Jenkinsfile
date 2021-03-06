pipeline {
  agent { label 'static' }

  stages {
    stage('Set up Stack dependencies') {
      steps {
        sh 'stack exec --package=hlint -- true'
      }
    }

    stage('Initial validation') {
      parallel {
        stage('Lint the pushed code') {
          steps {
            sh 'stack exec --package=hlint -- hlint -v --git'
          }
        }

        stage('Compile the project') {
          steps {
            sh '''
              stack build \
                --ghc-options "-optc-static -optl-static -fhide-source-paths -Werror" \
                --flag amuletml:amc-prove-server \
                --test --no-run-tests -j3 \
                --fast
            '''
          }
        }
      }
    }

    stage('Run the test suite') {
      steps {
        sh '''
          env AMC_LIBRARY_PATH=${PWD}/lib \
          stack test \
            --flag amuletml:amc-prove-server \
            --test-arguments "+RTS -A128M -RTS -j4 --xml junit.xml --display t -v" \
            --fast
        '''
      }
    }

    stage('Compile for deployment') {
      steps {
        sh 'env FAST="--fast" tools/deploy-build.sh'
      }
    }
  }

  post {
    always {
      junit 'junit.xml'
    }

    success {
      archiveArtifacts artifacts: 'result/*'
    }
  }
}
