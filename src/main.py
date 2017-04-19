#!/usr/bin/env python3

import os
import re
import jinja2
from datetime import datetime

# template = jinja2.Template('Hello {{ name }}!')
# template.render(name='John Doe')

PATH_gen       = os.environ.get('PATH_gen')
PATH_templates = os.environ.get('PATH_templates')

env = jinja2.Environment(
    loader=jinja2.FileSystemLoader(searchpath=PATH_templates),
)

def extract_org_info(org):
    info = dict()
    fp = open(org)
    for line in fp.readlines():
        if not line.startswith('#+'): break
        match = re.match('\#\+(?P<key>\w+): ?(?P<val>.*)', line)
        if match is None: return
        key = match.group('key').lower()
        val = match.group('val')
        if key in 'updated date':
            d   = datetime.strptime(val, "%Y %b %d, %A").date()
            val = d.strftime("%Y %b %d ")

        info[key] = val

    return info


def gen_page(_template, out, args):
    template_obj = env.get_template(_template)
    template_obj.stream(args).dump(out)


def gen_blog(article):
    path = os.path.join(PATH_gen, article)
    out  = os.path.join(path, 'index.html')
    info = extract_org_info(os.path.join(article, 'main.org'))
    gen_page('blog.djhtml', out, info)

# gen_page(
#     'home.djhtml',
#     'gen/index.html',
#     {
#         'title'   : 'home',
#         'content' : open('home.html').read()
#     }
# )
# if __name__ == '__main__':
#     gen_blog('blog/004-qgis/')
