from os import listdir
from os.path import isfile, join

mypath = "/etc/openvpn/OpenVPN256/"

def fix_file(filename):
    fix_line = lambda line: "dev tun0\n" if line.startswith("dev tun") else line
    with open(join(mypath, filename)) as f:
        fixed_lines = list(map(fix_line, f.readlines()))
        with open(filename, 'w') as foo:
            foo.writelines(fixed_lines)
        return fixed_lines

for f in filter(lambda f: isfile(join(mypath, f)) and f.endswith(".ovpn"), listdir(mypath)):
    print(f)
    fix_file(f)
