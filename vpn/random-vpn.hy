#!/usr/bin/env hy
(import [os [listdir system]]
        random
		[os.path [isfile join]]
		[itertools [dropwhile]]
		[pythonping [ping]]
		[toolz [partial]])

(defn get-address [file-name]
  (with [f (open file-name)]
    (->> (.readlines f)
	     (dropwhile (comp not (fn [x] (.startswith x "remote"))))
		 first
		 str.split
		 second)))

(defn ping-avg-rtt [address]
  (. (ping address)
     rtt_avg))

(defn get-vpn-files [file-path]
  (->> (listdir file-path)
       (filter (fn [file] (and (isfile (join file-path file))
	                           (.endswith file ".ovpn"))))
	   list))

(defn sample-vpn-files [file-path sample-size vpn-files]
  (-> vpn-files
      (random.sample sample-size)
	  (->> (map (partial join file-path))
	       (map (juxt identity
		              (comp ping_avg_rtt get-address))))
	  ; #** is unpacking into key-value args
	  (sorted #**{"key" second})
	  dict))

(defn best-vpn [vpn-ping-results]
  (-> vpn-ping-results
	  dict.keys
	  first))

(defn connect-to-vpn [vpn-link]
  (setv command (+ "openvpn --config '"
                   vpn-link
                   "' --writepid /run/openvpn/home.pid "
                   "--auth-user-pass pass.txt"))
  (print "connecting to" vpn-link)
  (print command)
  (system "mkdir -p /run/openvpn")
  (system "touch /run/openvpn/home.pid")
  (system command))

(->> (get-vpn-files "connections/")
     (sample-vpn-files "connections/" 5)
	 ((fn [x] (print x) x))
	 best-vpn
	 connect-to-vpn)
