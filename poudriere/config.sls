include:
  - poudriere.install

{% set poudriere = salt.pillar.get('poudriere') %}

poudriere_conf:
  file.managed:
    - name: /usr/local/etc/poudriere.conf
    - source: {{ poudriere.conf }}
    - user: root
    - group: wheel
    - require:
      - pkg: poudriere

poudriere_pkglist:
  file.recurse:
    - name: /usr/local/etc/poudriere.d/pkglist
    - source: {{ poudriere.pkg_list }}
    - dir_mode: 755
    - file_mode: 644
    - user: root
    - group: wheel
    - template: jinja
    - require:
      - pkg: poudriere

{% for make_conf in poudriere.make_conf %}
poudriere_{{ make_conf }}:
  file.managed:
    - name: {{ '/usr/local/etc/poudriere.d' | path_join(make_conf) }}
    - contents_pillar: poudriere:make_conf:{{ make_conf }}
    - user: root
    - group: wheel
    - mode: 644
{% endfor %}
