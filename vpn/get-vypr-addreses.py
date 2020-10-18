from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup
from toolz import pipe, first, second, comp, curry, identity
from toolz.curried import drop, take, map, filter, pluck, juxt
from toolz.curried import get as list_get
import re


def simple_get(url):
  with closing(get(url, stream=True)) as resp:
    return resp.content

vypr_page = "https://support.goldenfrog.com/hc/en-us/articles/360011055671-What-are-the-VyprVPN-server-addresses-"
#"https://support.goldenfrog.com/hc/en-us/articles/203733723-What-are-the-VyprVPN-server-addresses-"

raw_html = simple_get(vypr_page)
print(raw_html)
html = BeautifulSoup(raw_html, 'html.parser')

table_selector = '.vpn-server-list tr'

addresses = pipe(html.select(table_selector),
                 drop(1),
                 map(list),
                 pluck([1,3]),
                 map(comp(tuple, map(lambda x: x.text))),
                 map(juxt(first, comp(first, curry(re.findall, r"^[^\.]+"), second))),
                 list)
print(addresses)

path = "connections"
replace_word = 'REPLACE'
template = open('template.ovpn').readlines()
gen_template = lambda addr: [x.replace(replace_word, addr)
                             if replace_word in x else x
                             for x in template]

def write_ovpn(path, file_name, content):
    print("writing", file_name)
    with open(path + "/" + file_name + ".ovpn", 'w') as f:
        f.writelines(content)

for name, addr in addresses:
    write_ovpn(path, name, gen_template(addr))


