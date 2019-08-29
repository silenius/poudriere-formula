include:
  - poudriere.install
  - poudriere.config

{% set poudriere = salt.pillar.get('poudriere') %}

{% for jail in poudriere.jails %}
poudriere_jail_{{ jail.label }}:
  cmd.run:
    - name: poudriere jail -c -j {{ jail.label }} -v {{ jail.version }}
    - shell: /bin/sh
    - unless: poudriere jail -i -j {{ jail.label }}
    - require:
      - file: poudriere_conf
{% endfor %}
