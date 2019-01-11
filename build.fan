using build

class Build : BuildPod {

    new make() {
        podName = "afRedux"
        summary = "State Machine"
        version = Version("0.0.1")

        meta = [
            "pod.dis"       : "Redux",
            "afIoc.module"  : "afRedux::ReduxModule",
            "repo.tags"     : "sys",
            "repo.public"   : "true"
        ]

        index   = [ "afIoc.module"  : "afRedux::ReduxModule" ]

        depends = [
            "sys        1.0.71 - 1.0",
            "concurrent 1.0.71 - 1.0",


            // ---- Core ------------------------
            "afIoc        3.0.0  - 3.0",
            "afConcurrent 1.0.20 - 1.0",
        ]

        srcDirs = [`fan/`, `fan/public/`, `test/`]
        resDirs = [`doc/`]
    }
}