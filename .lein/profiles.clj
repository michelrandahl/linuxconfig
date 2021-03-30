{:user {}
 :mnie {:dependencies [[com.bhauman/rebel-readline "0.1.4"]
                       [org.clojure/tools.namespace "1.1.0"
                        ;; solving dependency conflicts for ICE projects
                        :exclusions [org.clojure/tools.reader]]
                       [org.clojure/tools.reader "1.3.2"]
                       [org.clojure/test.check "0.10.0"]
                       [orchestra "2021.01.01-1"]]
        :injections [(require '[clojure.tools.namespace.repl]
                              '[clojure.pprint]
                              '[clojure.repl]
                              '[clojure.spec.gen.alpha :as gen]
                              '[clojure.spec.alpha :as s]
                              '[orchestra.spec.test :as orchestra-st])

                     (defn rf []
                       (clojure.tools.namespace.repl/refresh)
                       (orchestra-st/instrument))
                     (def rf-all clojure.tools.namespace.repl/refresh-all)
                     (def pp clojure.pprint/pprint)
                     (defmacro doc [f] `(clojure.repl/doc ~f))
                     (def gen (comp gen/generate s/gen))]
        :aliases {"rebl" ["trampoline" "run" "-m" "rebel-readline.main"]}
        :pedantic? :warn}
 :ice [:base :system :user :provided :dev #_:test :kaocha :mnie] ;; merge profiles into one
 ;;:repl-options {;; Defaults to 30000 (30 seconds)
 ;;               :timeout 120000}
 }
