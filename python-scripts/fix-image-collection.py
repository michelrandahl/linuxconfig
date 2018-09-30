# execute this before running script:
#   $ ipcluster start -n 4

from ipyparallel import Client
p = Client()[:]
with p.sync_imports():
    from hashlib import md5
    import exifread
    from toolz import pipe, identity, compose, first, second, juxt, curry, merge
    from toolz.curried import map, filter, get, assoc, mapcat

# from ipyparallel.client.remotefunction import remote
from shutil import copy2
import os

@curry
def pmap(fn, xs):
    return p.map_sync(fn, xs)

from_path = './hello'
to_path = './results'

def md5sum(file_path, **rest):
    with open(file_path, "rb") as file_reader:
        return md5(file_reader.read()).hexdigest()
p['md5sum'] = md5sum

def exif_date(file_path, **rest):
    with open(file_path, 'rb') as f:
        exif_tags = exifread.process_file(f)
        if exif_tags:
            return exif_tags['Image DateTime'].values
p['exif_date'] = exif_date

@curry
def file_info(path, file_name):
    xs = file_name.split('.')
    file_path = path + "/" + file_name
    if len(xs) == 2:
        return {"file_name": xs[0],
                "file_type": xs[1],
                "file_path": file_path}

def format_date(exif_date):
    return exif_date.replace(':', '-').replace(' ', 'T')

def new_file_name(file_name, file_type, hash_value, exif_date, **rest):
    if exif_date:
        formatted_date = format_date(exif_date)
        return f"{formatted_date}_{hash_value}.{file_type}"
    else:
        return f"{file_name}_{hash_value}.{file_type}"

def copy_file(to_path, file_path, new_file_name, **rest):
    print(f"{file_path} -> {to_path}/{new_file_name}")
    return copy2(file_path, f"{to_path}/{new_file_name}")

pipe(
    os.walk(from_path),
    map(get([0,2])),
    filter(second),
    mapcat(lambda x: map(file_info(first(x)), second(x))),
    pmap(lambda x: merge(x,
        {'exif_date': exif_date(**x) if x['file_type'] else None,
         'hash_value': md5sum(**x)})),
    map(lambda x: assoc(x, 'new_file_name', new_file_name(**x))),
    #filter(lambda x: x['file_type'] == 'JPG'),
    #map(compose(print, get('new_file_name'))),
    map(lambda x: copy_file(to_path, **x)),
    list,
)


