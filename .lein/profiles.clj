{:user {}
 :mnie {:dependencies [[com.bhauman/rebel-readline "0.1.4"]
                       [org.clojure/tools.namespace "1.1.0"]]
        :injections [(require '[clojure.tools.namespace.repl])
                     (require '[clojure.pprint])
                     (require '[clojure.repl])
                     (def rf clojure.tools.namespace.repl/refresh)
                     (def rf-all clojure.tools.namespace.repl/refresh-all)
                     (def pp clojure.pprint/pprint)
                     (defmacro doc [f] `(clojure.repl/doc ~f))]
        :aliases {"rebl" ["trampoline" "run" "-m" "rebel-readline.main"]}
        :pedantic? :warn}
 :ice [:base :system :user :provided :dev :kaocha :mnie] ;; merge profiles into one
 ;;:repl-options {;; Defaults to 30000 (30 seconds)
 ;;               :timeout 120000}
 }
