#!/usr/bin/env hy
(import requests
		re
		[contextlib [closing]]
		[bs4 [BeautifulSoup]]
		[toolz [pluck partial]]
        [requests.exceptions [RequestException]])

(setv vypr-page
 "https://support.goldenfrog.com/hc/en-us/articles/360011055671-What-are-the-VyprVPN-server-addresses-")

(defn fetch-page [url]
  (with [resp (closing (requests.get url #**{"stream" True}))]
    resp.content))

(defn get-soup [html-content]
  (BeautifulSoup html-content "html.parser"))

(defn get-addresses [html-soup]
  (->> (.select html-soup ".vpn-server-list tr")
       (drop 1)
	   (map list)
	   (pluck [1 3])
	   (map (comp tuple (partial map (fn [x] x.text))))
	   (map (juxt first
	              (comp first (partial re.findall "^[^\.]+") second)))))

(->> (fetch-page vypr-page)
     get-soup
	 get-addresses
	 list
     print)
