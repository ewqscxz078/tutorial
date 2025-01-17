try{

  // 定義參數
  //parameters {
  //  choice(name: 'DEPENDENCY_BRANCH_NAME', choices[ 'master', 'PRE_RELEASE/main' ], description: 'which branch to stat dependency')
  //}
  // 改 jenkins 畫面上的參數化設定帶入

  node {
    stage('Checkout'){
      dir('CI') {
        git url: 'https://sris.hgr/git/env/sris-ci.git', branch: 'dev-new-eid', credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('TOOLS') {
        git url: 'https://sris.hgr/git/env/sris-tools.git', branch: 'develop', credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('greenc') {
        git url: 'https://sris.hgr/git/greenc.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('aw-app'){
        git url: 'https://sris.hgr/git/aw-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      //dir('aw-ext'){
      //  git url: 'https://sris.hgr/git/aw-ext.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      //}
      dir('rd-app'){
        git url: 'https://sris.hgr/git/rd-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('sris/sris-ae-app') {
        git url: 'https://sris.hgr/git/ris/sris-ae-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('sris/sris-db-app') {
        git url: 'https://sris.hgr/git/ris/sris-db-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('sris/sris-rs-app') {
        git url: 'https://sris.hgr/git/ris/sris-rs-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('sris/sris-ms-app') {
        git url: 'https://sris.hgr/git/ris/sris-ms-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('sris/sris-rd-app') {
        git url: 'https://sris.hgr/git/ris/sris-rd-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('sris/sris-extra-app') {
        git url: 'https://sris.hgr/git/ris/sris-extra-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      // dir('sris/sris-aw-app') {
      //  git url: 'https://sris.hgr/git/ris/sris-aw-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      // }
      // dir('sris/sris-config') {
      // git url: 'https://sris.hgr/git/ris/sris-config.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      // }
      // dir('sris/sris-nconfig') {
      // git url: 'https://sris.hgr/git/ris/sris-nconfig.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      // }
      // dir('sris/sris-cognos') {
      // git url: 'https://sris.hgr/git/ris/sris-cognos.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      // }
      // dir('sris/sris-helper') {
      // git url: 'https://sris.hgr/git/ris/sris-helper.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      // }
      dir('neid/neid-ae-app') {
        git url: 'https://sris.hgr/git/neid/neid-ae-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-ap-app') {
        git url: 'https://sris.hgr/git/neid/neid-ap-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-as-app') {
        git url: 'https://sris.hgr/git/neid/neid-as-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-cv-app') {
        git url: 'https://sris.hgr/git/neid/neid-cv-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-ds-app') {
        git url: 'https://sris.hgr/git/neid/neid-ds-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-dv-app') {
        git url: 'https://sris.hgr/git/neid/neid-dv-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-em-app') {
        git url: 'https://sris.hgr/git/neid/neid-em-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-es-app') {
        git url: 'https://sris.hgr/git/neid/neid-es-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-id-app') {
        git url: 'https://sris.hgr/git/neid/neid-id-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-me-app') {
        git url: 'https://sris.hgr/git/neid/neid-me-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-sa-app') {
        git url: 'https://sris.hgr/git/neid/neid-sa-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('neid/neid-tkt-app') {
        git url: 'https://sris.hgr/git/neid/neid-tkt-app.git', branch: "${DEPENDENCY_BRANCH_NAME}", credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }
      dir('cloud/sris-cloud-rd') {
        git url: 'https://sris.hgr/git/cloud/sris-cloud-rd.git', branch: '${DEPENDENCY_BRANCH_NAME}', credentialsId: 'a98a8d80-06fe-4215-993c-cf50948e1a76'
      }

    }
    withEnv(['MAIN_TAG=sit']) {
      stage('stats dependency'){
        // for gradle project 指定執行特定 gradle 路徑
        environment {
          GRADLE_USER_HOME = '/home/ccuser/jenkins/gradle-cache'
        }
        sh "CI/stats-dependency.sh ${DEPENDENCY_BRANCH_NAME}"
      }
      stage('archive'){
        // for 提供 url 可 download
        archiveArtifacts artifacts: 'all_stats.tar.gz', fingerprint: true
      }
    }
  }
}catch(Exception e){
  throw e
}
