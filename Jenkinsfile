/**
 *  Credentials:
 *      ssh_disp_stage       ssh username (crx) and private key to deploy dispatcher files
 *
 *  Job Parameters:
 *      BRANCH      git branch to checkout
 * */
pipeline {
    agent any
    parameters {
        gitParameter branchFilter: 'origin/(.*)', defaultValue: 'origin/master', name: 'BRANCH', type: 'PT_BRANCH'
    }
    environment {
        DISPATCHER_1 = 'ec2-us-west-dispatche1'
        DISPATCHER_2 = 'ec2-us-west-dispatche2'
    }
    stages {
        stage('checkout') {
            steps {
                git branch: "${params.BRANCH}", credentialsId: 'bitbucket', url: 'https://bitbucket.org/FLTMKT/dispatcher.git'
            }
        }
        stage('dispatcher-1') {
            steps {
                deploy "$DISPATCHER_1"
            }
        }
        stage('dispatcher-2') {
            steps {
                deploy "$DISPATCHER_2"
            }
        }
    }

}

def deploy(hostname) {
    withCredentials([sshUserPrivateKey(
            credentialsId: 'ssh_disp_stage',
            keyFileVariable: 'ssh_identity',
            usernameVariable: 'ssh_username')]) {
        def remote = [:]
        remote.name = hostname
        remote.host = hostname
        remote.identityFile = ssh_identity
        remote.user = ssh_username
        remote.allowAnyHosts = true

        // create a package with dispatcher files. tar will preserve symbolic links
        sh 'tar cfz httpd.gz ./etc'

        // clear the workspace to avoid warnings
        sshCommand remote: remote, command: "rm -rf -- httpd.gz"

        // upload the archive with dispatcher files
        sshPut remote: remote, from: 'httpd.gz', into: '.'

        // unpack the files
        sshCommand remote: remote, command: "tar xfvz httpd.gz"

        // copy dispatcher files to /etc/httpd, exclude readonly files and  ams_default.vars which is env-specific
        sshCommand remote: remote, command: '''
            sudo rsync -rlv \
                        --exclude ams_default.vars \
                        --exclude xforwarded_forcessl_rewrite.rules \
                        --exclude 000_base_whitelist.rules \
                        --exclude security.conf \
                        --exclude dispatcher_vhost.conf \
                        --exclude mimetypes3d.conf \
                        --exclude base_rewrite.rules \
                        ./etc/httpd/conf.d/ /etc/httpd/conf.d/
        '''

        sshCommand remote: remote, command: '''
            sudo rsync -rlv \
                        --exclude ams_* \
                        --exclude dispatcher.any \
                        ./etc/httpd/conf.dispatcher.d/ /etc/httpd/conf.dispatcher.d/
        '''

        // restart httpd
        sshCommand remote: remote, command: 'sudo service httpd restart'
    }
}
