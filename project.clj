(defproject sqlite-graalvm-sample "v0.2.8"
  :description "A sample to test graalvm native image with sqlite/jdbc"
  :url "http://github.com/ericdallo/sqlite-graalvm-sample"
  :license {:name "EPL-2.0 OR GPL-2.0-or-later WITH Classpath-exception-2.0"
            :url "https://www.eclipse.org/legal/epl-2.0/"}
  :dependencies [[org.clojure/clojure "1.10.2"]
                 [org.xerial/sqlite-jdbc "3.34.0"]
                 [seancorfield/next.jdbc "1.1.613"]]
  :jvm-opts ["-Dclojure.compiler.direct-linking=true"
             "-Dclojure.spec.skip-macros=true"]
  :profiles  {:uberjar      {:aot :all}
              :native-image {:dependencies [[ericdallo/sqlite-jni-graal-fix "0.0.3-graalvm-21.0.0"
                                             :exclusions [org.graalvm.nativeimage/svm]]
                                            [org.graalvm.nativeimage/svm "21.0.0"]]}}
  :main sqlite-graalvm-sample.core
  :repl-options {:init-ns sqlite-graalvm-sample.core})
