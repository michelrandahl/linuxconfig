{:user {}
 :utility-functions-light
 {:dependencies [[com.bhauman/rebel-readline "0.1.4"]
                 [org.clojure/tools.namespace "1.1.0"
                  ;; solving dependency conflicts for ICE projects
                  :exclusions [org.clojure/tools.reader]]]
  :injections [(require '[clojure.tools.namespace.repl]
                        '[clojure.pprint]
                        '[clojure.repl]
                        '[clojure.spec.alpha :as s]
                        '[clojure.walk]
                        '[clojure.java.io]
                        '[clojure.string])

               (def pp clojure.pprint/pprint)
               (defmacro doc [f] `(clojure.repl/doc ~f))
               (def rf clojure.tools.namespace.repl/refresh)

               (def sfom s/form)
               (defn expand-spec [spec]
                 (->> spec
                      s/form
                      (clojure.walk/prewalk
                       #(cond-> %
                          (qualified-keyword? %) ((comp (partial into {})
                                                        vector
                                                        (juxt str s/form)))))
                      pp))

               (defn duplicate-imports [project-path]
                 (let [has-duplicates (fn [file-object]
                                        (let [file-path (.getAbsolutePath file-object)
                                              imports (->> file-path
                                                           slurp
                                                           read-string
                                                           (filter (every-pred seq? (comp #{:require} first)))
                                                           first
                                                           (filter vector?))
                                              set-count (count (set imports))
                                              list-count (count imports)]
                                          (when (< set-count list-count)
                                            {:file-name file-path
                                             :set-count set-count
                                             :list-count list-count
                                             :require (sort imports)})))]
                   (->> project-path
                        clojure.java.io/file
                        file-seq
                        (filter (every-pred #(.isFile %)
                                            (comp #{"clj" "cljc"}
                                                  last
                                                  #(clojure.string/split % #"\.")
                                                  str
                                                  #(.getFileName (.toPath %)))))
                        (remove (comp #{"project.clj"} #(.getFileName (.toPath %))))
                        (keep has-duplicates))))]
  :aliases {"rebl" ["trampoline" "run" "-m" "rebel-readline.main"]}
  :pedantic? :warn}
 :utility-functions-heavy
 {:dependencies [[com.bhauman/rebel-readline "0.1.4"]
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
                        '[orchestra.spec.test :as orchestra-st]
                        '[clojure.walk]
                        '[clojure.java.io]
                        '[clojure.string])

                     (def gen (comp gen/generate s/gen))

                     (def rf-all clojure.tools.namespace.repl/refresh-all)
                     (defn rf []
                       (let [refresh-result (clojure.tools.namespace.repl/refresh)]
                         (case refresh-result
                           :ok (let [[number namespaces] ((juxt count (comp vec sort set (partial map namespace)))
                                                          (orchestra-st/instrument))]
                                 (println "Instrumented namespaces:")
                                 (pp namespaces)
                                 (println "Number of instrumented functions: " number))
                           refresh-result)))]
  :aliases {"rebl" ["trampoline" "run" "-m" "rebel-readline.main"]}
  :pedantic? :warn}
 :ice [:base :system :user :provided :dev :test :kaocha :utility-functions-light :utility-functions-heavy] ;; merge profiles into one
 :thin-ice [:base :system :user :provided :dev :test :kaocha :utility-functions-light] ;; merge profiles into one
 :my-nvd {:plugins [[lein-nvd "1.4.1"]]
          :nvd {}
          :pedantic? :warn}
 ;;:repl-options {;; Defaults to 30000 (30 seconds)
 ;;               :timeout 120000}
 }
